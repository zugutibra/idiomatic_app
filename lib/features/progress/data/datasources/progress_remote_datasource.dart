import 'package:dio/dio.dart';

import 'package:idiomatic_app/core/errors/exceptions.dart';
import 'package:idiomatic_app/features/progress/data/models/progress_stats_model.dart';

abstract class ProgressRemoteDataSource {
  Future<ProgressStatsModel> getStats();
}

class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  ProgressRemoteDataSourceImpl(this.dio);

  final Dio dio;

  @override
  Future<ProgressStatsModel> getStats() async {
    try {
      final response = await dio.get('/progress/stats');
      return ProgressStatsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final detail = e.response?.data is Map ? e.response?.data['detail'] : null;
      throw ServerException((detail as String?) ?? e.message ?? 'Something went wrong');
    }
  }
}
