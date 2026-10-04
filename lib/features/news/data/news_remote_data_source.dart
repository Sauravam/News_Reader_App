import 'package:dio/dio.dart';

import 'article_model.dart';

abstract class NewsRemoteDataSource {
  Future<Map<String, dynamic>> getArticles({
    required int limit,
    required int offset,
    String? search,
    CancelToken? cancelToken,
  });

  Future<ArticleModel> getArticleById(int id, {CancelToken? cancelToken});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;

  NewsRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> getArticles({
    required int limit,
    required int offset,
    String? search,
    CancelToken? cancelToken,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'ordering': '-published_at',
    };

    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    final response = await dio.get<Map<String, dynamic>>(
      '/articles/',
      queryParameters: queryParams,
      cancelToken: cancelToken,
    );

    final data = response.data;
    if (data == null || !data.containsKey('results') || data['results'] is! List) {
      throw const FormatException('Invalid response envelope shape');
    }

    return data;
  }

  @override
  Future<ArticleModel> getArticleById(int id, {CancelToken? cancelToken}) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/articles/$id/',
      cancelToken: cancelToken,
    );

    final data = response.data;
    if (data == null) {
      throw const FormatException('Invalid article response format');
    }

    final model = ArticleModel.safeFromJson(data);
    if (model == null) {
      throw const FormatException('Missing required fields in article JSON');
    }

    return model;
  }
}
