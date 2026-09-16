import 'package:equatable/equatable.dart';

class Idiom extends Equatable {
  const Idiom({
    required this.id,
    required this.phrase,
    required this.meaning,
    required this.exampleSentence,
    required this.topic,
    required this.difficulty,
    this.translationRu,
    this.translationKk,
    this.boxLevel,
    this.isNew,
  });

  final int id;
  final String phrase;
  final String meaning;
  final String exampleSentence;
  final String topic;
  final String difficulty;
  final String? translationRu;
  final String? translationKk;

  /// Populated only when this idiom came from `/idioms/due`.
  final int? boxLevel;
  final bool? isNew;

  String translation(String languageCode) =>
      languageCode == 'kz' ? (translationKk ?? '') : (translationRu ?? '');

  @override
  List<Object?> get props => [id, phrase, meaning, exampleSentence, topic, difficulty, boxLevel, isNew];
}
