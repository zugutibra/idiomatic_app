import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/features/idioms/domain/usecases/get_idioms.dart';
import 'package:idiomatic_app/features/idioms/domain/usecases/get_quiz_options.dart';
import 'package:idiomatic_app/features/quiz/presentation/bloc/quiz_event.dart';
import 'package:idiomatic_app/features/quiz/presentation/bloc/quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({required this._getIdioms, required GetQuizOptions getQuizOptions})
    : _getQuizOptions = getQuizOptions,
      super(const QuizState()) {
    on<QuizStarted>(_onStarted);
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizNextQuestionRequested>(_onNextQuestion);
    on<QuizRetryRequested>(_onRetry);
  }

  final GetIdioms _getIdioms;
  final GetQuizOptions _getQuizOptions;

  static const _maxQuestions = 10;

  Future<void> _onStarted(QuizStarted event, Emitter<QuizState> emit) async {
    emit(state.copyWith(status: QuizStatus.loading));
    final idiomsResult = await _getIdioms(GetIdiomsParams(topic: event.topic));

    await idiomsResult.match(
      (failure) async => emit(
        state.copyWith(status: QuizStatus.error, errorMessage: failure.message),
      ),
      (idioms) async {
        if (idioms.isEmpty) {
          emit(
            state.copyWith(
              status: QuizStatus.error,
              errorMessage: 'No idioms available yet.',
            ),
          );
          return;
        }
        final pool = List.of(idioms)..shuffle(Random());
        final selected = pool.take(_maxQuestions).toList();

        final questionResults = await Future.wait(
          selected.map((i) => _getQuizOptions(i.id)),
        );
        final questions = <dynamic>[];
        for (final result in questionResults) {
          result.match((_) {}, (q) => questions.add(q));
        }

        if (questions.isEmpty) {
          emit(
            state.copyWith(
              status: QuizStatus.error,
              errorMessage: 'Could not build quiz questions.',
            ),
          );
          return;
        }

        emit(QuizState(status: QuizStatus.active, questions: questions.cast()));
      },
    );
  }

  void _onAnswerSelected(QuizAnswerSelected event, Emitter<QuizState> emit) {
    if (state.selectedIndex != null) return;
    final question = state.currentQuestion;
    if (question == null) return;
    final correct = question.options[event.index].isCorrect;
    emit(
      state.copyWith(
        selectedIndex: event.index,
        score: correct ? state.score + 1 : state.score,
      ),
    );
  }

  void _onNextQuestion(
    QuizNextQuestionRequested event,
    Emitter<QuizState> emit,
  ) {
    if (state.isLastQuestion) {
      emit(state.copyWith(status: QuizStatus.summary));
    } else {
      emit(state.copyWith(index: state.index + 1, clearSelected: true));
    }
  }

  void _onRetry(QuizRetryRequested event, Emitter<QuizState> emit) {
    emit(
      state.copyWith(
        status: QuizStatus.active,
        index: 0,
        clearSelected: true,
        score: 0,
      ),
    );
  }
}
