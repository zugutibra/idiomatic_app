import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/core/di/injection_container.dart';
import 'package:idiomatic_app/core/theme/app_theme.dart';
import 'package:idiomatic_app/core/theme/theme_cubit.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:idiomatic_app/features/auth/presentation/pages/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<ThemeCubit>.value(value: sl<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, darkMode) {
          return MaterialApp(
            title: 'Idiomatic',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
