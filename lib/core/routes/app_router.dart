import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reminders/core/routes/route_names.dart';
import 'package:flutter_reminders/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_reminders/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_reminders/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter_reminders/features/home/presentation/pages/home_page.dart';
import 'package:flutter_reminders/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter_reminders/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter_reminders/features/reminder/domain/entities/reminder_entity.dart';
import 'package:flutter_reminders/features/reminder/presentation/pages/add_reminder_page.dart';
import 'package:flutter_reminders/features/reminder/presentation/pages/reminder_list_page.dart';
import 'package:flutter_reminders/init_dependency.dart';
import 'package:go_router/go_router.dart';

import '../../features/reminder/presentation/bloc/reminder_bloc.dart';
import '../storage/token_storage.dart';

const _publicRoutes = {RouteNames.splash, RouteNames.login, RouteNames.signup};

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  redirect: (context, state) async {
    // Uses the existing TokenStorage.isLoggedIn() (already checks token presence + expiry, auto-clears on expiry).
    // Any deep link to home, profile, reminders, addReminder, or editReminder while logged out now bounces to /login.
    // Hitting /login directly while already authenticated bounces to /home.
    // splash is deliberately left alone (not force-redirected either way) so its existing 5-second animation + AuthBloc.checkAuthStatus() flow keeps working as before.

    final isLoggedIn = await serviceLocator<TokenStorage>().isLoggedIn();
    final isPublicRoute = _publicRoutes.contains(state.matchedLocation);

    if (!isLoggedIn && !isPublicRoute) {
      return RouteNames.login;
    }
    final isAuthPage =
        state.matchedLocation == RouteNames.login ||
        state.matchedLocation == RouteNames.signup;
    if (isLoggedIn && isAuthPage) {
      return RouteNames.home;
    }
    return null;
  },
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
      path: RouteNames.signup,
      builder: (context, state) => const SignupPage(),
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
      path: RouteNames.reminders,
      builder: (context, state) => BlocProvider(
        create: (_) => serviceLocator<ReminderBloc>(),
        child: const ReminderListPage(),
      ),
    ),
    GoRoute(
      path: RouteNames.addReminder,
      builder: (context, state) => BlocProvider(
        create: (_) => serviceLocator<ReminderBloc>(),
        child: const AddReminderPage(),
      ),
    ),
    GoRoute(
      path: RouteNames.editReminder,
      builder: (context, state) => BlocProvider(
        create: (_) => serviceLocator<ReminderBloc>(),
        child: AddReminderPage(reminder: state.extra as ReminderEntity?),
      ),
    ),
  ],
);
