import 'package:equatable/equatable.dart';

import 'package:idiomatic_app/features/idioms/domain/entities/topic.dart';

class ProgressStats extends Equatable {
  const ProgressStats({
    required this.totalSeen,
    required this.totalIdioms,
    required this.mastered,
    required this.dueToday,
    required this.streakDays,
    required this.topics,
  });

  final int totalSeen;
  final int totalIdioms;
  final int mastered;
  final int dueToday;
  final int streakDays;
  final List<TopicStat> topics;

  int get stillLearning => totalSeen - mastered;
  int get notStarted => totalIdioms - totalSeen;

  @override
  List<Object?> get props => [totalSeen, totalIdioms, mastered, dueToday, streakDays, topics];
}
