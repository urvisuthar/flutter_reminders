import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reminders/core/routes/route_names.dart';
import 'package:flutter_reminders/core/theme/app_colors.dart';
import 'package:flutter_reminders/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      context.read<AuthBloc>().add(CheckAuthStatusRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(RouteNames.home);
          print("LOGGED IN");
        } else if (state is AuthUnauthenticated) {
          print("NOT LOGGED IN");
          context.go(RouteNames.login);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(child: CupertinoActivityIndicator()),
      ),
    );
  }
}
