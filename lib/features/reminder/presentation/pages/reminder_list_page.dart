import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reminders/core/routes/route_names.dart';
import 'package:flutter_reminders/core/theme/app_colors.dart';
import 'package:flutter_reminders/core/utils/date_time_utils.dart';
import 'package:flutter_reminders/core/widgets/snackbar_widget.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';
import 'package:flutter_reminders/features/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:go_router/go_router.dart';

class ReminderListPage extends StatefulWidget {
  const ReminderListPage({super.key});

  @override
  State<ReminderListPage> createState() => _ReminderListPageState();
}

class _ReminderListPageState extends State<ReminderListPage> {
  static const _pageSize = 10;

  final _scrollController = ScrollController();
  List<ReminderEntity> _reminders = [];
  int _currentPage = 0;
  int _lastPage = 1;
  bool _hasLoadedOnce = false;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadReminders();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasLoadedOnce || _isLoadingMore || _currentPage >= _lastPage) {
      return;
    }
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadReminders() {
    context.read<ReminderBloc>().add(
      const ReminderEvent.getReminders(page: 1, limit: _pageSize),
    );
  }

  void _loadMore() {
    setState(() => _isLoadingMore = true);
    context.read<ReminderBloc>().add(
      ReminderEvent.getReminders(page: _currentPage + 1, limit: _pageSize),
    );
  }

  Future<void> _openEdit(ReminderEntity reminder) async {
    await context.push(
      '${RouteNames.reminders}/${reminder.id}/edit',
      extra: reminder,
    );
    if (mounted) _loadReminders();
  }

  Future<bool> _confirmDelete(ReminderEntity reminder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reminder'),
        content: Text('Are you sure you want to delete "${reminder.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  void _showReminderDetails(ReminderEntity reminder) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reminder.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(reminder.description),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16),
                  const SizedBox(width: 8),
                  Text(DateTimeUtils.apiDateToDisplay(reminder.reminderDate)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 8),
                  Text(DateTimeUtils.apiTimeToDisplay(reminder.reminderTime)),
                ],
              ),
              if (reminder.images.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: reminder.images.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        reminder.images[index].imageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openEdit(reminder);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _deleteReminder(ReminderEntity reminder) {
    setState(() => _reminders.removeWhere((r) => r.id == reminder.id));
    context.read<ReminderBloc>().add(
      ReminderEvent.deleteReminder(id: reminder.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: BlocConsumer<ReminderBloc, ReminderState>(
        listener: (context, state) {
          state.whenOrNull(
            failure: (message) {
              AppSnackbar.showError(context, message);
              setState(() => _isLoadingMore = false);
            },
            remindersLoaded: (reminders) => setState(() {
              final pagination = reminders.pagination;
              _reminders = pagination.currentPage == 1
                  ? [...reminders.reminders]
                  : [..._reminders, ...reminders.reminders];
              _currentPage = pagination.currentPage;
              _lastPage = pagination.lastPage;
              _hasLoadedOnce = true;
              _isLoadingMore = false;
            }),
            deleteSuccess: () {
              AppSnackbar.showSuccess(
                context,
                'Reminder deleted successfully!',
              );
              _loadReminders();
            },
          );
        },
        builder: (context, state) {
          final loading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          if (loading && !_hasLoadedOnce) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_reminders.isEmpty) {
            return const Center(child: Text('No reminders yet.'));
          }

          return RefreshIndicator(
            onRefresh: () async => _loadReminders(),
            child: ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _reminders.length + (_isLoadingMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index >= _reminders.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final reminder = _reminders[index];
                return Dismissible(
                  key: ValueKey(reminder.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmDelete(reminder),
                  onDismissed: (_) => _deleteReminder(reminder),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  ),
                  child: Card(
                    child: ListTile(
                      onTap: () => _showReminderDetails(reminder),
                      title: Text(reminder.title),
                      subtitle: Text(
                        '${reminder.description}\n${reminder.reminderDate} ${reminder.reminderTime}',
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _openEdit(reminder),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.addReminder),
        child: const Icon(Icons.add),
      ),
    );
  }
}
