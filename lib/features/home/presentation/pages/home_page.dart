import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reminders/core/settings/settings_cubit.dart';
import 'package:flutter_reminders/core/storage/local_storage.dart';
import 'package:flutter_reminders/core/utils/extentions.dart';
import 'package:flutter_reminders/init_dependency.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_names.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final LocalStorage _localStorage = serviceLocator<LocalStorage>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.whenOrNull(unauthenticated: () => context.go(RouteNames.login));
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(context.l10n.home),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () => context.read<SettingsCubit>().toggleTheme(),
            ),
            IconButton(
              icon: const Icon(Icons.translate),
              onPressed: () => showLanguageDialog(),
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                showLogoutDialog();
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundImage: _localStorage.getProfilePicture() != null
                          ? NetworkImage(_localStorage.getProfilePicture()!)
                          : null,
                      child: _localStorage.getProfilePicture() == null
                          ? Icon(
                              Icons.person,
                              size: 30,
                              color: Theme.of(context).colorScheme.primary,
                            )
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _localStorage.getUsername() ?? 'User',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _localStorage.getEmail() ?? '',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: Text(context.l10n.home),
                selected: true,
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.of(context).pop();
                  context.push(RouteNames.profile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: const Text("Toggle Theme"),
                onTap: () {
                  context.read<SettingsCubit>().toggleTheme();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.translate),
                title: const Text("Language"),
                onTap: () {
                  Navigator.of(context).pop();
                  showLanguageDialog();
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text(context.l10n.logout),
                onTap: () {
                  Navigator.of(context).pop();
                  showLogoutDialog();
                },
              ),
            ],
          ),
        ),
        body: Center(child: Text(context.l10n.welcome)),
      ),
    );
  }

  // In showLanguageDialog()
  void showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("English"),
              onTap: () {
                context.read<SettingsCubit>().changeLocale(const Locale('en'));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text("हिंदी"),
              onTap: () {
                context.read<SettingsCubit>().changeLocale(const Locale('hi'));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(context.l10n.logout),
        content: Text(context.l10n.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEvent.logoutRequested());
              Navigator.of(context).pop();
            },
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
  }
}
