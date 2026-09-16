import 'package:equatable/equatable.dart';

import 'package:idiomatic_app/features/idioms/domain/entities/idiom.dart';

enum ReviewStatus { initial, loading, active, finished, error }

class ReviewState extends Equatable {
  const ReviewState({
    this.status = ReviewStatus.initial,
    this.queue = const [],
    this.index = 0,
    this.flipped = false,
    this.dragX = 0,
    this.translationLang = 'ru',
    this.errorMessage,
    this.nextDueAt,
  });

  final ReviewStatus status;
  final List<Idiom> queue;
  final int index;
  final bool flipped;
  final double dragX;
  final String translationLang;
  final String? errorMessage;
  final DateTime? nextDueAt;

  Idiom? get currentIdiom => index < queue.length ? queue[index] : null;
  int get total => queue.length;
  int get position => index + 1;
  double get progressPct => total == 0 ? 0 : index / total;

  ReviewState copyWith({
    ReviewStatus? status,
    List<Idiom>? queue,
    int? index,
    bool? flipped,
    double? dragX,
    String? translationLang,
    String? errorMessage,
    DateTime? nextDueAt,
  }) {
    return ReviewState(
      status: status ?? this.status,
      queue: queue ?? this.queue,
      index: index ?? this.index,
      flipped: flipped ?? this.flipped,
      dragX: dragX ?? this.dragX,
      translationLang: translationLang ?? this.translationLang,
      errorMessage: errorMessage,
      nextDueAt: nextDueAt,
    );
  }

  @override
  List<Object?> get props => [status, queue, index, flipped, dragX, translationLang, errorMessage, nextDueAt];
}
