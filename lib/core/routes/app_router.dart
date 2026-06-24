import 'package:flutter_reminders/core/routes/route_names.dart';
import 'package:flutter_reminders/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_reminders/features/auth/presentation/pages/splash_page.dart';
import 'package:flutter_reminders/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';

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
  ],
);
