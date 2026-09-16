import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/core/theme/app_theme.dart';
import 'package:idiomatic_app/core/widgets/app_button.dart';
import 'package:idiomatic_app/core/widgets/app_text_field.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:idiomatic_app/features/auth/presentation/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.asset(
                                'assets/idiomatic-logo-255.png',
                                width: 64,
                                height: 64,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text('Idiomatic', style: AppTheme.serifItalic(context, size: 42, color: colors.primary)),
                            const SizedBox(height: 8),
                            Text(
                              'Speak fluently. Sound natural.',
                              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: colors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 34),
                      AppTextField(
                        label: 'Email',
                        controller: _emailController,
                        placeholder: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        label: 'Password',
                        controller: _passwordController,
                        placeholder: '••••••••',
                        obscureText: true,
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Forgot password?', style: TextStyle(color: colors.primary)),
                        ),
                      ),
                      const SizedBox(height: 6),
                      AppPrimaryButton(
                        label: 'Log In',
                        isLoading: state.isSubmitting,
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthLoginRequested(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              ));
                        },
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Expanded(child: Divider(color: colors.border)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text('OR', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: colors.textTertiary)),
                          ),
                          Expanded(child: Divider(color: colors.border)),
                        ],
                      ),
                      const SizedBox(height: 26),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 13.5, color: colors.textSecondary),
                            children: [
                              const TextSpan(text: 'New to Idiomatic? '),
                              TextSpan(
                                text: 'Create an account',
                                style: TextStyle(color: colors.primary, fontWeight: FontWeight.w700),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const SignupPage()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
