import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class QuizStarted extends QuizEvent {
  const QuizStarted({this.topic});

  final String? topic;

  @override
  List<Object?> get props => [topic];
}

class QuizAnswerSelected extends QuizEvent {
  const QuizAnswerSelected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class QuizNextQuestionRequested extends QuizEvent {
  const QuizNextQuestionRequested();
}

class QuizRetryRequested extends QuizEvent {
  const QuizRetryRequested();
}
