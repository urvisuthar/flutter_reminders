import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reminders/core/widgets/snackbar_widget.dart';
import 'package:flutter_reminders/core/widgets/textformfield_widget.dart';
import 'package:flutter_reminders/features/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/widgets/app_button.dart';

class AddReminderPage extends StatefulWidget {
  const AddReminderPage({super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  String _rawDate = '';
  String _rawTime = '';
  final List<File> _selectedImages = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(picked.map((e) => File(e.path)));
      });
    }
  }

  void _removeImage(int index) =>
      setState(() => _selectedImages.removeAt(index));

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.read<ReminderBloc>().add(
          ReminderEvent.addReminder(
            title: _titleController.text,
            description: _descriptionController.text,
            reminderDate: _rawDate,
            reminderTime: _rawTime,
            images: _selectedImages,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Reminder')),
      body: BlocConsumer<ReminderBloc, ReminderState>(
        listener: (context, state) {
          state.whenOrNull(
            failure: (message) => AppSnackbar.showError(context, message),
            success: (_) {
              AppSnackbar.showSuccess(context, 'Reminder added successfully!');
              context.pop();
            },
          );
        },
        builder: (context, state) {
          final loading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: _titleController,
                      label: 'Reminder Title',
                      hint: 'Enter Title',
                      prefixIcon: Icons.text_fields_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _descriptionController,
                      hint: 'Enter Description',
                      label: 'Reminder Description',
                      prefixIcon: Icons.description,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description is required';
                        }
                        return null;
                      },
                      minLines: 1,
                      maxLines: null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _dateController,
                      hint: 'Select Date',
                      label: 'Reminder Date',
                      prefixIcon: Icons.calendar_today,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Date is required';
                        }
                        return null;
                      },
                      isDatePicker: true,
                      onChanged: (value) {
                        _rawDate = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _timeController,
                      hint: 'Select Time',
                      label: 'Reminder Time',
                      prefixIcon: Icons.access_time,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Time is required';
                        }
                        return null;
                      },
                      isTimePicker: true,
                      onChanged: (value) {
                        _rawTime = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Images (optional)',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextButton.icon(

                          onPressed: _pickImages,
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                          label: const Text('Add'),
                        ),
                      ],
                    ),

                    if (_selectedImages.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          separatorBuilder: (_,_) => const SizedBox(width: 8),
                          itemBuilder: (context, index) => Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImages[index],
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Add Reminder',
                      onPressed: () => _submitForm(),
                      isLoading: loading,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
