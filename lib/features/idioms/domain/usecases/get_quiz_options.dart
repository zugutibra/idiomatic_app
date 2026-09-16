import 'package:fpdart/fpdart.dart';

import 'package:idiomatic_app/core/errors/failures.dart';
import 'package:idiomatic_app/core/usecases/usecase.dart';
import 'package:idiomatic_app/features/idioms/domain/repositories/idiom_repository.dart';
import 'package:idiomatic_app/features/quiz/domain/entities/quiz_question.dart';

class GetQuizOptions implements UseCase<QuizQuestion, int> {
  GetQuizOptions(this.repository);

  final IdiomRepository repository;

  @override
  Future<Either<Failure, QuizQuestion>> call(int idiomId) {
    return repository.getQuizOptions(idiomId);
  }
}
