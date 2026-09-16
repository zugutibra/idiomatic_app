import 'package:equatable/equatable.dart';

class QuizOption extends Equatable {
  const QuizOption({required this.text, required this.isCorrect});

  final String text;
  final bool isCorrect;

  @override
  List<Object?> get props => [text, isCorrect];
}

class QuizQuestion extends Equatable {
  const QuizQuestion({required this.idiomId, required this.phrase, required this.options});

  final int idiomId;
  final String phrase;
  final List<QuizOption> options;

  @override
  List<Object?> get props => [idiomId, phrase, options];
}
