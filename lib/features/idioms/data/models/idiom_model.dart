import 'package:idiomatic_app/features/idioms/domain/entities/idiom.dart';

class IdiomModel extends Idiom {
  const IdiomModel({
    required super.id,
    required super.phrase,
    required super.meaning,
    required super.exampleSentence,
    required super.topic,
    required super.difficulty,
    super.translationRu,
    super.translationKk,
    super.boxLevel,
    super.isNew,
  });

  factory IdiomModel.fromJson(Map<String, dynamic> json) {
    return IdiomModel(
      id: json['id'] as int,
      phrase: json['phrase'] as String,
      meaning: json['meaning'] as String,
      exampleSentence: json['example_sentence'] as String,
      topic: json['topic'] as String,
      difficulty: json['difficulty'] as String,
      translationRu: json['translation_ru'] as String?,
      translationKk: json['translation_kk'] as String?,
      boxLevel: json['box_level'] as int?,
      isNew: json['is_new'] as bool?,
    );
  }
}
