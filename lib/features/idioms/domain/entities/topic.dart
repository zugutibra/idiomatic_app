import 'package:flutter/material.dart';

/// Static topic metadata (id, label, icon) matching the backend's `Topic`
/// enum. Counts/mastered numbers come from the API, not from here.
class TopicDef {
  const TopicDef({required this.id, required this.label, required this.icon});

  final String id;
  final String label;
  final IconData icon;

  static const List<TopicDef> all = [
    TopicDef(id: 'education', label: 'Education', icon: Icons.school_outlined),
    TopicDef(id: 'environment', label: 'Environment', icon: Icons.eco_outlined),
    TopicDef(id: 'technology', label: 'Technology', icon: Icons.memory_outlined),
    TopicDef(id: 'relationships', label: 'Relationships', icon: Icons.favorite_outline),
    TopicDef(id: 'work', label: 'Work', icon: Icons.work_outline),
    TopicDef(id: 'travel', label: 'Travel', icon: Icons.flight_outlined),
    TopicDef(id: 'health', label: 'Health', icon: Icons.monitor_heart_outlined),
    TopicDef(id: 'culture', label: 'Culture', icon: Icons.public_outlined),
  ];

  static TopicDef byId(String id) => all.firstWhere((t) => t.id == id, orElse: () => all.first);
}

class TopicStat {
  const TopicStat({required this.topic, required this.total, required this.mastered, required this.pct});

  final String topic;
  final int total;
  final int mastered;
  final int pct;
}
