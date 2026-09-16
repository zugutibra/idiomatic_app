import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/core/usecases/usecase.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/review_result.dart';
import 'package:idiomatic_app/features/idioms/domain/repositories/idiom_repository.dart';

class SubmitReview implements UseCase<ReviewResult, SubmitReviewParams> {
  SubmitReview(this.repository);

  final IdiomRepository repository;

  @override
  Future<Either<Failure, ReviewResult>> call(SubmitReviewParams params) {
    return repository.submitReview(idiomId: params.idiomId, correct: params.correct);
  }
}

class SubmitReviewParams extends Equatable {
  const SubmitReviewParams({required this.idiomId, required this.correct});

  final int idiomId;
  final bool correct;

  @override
  List<Object?> get props => [idiomId, correct];
}
