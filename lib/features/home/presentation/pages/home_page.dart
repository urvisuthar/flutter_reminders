import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reminders/core/settings/settings_cubit.dart';
import 'package:flutter_reminders/core/utils/extentions.dart';
import 'package:flutter_reminders/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routes/route_names.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(RouteNames.login);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.home),
          leading: Icon(Icons.menu),
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
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context).pop();
            },
            child: Text(context.l10n.logout),
          ),
        ],
      ),
    );
  }
}
