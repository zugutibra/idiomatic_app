import 'package:idiomatic_app/features/idioms/domain/entities/review_result.dart';

class ReviewResultModel extends ReviewResult {
  const ReviewResultModel({
    required super.idiomId,
    required super.boxLevel,
    required super.timesCorrect,
    required super.timesSeen,
  });

  factory ReviewResultModel.fromJson(Map<String, dynamic> json) {
    return ReviewResultModel(
      idiomId: json['idiom_id'] as int,
      boxLevel: json['box_level'] as int,
      timesCorrect: json['times_correct'] as int,
      timesSeen: json['times_seen'] as int,
    );
  }
}
