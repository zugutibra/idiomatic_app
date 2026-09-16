import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/core/di/injection_container.dart';
import 'package:idiomatic_app/core/theme/app_theme.dart';
import 'package:idiomatic_app/core/widgets/app_button.dart';
import 'package:idiomatic_app/features/review/presentation/bloc/review_bloc.dart';
import 'package:idiomatic_app/features/review/presentation/bloc/review_event.dart';
import 'package:idiomatic_app/features/review/presentation/bloc/review_state.dart';
import 'package:idiomatic_app/features/review/presentation/widgets/flash_card.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key, this.topic});

  final String? topic;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReviewBloc>()..add(ReviewStarted(topic: topic)),
      child: const _ReviewView(),
    );
  }
}

class _ReviewView extends StatelessWidget {
  const _ReviewView();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            if (state.status == ReviewStatus.loading || state.status == ReviewStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == ReviewStatus.error) {
              return Center(child: Text(state.errorMessage ?? 'Something went wrong'));
            }
            if (state.status == ReviewStatus.finished) {
              return _FinishedView(reviewed: state.total, nextDueAt: state.nextDueAt);
            }

            final idiom = state.currentIdiom!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CloseButton(onTap: () => Navigator.of(context).pop()),
                      Text(
                        '${state.position} / ${state.total}',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: colors.textSecondary),
                      ),
                      const SizedBox(width: 34),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: state.progressPct,
                      minHeight: 4,
                      backgroundColor: colors.surfaceAlt,
                      valueColor: AlwaysStoppedAnimation(colors.primary),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: FlashCard(
                        idiom: idiom,
                        flipped: state.flipped,
                        dragX: state.dragX,
                        translationLang: state.translationLang,
                        onTap: () => context.read<ReviewBloc>().add(const ReviewCardFlipped()),
                        onDragStart: () {},
                        onDragUpdate: (dx) => context.read<ReviewBloc>().add(ReviewDragUpdated(dx)),
                        onDragEnd: () => context.read<ReviewBloc>().add(const ReviewDragEnded()),
                        onLangChanged: (lang) =>
                            context.read<ReviewBloc>().add(ReviewTranslationLangChanged(lang)),
                      ),
                    ),
                  ),
                ),
                if (!state.flipped)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
                    child: Text(
                      'Tap the card to reveal the meaning',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textTertiary),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ChoiceButton(
                            label: 'Still Learning',
                            background: colors.warnSoft,
                            foreground: colors.warn,
                            onTap: () => context.read<ReviewBloc>().add(const ReviewMarked(correct: false)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ChoiceButton(
                            label: 'Got It',
                            background: colors.success,
                            foreground: Colors.white,
                            onTap: () => context.read<ReviewBloc>().add(const ReviewMarked(correct: true)),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FinishedView extends StatelessWidget {
  const _FinishedView({required this.reviewed, this.nextDueAt});

  final int reviewed;
  final DateTime? nextDueAt;

  String? _nextDueLabel() {
    final due = nextDueAt;
    if (due == null) return null;
    final remaining = due.difference(DateTime.now());
    if (remaining.isNegative) return null;
    if (remaining.inDays >= 1) {
      final days = remaining.inDays;
      return 'Next review available in $days ${days == 1 ? 'day' : 'days'}.';
    }
    if (remaining.inHours >= 1) {
      final hours = remaining.inHours;
      return 'Next review available in $hours ${hours == 1 ? 'hour' : 'hours'}.';
    }
    return 'Next review available shortly.';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final nextDueLabel = _nextDueLabel();
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: colors.success),
          const SizedBox(height: 16),
          Text('All caught up!', style: AppTheme.serifItalic(context, size: 26)),
          const SizedBox(height: 8),
          Text(
            reviewed == 0 ? 'No idioms are due right now.' : 'You reviewed $reviewed idioms.',
            style: TextStyle(fontSize: 13.5, color: colors.textSecondary),
          ),
          if (nextDueLabel != null) ...[
            const SizedBox(height: 4),
            Text(
              nextDueLabel,
              style: TextStyle(fontSize: 12.5, color: colors.textTertiary),
            ),
          ],
          const SizedBox(height: 20),
          AppPrimaryButton(label: 'Back to Home', onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({required this.label, required this.background, required this.foreground, required this.onTap});

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return SizedBox(
      width: 34,
      height: 34,
      child: Material(
        color: colors.surfaceAlt,
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(11),
          child: Icon(Icons.close, size: 16, color: colors.textSecondary),
        ),
      ),
    );
  }
}
