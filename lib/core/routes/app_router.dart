import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reminders/core/routes/route_names.dart';
import 'package:flutter_reminders/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_reminders/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter_reminders/features/home/presentation/pages/home_page.dart';
import 'package:flutter_reminders/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter_reminders/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_reminders/features/reminder/presentation/pages/add_reminder_page.dart';
import 'package:flutter_reminders/init_dependency.dart';
import 'package:go_router/go_router.dart';

import '../../features/reminder/presentation/bloc/reminder_bloc.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteNames.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: RouteNames.profile,
      builder: (context, state) => BlocProvider(
        create: (_) => serviceLocator<ProfileCubit>(),
        child: const ProfilePage(),
      ),
    ),
    GoRoute(
      path: RouteNames.addReminder,
      builder: (context, state) => BlocProvider(
        create: (_) => serviceLocator<ReminderBloc>(),
        child: const AddReminderPage(),
      ),
    ),
  ],
);
