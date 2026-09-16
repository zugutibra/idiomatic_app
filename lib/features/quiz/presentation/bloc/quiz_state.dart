import 'package:equatable/equatable.dart';

import 'package:idiomatic_app/features/quiz/domain/entities/quiz_question.dart';

enum QuizStatus { initial, loading, active, summary, error }

class QuizState extends Equatable {
  const QuizState({
    this.status = QuizStatus.initial,
    this.questions = const [],
    this.index = 0,
    this.selectedIndex,
    this.score = 0,
    this.errorMessage,
  });

  final QuizStatus status;
  final List<QuizQuestion> questions;
  final int index;
  final int? selectedIndex;
  final int score;
  final String? errorMessage;

  QuizQuestion? get currentQuestion => index < questions.length ? questions[index] : null;
  int get total => questions.length;
  bool get isLastQuestion => index + 1 >= total;

  QuizState copyWith({
    QuizStatus? status,
    List<QuizQuestion>? questions,
    int? index,
    int? selectedIndex,
    bool clearSelected = false,
    int? score,
    String? errorMessage,
  }) {
    return QuizState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      index: index ?? this.index,
      selectedIndex: clearSelected ? null : (selectedIndex ?? this.selectedIndex),
      score: score ?? this.score,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, questions, index, selectedIndex, score, errorMessage];
}
