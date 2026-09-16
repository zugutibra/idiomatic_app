import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:idiomatic_app/features/idioms/domain/usecases/get_due_idioms.dart';
import 'package:idiomatic_app/features/idioms/domain/usecases/get_next_due_at.dart';
import 'package:idiomatic_app/features/idioms/domain/usecases/submit_review.dart';
import 'package:idiomatic_app/features/review/presentation/bloc/review_event.dart';
import 'package:idiomatic_app/features/review/presentation/bloc/review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  ReviewBloc({
    required this._getDueIdioms,
    required this._getNextDueAt,
    required this._submitReview,
  }) : super(const ReviewState()) {
    on<ReviewStarted>(_onStarted);
    on<ReviewCardFlipped>(_onFlipped);
    on<ReviewDragUpdated>(_onDragUpdated);
    on<ReviewDragEnded>(_onDragEnded);
    on<ReviewMarked>(_onMarked);
    on<ReviewTranslationLangChanged>(_onLangChanged);
  }

  final GetDueIdioms _getDueIdioms;
  final GetNextDueAt _getNextDueAt;
  final SubmitReview _submitReview;

  String? _topic;

  static const _swipeThreshold = 90.0;

  Future<void> _onStarted(
    ReviewStarted event,
    Emitter<ReviewState> emit,
  ) async {
    _topic = event.topic;
    emit(state.copyWith(status: ReviewStatus.loading));
    final result = await _getDueIdioms(GetDueIdiomsParams(topic: event.topic));
    await result.match(
      (failure) async => emit(
        state.copyWith(
          status: ReviewStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (idioms) async {
        if (idioms.isEmpty) {
          emit(
            ReviewState(
              status: ReviewStatus.finished,
              nextDueAt: await _fetchNextDueAt(),
            ),
          );
        } else {
          emit(ReviewState(status: ReviewStatus.active, queue: idioms));
        }
      },
    );
  }

  Future<DateTime?> _fetchNextDueAt() async {
    final result = await _getNextDueAt(GetNextDueAtParams(topic: _topic));
    return result.match((_) => null, (nextDueAt) => nextDueAt);
  }

  void _onFlipped(ReviewCardFlipped event, Emitter<ReviewState> emit) {
    emit(state.copyWith(flipped: !state.flipped));
  }

  void _onDragUpdated(ReviewDragUpdated event, Emitter<ReviewState> emit) {
    emit(state.copyWith(dragX: event.dx));
  }

  Future<void> _onDragEnded(
    ReviewDragEnded event,
    Emitter<ReviewState> emit,
  ) async {
    if (!state.flipped) {
      emit(state.copyWith(dragX: 0));
      return;
    }
    if (state.dragX > _swipeThreshold) {
      await _mark(correct: true, emit: emit);
    } else if (state.dragX < -_swipeThreshold) {
      await _mark(correct: false, emit: emit);
    } else {
      emit(state.copyWith(dragX: 0));
    }
  }

  Future<void> _onMarked(ReviewMarked event, Emitter<ReviewState> emit) =>
      _mark(correct: event.correct, emit: emit);

  Future<void> _mark({
    required bool correct,
    required Emitter<ReviewState> emit,
  }) async {
    final idiom = state.currentIdiom;
    if (idiom == null) return;
    unawaited(
      _submitReview(SubmitReviewParams(idiomId: idiom.id, correct: correct)),
    );

    final nextIndex = state.index + 1;
    if (nextIndex >= state.queue.length) {
      final nextDueAt = await _fetchNextDueAt();
      emit(
        state.copyWith(
          status: ReviewStatus.finished,
          index: nextIndex,
          dragX: 0,
          flipped: false,
          nextDueAt: nextDueAt,
        ),
      );
    } else {
      emit(state.copyWith(index: nextIndex, dragX: 0, flipped: false));
    }
  }

  void _onLangChanged(
    ReviewTranslationLangChanged event,
    Emitter<ReviewState> emit,
  ) {
    emit(state.copyWith(translationLang: event.languageCode));
  }
}
