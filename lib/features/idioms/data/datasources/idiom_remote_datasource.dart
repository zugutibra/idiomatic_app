import 'package:dio/dio.dart';

import 'package:idiomatic_app/core/errors/exceptions.dart';
import 'package:idiomatic_app/features/idioms/data/models/idiom_model.dart';
import 'package:idiomatic_app/features/idioms/data/models/quiz_question_model.dart';
import 'package:idiomatic_app/features/idioms/data/models/review_result_model.dart';

abstract class IdiomRemoteDataSource {
  Future<List<IdiomModel>> listIdioms({String? topic});

  Future<List<IdiomModel>> getDueIdioms({String? topic});

  Future<DateTime?> getNextDueAt({String? topic});

  Future<ReviewResultModel> submitReview({required int idiomId, required bool correct});

  Future<QuizQuestionModel> getQuizOptions(int idiomId);
}

class IdiomRemoteDataSourceImpl implements IdiomRemoteDataSource {
  IdiomRemoteDataSourceImpl(this.dio);

  final Dio dio;

  @override
  Future<List<IdiomModel>> listIdioms({String? topic}) async {
    try {
      final response = await dio.get('/idioms', queryParameters: topic != null ? {'topic': topic} : null);
      return (response.data as List<dynamic>)
          .map((e) => IdiomModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(_messageFrom(e));
    }
  }

  @override
  Future<List<IdiomModel>> getDueIdioms({String? topic}) async {
    try {
      final response = await dio.get('/idioms/due', queryParameters: topic != null ? {'topic': topic} : null);
      return (response.data as List<dynamic>)
          .map((e) => IdiomModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(_messageFrom(e));
    }
  }

  @override
  Future<DateTime?> getNextDueAt({String? topic}) async {
    try {
      final response = await dio.get('/idioms/next-due', queryParameters: topic != null ? {'topic': topic} : null);
      final iso = (response.data as Map<String, dynamic>)['next_review_at'] as String?;
      return iso == null ? null : DateTime.parse(iso);
    } on DioException catch (e) {
      throw ServerException(_messageFrom(e));
    }
  }

  @override
  Future<ReviewResultModel> submitReview({required int idiomId, required bool correct}) async {
    try {
      final response = await dio.post('/idioms/$idiomId/review', data: {'correct': correct});
      return ReviewResultModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(_messageFrom(e));
    }
  }

  @override
  Future<QuizQuestionModel> getQuizOptions(int idiomId) async {
    try {
      final response = await dio.get('/idioms/$idiomId/quiz-options');
      return QuizQuestionModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(_messageFrom(e));
    }
  }

  String _messageFrom(DioException e) {
    final detail = e.response?.data is Map ? e.response?.data['detail'] : null;
    return (detail as String?) ?? e.message ?? 'Something went wrong';
  }
}
