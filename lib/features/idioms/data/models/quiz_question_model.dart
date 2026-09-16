import 'package:idiomatic_app/features/quiz/domain/entities/quiz_question.dart';

class QuizQuestionModel extends QuizQuestion {
  const QuizQuestionModel({required super.idiomId, required super.phrase, required super.options});

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      idiomId: json['idiom_id'] as int,
      phrase: json['phrase'] as String,
      options: (json['options'] as List<dynamic>)
          .map((o) => QuizOption(text: o['text'] as String, isCorrect: o['is_correct'] as bool))
          .toList(),
    );
  }
}
