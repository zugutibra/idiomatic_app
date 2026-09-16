import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class ReviewStarted extends ReviewEvent {
  const ReviewStarted({this.topic});

  final String? topic;

  @override
  List<Object?> get props => [topic];
}

class ReviewCardFlipped extends ReviewEvent {
  const ReviewCardFlipped();
}

class ReviewDragUpdated extends ReviewEvent {
  const ReviewDragUpdated(this.dx);

  final double dx;

  @override
  List<Object?> get props => [dx];
}

class ReviewDragEnded extends ReviewEvent {
  const ReviewDragEnded();
}

class ReviewMarked extends ReviewEvent {
  const ReviewMarked({required this.correct});

  final bool correct;

  @override
  List<Object?> get props => [correct];
}

class ReviewTranslationLangChanged extends ReviewEvent {
  const ReviewTranslationLangChanged(this.languageCode);

  final String languageCode;

  @override
  List<Object?> get props => [languageCode];
}
