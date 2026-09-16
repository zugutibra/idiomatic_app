import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/core/di/injection_container.dart';
import 'package:idiomatic_app/core/theme/app_theme.dart';
import 'package:idiomatic_app/core/widgets/app_button.dart';
import 'package:idiomatic_app/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:idiomatic_app/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:idiomatic_app/features/quiz/presentation/bloc/quiz_state.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key, this.topic});

  final String? topic;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<QuizBloc>()..add(QuizStarted(topic: topic)),
      child: const _QuizView(),
    );
  }
}

class _QuizView extends StatelessWidget {
  const _QuizView();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            if (state.status == QuizStatus.loading ||
                state.status == QuizStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == QuizStatus.error) {
              return Center(
                child: Text(state.errorMessage ?? 'Something went wrong'),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CloseButton(onTap: () => Navigator.of(context).pop()),
                      if (state.status != QuizStatus.summary)
                        Text(
                          'Question ${state.index + 1}/${state.total}',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: colors.textSecondary,
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primarySoft,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          '${state.score}/${state.total}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: colors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: state.status == QuizStatus.summary
                      ? _SummaryView(score: state.score, total: state.total)
                      : _QuestionView(state: state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({required this.state});

  final QuizState state;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final question = state.currentQuestion!;
    final answered = state.selectedIndex != null;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(26, 10, 26, 18),
          child: Column(
            children: [
              Text(
                'WHAT DOES THIS IDIOM MEAN?',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: colors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                question.phrase,
                textAlign: TextAlign.center,
                style: AppTheme.serifItalic(context, size: 27),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            itemCount: question.options.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final option = question.options[i];
              final isSelected = state.selectedIndex == i;

              Color bg = colors.surface;
              Color border = colors.border;
              Color fg = colors.text;
              Widget? trailing;

              if (answered) {
                if (option.isCorrect) {
                  bg = colors.successSoft;
                  border = colors.success;
                  trailing = Icon(Icons.check, size: 18, color: colors.success);
                } else if (isSelected) {
                  bg = colors.dangerSoft;
                  border = colors.danger;
                  trailing = Icon(Icons.close, size: 16, color: colors.danger);
                } else {
                  bg = colors.surfaceAlt;
                  border = colors.border;
                  fg = colors.textTertiary;
                }
              }

              return Material(
                color: bg,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  onTap: answered
                      ? null
                      : () =>
                            context.read<QuizBloc>().add(QuizAnswerSelected(i)),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.text,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: fg,
                              height: 1.4,
                            ),
                          ),
                        ),
                        ?trailing,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (answered)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
            child: AppPrimaryButton(
              label: state.isLastQuestion ? 'See Results' : 'Next Question',
              onPressed: () => context.read<QuizBloc>().add(
                const QuizNextQuestionRequested(),
              ),
            ),
          ),
      ],
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView({required this.score, required this.total});

  final int score;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final ratio = total == 0 ? 0.0 : score / total;
    final title = ratio >= 0.8
        ? 'Excellent work!'
        : ratio >= 0.5
        ? 'Nice progress!'
        : 'Keep practicing!';

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: colors.successSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 34, color: colors.success),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTheme.serifItalic(context, size: 26)),
          const SizedBox(height: 8),
          Text(
            'You scored $score out of $total',
            style: TextStyle(fontSize: 13.5, color: colors.textSecondary),
          ),
          const SizedBox(height: 20),
          AppOutlineButton(
            label: 'Try Again',
            onPressed: () =>
                context.read<QuizBloc>().add(const QuizRetryRequested()),
          ),
          const SizedBox(height: 10),
          AppPrimaryButton(
            label: 'Back to Home',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
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
