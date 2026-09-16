import 'package:idiomatic_app/features/idioms/domain/entities/topic.dart';
import 'package:idiomatic_app/features/progress/domain/entities/progress_stats.dart';

class ProgressStatsModel extends ProgressStats {
  const ProgressStatsModel({
    required super.totalSeen,
    required super.totalIdioms,
    required super.mastered,
    required super.dueToday,
    required super.streakDays,
    required super.topics,
  });

  factory ProgressStatsModel.fromJson(Map<String, dynamic> json) {
    return ProgressStatsModel(
      totalSeen: json['total_seen'] as int,
      totalIdioms: json['total_idioms'] as int,
      mastered: json['mastered'] as int,
      dueToday: json['due_today'] as int,
      streakDays: json['streak_days'] as int,
      topics: (json['topics'] as List<dynamic>)
          .map((t) => TopicStat(
                topic: t['topic'] as String,
                total: t['total'] as int,
                mastered: t['mastered'] as int,
                pct: t['pct'] as int,
              ))
          .toList(),
    );
  }
}
