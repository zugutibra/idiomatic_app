import 'package:equatable/equatable.dart';

class ReviewResult extends Equatable {
  const ReviewResult({
    required this.idiomId,
    required this.boxLevel,
    required this.timesCorrect,
    required this.timesSeen,
  });

  final int idiomId;
  final int boxLevel;
  final int timesCorrect;
  final int timesSeen;

  @override
  List<Object?> get props => [idiomId, boxLevel, timesCorrect, timesSeen];
}
