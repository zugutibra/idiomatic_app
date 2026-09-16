import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/core/di/injection_container.dart';
import 'package:idiomatic_app/core/theme/app_theme.dart';
import 'package:idiomatic_app/core/theme/theme_cubit.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:idiomatic_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/topic.dart';
import 'package:idiomatic_app/features/progress/presentation/bloc/progress_cubit.dart';
import 'package:idiomatic_app/features/progress/presentation/bloc/progress_state.dart';
import 'package:idiomatic_app/features/quiz/presentation/pages/quiz_page.dart';
import 'package:idiomatic_app/features/review/presentation/pages/review_page.dart';

String _greeting() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Good morning';
  if (hour < 18) return 'Good afternoon';
  return 'Good evening';
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProgressCubit>()..load(),
      child: const _HomeTabView(),
    );
  }
}

class _HomeTabView extends StatelessWidget {
  const _HomeTabView();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    final darkMode = context.watch<ThemeCubit>().state;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user?.displayName ?? '',
                      style: AppTheme.serifItalic(context, size: 27),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _DarkModeToggle(
                      darkMode: darkMode,
                      onTap: () => context.read<ThemeCubit>().toggle(),
                    ),
                    const SizedBox(width: 8),
                    _IconButton(
                      icon: Icons.logout,
                      onTap: () => context.read<AuthBloc>().add(
                        const AuthLogoutRequested(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          BlocBuilder<ProgressCubit, ProgressCubitState>(
            builder: (context, state) {
              final stats = state.stats;
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        value: '${stats?.dueToday ?? 0}',
                        label: 'Due today',
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        value: '${stats?.streakDays ?? 0}',
                        label: 'Day streak',
                        color: colors.warn,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatCard(
                        value: '${stats?.mastered ?? 0}',
                        label: 'Mastered',
                        color: colors.success,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
            child: Column(
              children: [
                Material(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => const ReviewPage()))
                        .then((_) {
                          if (context.mounted) context.read<ProgressCubit>().load();
                        }),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: BlocBuilder<ProgressCubit, ProgressCubitState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Start Review',
                                    style: TextStyle(
                                      color: colors.onPrimary,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${state.stats?.dueToday ?? 0} idioms due',
                                    style: TextStyle(
                                      color: colors.onPrimarySoft,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: colors.onPrimary,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => const QuizPage())),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.border, width: 1.5),
                      padding: const EdgeInsets.all(14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Take a Quiz',
                      style: TextStyle(
                        color: colors.text,
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
            child: Text(
              'Quick practice',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: colors.text,
              ),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: TopicDef.all.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final topic = TopicDef.all[i];
                return Material(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(100),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => ReviewPage(topic: topic.id)))
                        .then((_) {
                          if (context.mounted) context.read<ProgressCubit>().load();
                        }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: colors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(topic.icon, size: 14, color: colors.text),
                          const SizedBox(width: 6),
                          Text(
                            topic.label,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: colors.text,
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
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Icon(icon, size: 18, color: colors.text),
          ),
        ),
      ),
    );
  }
}

class _DarkModeToggle extends StatelessWidget {
  const _DarkModeToggle({required this.darkMode, required this.onTap});

  final bool darkMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Icon(
              darkMode ? Icons.dark_mode : Icons.light_mode_outlined,
              size: 18,
              color: colors.text,
            ),
          ),
        ),
      ),
    );
  }
}
