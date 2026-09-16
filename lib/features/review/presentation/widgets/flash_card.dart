import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:idiomatic_app/core/theme/app_theme.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/idiom.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/topic.dart';

/// The swipeable/flippable review card: front shows the phrase, back shows
/// meaning + example + translation. Dragging right stamps "GOT IT", left
/// stamps "LEARNING" — matching the design's gesture affordance.
class FlashCard extends StatefulWidget {
  const FlashCard({
    super.key,
    required this.idiom,
    required this.flipped,
    required this.dragX,
    required this.translationLang,
    required this.onTap,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onLangChanged,
  });

  final Idiom idiom;
  final bool flipped;
  final double dragX;
  final String translationLang;
  final VoidCallback onTap;
  final VoidCallback onDragStart;
  final ValueChanged<double> onDragUpdate;
  final VoidCallback onDragEnd;
  final ValueChanged<String> onLangChanged;

  @override
  State<FlashCard> createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  bool _dragging = false;

  double _stampOpacity(double v) => v > 15 ? (((v - 15) / 70).clamp(0, 1)) : 0;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    final topic = TopicDef.byId(widget.idiom.topic);
    final dragX = widget.dragX;
    final flipped = widget.flipped;
    final idiom = widget.idiom;
    final translationLang = widget.translationLang;

    return GestureDetector(
      onTap: widget.onTap,
      onHorizontalDragStart: !flipped
          ? null
          : (_) {
              setState(() => _dragging = true);
              widget.onDragStart();
            },
      onHorizontalDragUpdate: !flipped ? null : (details) => widget.onDragUpdate(dragX + details.delta.dx),
      onHorizontalDragEnd: !flipped
          ? null
          : (_) {
              setState(() => _dragging = false);
              widget.onDragEnd();
            },
      child: AnimatedContainer(
        duration: _dragging ? Duration.zero : const Duration(milliseconds: 350),
        curve: const Cubic(0.2, 0.8, 0.2, 1),
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()
          ..translateByDouble(dragX, 0.0, 0.0, 1.0)
          ..rotateZ(dragX / 18 * (math.pi / 180)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 290, minHeight: 360),
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: colors.surface,
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 32, offset: const Offset(0, 14)),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Opacity(
                  opacity: _stampOpacity(dragX),
                  child: _Stamp(text: 'GOT IT', color: colors.success, angle: 10),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Opacity(
                  opacity: _stampOpacity(-dragX),
                  child: _Stamp(text: 'LEARNING', color: colors.warn, angle: -10),
                ),
              ),
              if (!flipped)
                Center(
                  heightFactor: 1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _TopicTag(label: topic.label),
                      const SizedBox(height: 22),
                      Text(
                        idiom.phrase,
                        textAlign: TextAlign.center,
                        style: AppTheme.serifItalic(context, size: 32),
                      ),
                    ],
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TopicTag(label: topic.label),
                    const SizedBox(height: 16),
                    Text(
                      idiom.meaning,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: colors.text, height: 1.45),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: colors.surfaceAlt, borderRadius: BorderRadius.circular(14)),
                      child: Text(
                        '"${idiom.exampleSentence}"',
                        style: TextStyle(fontSize: 13, color: colors.textSecondary, fontStyle: FontStyle.italic, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            idiom.translation(translationLang),
                            style: TextStyle(fontSize: 12.5, color: colors.textSecondary),
                          ),
                        ),
                        Row(
                          children: [
                            _LangChip(label: 'RU', selected: translationLang == 'ru', onTap: () => widget.onLangChanged('ru')),
                            const SizedBox(width: 4),
                            _LangChip(label: 'KZ', selected: translationLang == 'kz', onTap: () => widget.onLangChanged('kz')),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicTag extends StatelessWidget {
  const _TopicTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: colors.primarySoft, borderRadius: BorderRadius.circular(100)),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: colors.primary, letterSpacing: 0.5),
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colorsOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            color: selected ? colors.onPrimary : colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _Stamp extends StatelessWidget {
  const _Stamp({required this.text, required this.color, required this.angle});

  final String text;
  final Color color;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Transform.rotate(
        angle: angle * (math.pi / 180),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(border: Border.all(color: color, width: 3), borderRadius: BorderRadius.circular(10)),
          child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 12)),
        ),
      ),
    );
  }
}
