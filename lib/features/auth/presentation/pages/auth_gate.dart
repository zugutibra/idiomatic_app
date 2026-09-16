import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:idiomatic_app/features/auth/presentation/pages/login_page.dart';
import 'package:idiomatic_app/features/home/presentation/pages/home_shell.dart';

/// Chooses between the login flow and the authenticated home shell based on
/// whether a cached session exists, matching the design's `screen: 'login'`
/// vs `screen: 'home'` state.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.unknown:
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          case AuthStatus.authenticated:
            return const HomeShell();
          case AuthStatus.unauthenticated:
            return const LoginPage();
        }
      },
    );
  }
}
