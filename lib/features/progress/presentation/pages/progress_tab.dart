import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/core/di/injection_container.dart';
import 'package:idiomatic_app/core/theme/app_theme.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/topic.dart';
import 'package:idiomatic_app/features/progress/presentation/bloc/progress_cubit.dart';
import 'package:idiomatic_app/features/progress/presentation/bloc/progress_state.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProgressCubit>()..load(),
      child: const _ProgressTabView(),
    );
  }
}

class _ProgressTabView extends StatelessWidget {
  const _ProgressTabView();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return BlocBuilder<ProgressCubit, ProgressCubitState>(
      builder: (context, state) {
        if (state.status == ProgressStatus.loading || state.status == ProgressStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ProgressStatus.error || state.stats == null) {
          return Center(child: Text(state.errorMessage ?? 'Something went wrong'));
        }

        final stats = state.stats!;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Progress', style: AppTheme.serifItalic(context, size: 26)),
              const SizedBox(height: 5),
              Text("Keep going — you're building real fluency.", style: TextStyle(fontSize: 13, color: colors.textSecondary)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: colors.surface, border: Border.all(color: colors.border), borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    _DonutChart(
                      mastered: stats.mastered,
                      learning: stats.stillLearning.clamp(0, stats.totalIdioms),
                      notStarted: stats.notStarted.clamp(0, stats.totalIdioms),
                      total: stats.totalIdioms,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Legend(color: colors.success, label: 'Mastered · ${stats.mastered}'),
                          const SizedBox(height: 9),
                          _Legend(color: colors.warn, label: 'Still learning · ${stats.stillLearning}'),
                          const SizedBox(height: 9),
                          _Legend(color: colors.textTertiary, label: 'New · ${stats.notStarted}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department, size: 18, color: colors.warn),
                    const SizedBox(width: 6),
                    Text(
                      '${stats.streakDays}-day streak · keep it up',
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.text),
                    ),
                  ],
                ),
              ),
              Text('Progress by topic', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: colors.text)),
              const SizedBox(height: 12),
              ...stats.topics.map((t) {
                final label = TopicDef.byId(t.topic).label;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.text)),
                          Text('${t.pct}%', style: TextStyle(fontSize: 12.5, color: colors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: t.pct / 100,
                          minHeight: 8,
                          backgroundColor: colors.surfaceAlt,
                          valueColor: AlwaysStoppedAnimation(colors.primary),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return Row(
      children: [
        Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.text)),
      ],
    );
  }
}

class _DonutChart extends StatelessWidget {
  const _DonutChart({required this.mastered, required this.learning, required this.notStarted, required this.total});

  final int mastered;
  final int learning;
  final int notStarted;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return SizedBox(
      width: 118,
      height: 118,
      child: CustomPaint(
        painter: _DonutPainter(
          mastered: mastered,
          learning: learning,
          notStarted: notStarted,
          total: total == 0 ? 1 : total,
          trackColor: colors.surfaceAlt,
          masteredColor: colors.success,
          learningColor: colors.warn,
          newColor: colors.textTertiary,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$total', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: colors.text)),
              Text('idioms', style: TextStyle(fontSize: 10, color: colors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.mastered,
    required this.learning,
    required this.notStarted,
    required this.total,
    required this.trackColor,
    required this.masteredColor,
    required this.learningColor,
    required this.newColor,
  });

  final int mastered;
  final int learning;
  final int notStarted;
  final int total;
  final Color trackColor;
  final Color masteredColor;
  final Color learningColor;
  final Color newColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 14.0;
    final rect = Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth);

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(rect, 0, 6.28319, false, track);

    double start = -1.5708;
    for (final segment in [
      (value: mastered, color: masteredColor),
      (value: learning, color: learningColor),
      (value: notStarted, color: newColor),
    ]) {
      if (segment.value <= 0) continue;
      final sweep = (segment.value / total) * 6.28319;
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.mastered != mastered || oldDelegate.learning != learning || oldDelegate.notStarted != notStarted;
  }
}
