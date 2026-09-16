import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/core/theme/app_theme.dart';
import 'package:idiomatic_app/core/widgets/app_button.dart';
import 'package:idiomatic_app/core/widgets/app_text_field.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _nativeLanguage = 'ru';

  @override
  void dispose() {
    _nameController.dispose();
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
            } else if (state.status == AuthStatus.authenticated) {
              Navigator.of(context).popUntil((route) => route.isFirst);
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
                      Text('Create account', style: AppTheme.serifItalic(context, size: 30)),
                      const SizedBox(height: 6),
                      Text(
                        'Start building your speaking vocabulary today.',
                        style: TextStyle(fontSize: 13.5, color: colors.textSecondary),
                      ),
                      const SizedBox(height: 26),
                      AppTextField(label: 'Name', controller: _nameController, placeholder: 'Aigerim'),
                      const SizedBox(height: 14),
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
                      const SizedBox(height: 14),
                      Text(
                        'TRANSLATION LANGUAGE FOR CARDS',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: colors.textSecondary, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _LangOption(label: 'Russian', value: 'ru', selected: _nativeLanguage == 'ru', onTap: () => setState(() => _nativeLanguage = 'ru'))),
                          const SizedBox(width: 6),
                          Expanded(child: _LangOption(label: 'Kazakh', value: 'kz', selected: _nativeLanguage == 'kz', onTap: () => setState(() => _nativeLanguage = 'kz'))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      AppPrimaryButton(
                        label: 'Create Account',
                        isLoading: state.isSubmitting,
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthSignupRequested(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                                displayName: _nameController.text.trim(),
                                nativeLanguage: _nativeLanguage,
                              ));
                        },
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(fontSize: 13.5, color: colors.textSecondary),
                              children: [
                                const TextSpan(text: 'Already have an account? '),
                                TextSpan(text: 'Log in', style: TextStyle(color: colors.primary, fontWeight: FontWeight.w700)),
                              ],
                            ),
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

class _LangOption extends StatelessWidget {
  const _LangOption({required this.label, required this.value, required this.selected, required this.onTap});

  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? colors.primary : colors.border, width: 1.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected ? colors.onPrimary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
