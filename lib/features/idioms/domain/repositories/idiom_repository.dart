import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/idiom.dart';
import 'package:idiomatic_app/features/idioms/domain/entities/review_result.dart';
import 'package:idiomatic_app/features/quiz/domain/entities/quiz_question.dart';

abstract class IdiomRepository {
  Future<Either<Failure, List<Idiom>>> listIdioms({String? topic});

  Future<Either<Failure, List<Idiom>>> getDueIdioms({String? topic});

  Future<Either<Failure, DateTime?>> getNextDueAt({String? topic});

  Future<Either<Failure, ReviewResult>> submitReview({required int idiomId, required bool correct});

  Future<Either<Failure, QuizQuestion>> getQuizOptions(int idiomId);
}
