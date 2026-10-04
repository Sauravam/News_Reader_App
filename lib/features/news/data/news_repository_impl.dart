import 'package:dio/dio.dart';

import '../../../core/error/failures.dart';
import '../../../core/network/dio_error_mapper.dart';
import '../../../core/utils/result.dart';
import '../domain/article.dart';
import '../domain/news_page.dart';
import '../domain/news_repository.dart';
import 'article_model.dart';
import 'news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<NewsPage>> getArticles({
    required int limit,
    required int offset,
    String? search,
    CancelToken? cancelToken,
  }) async {
    try {
      final json = await remoteDataSource.getArticles(
        limit: limit,
        offset: offset,
        search: search,
        cancelToken: cancelToken,
      );

      final total = (json['count'] as num?)?.toInt() ?? 0;
      final resultsList = json['results'] as List<dynamic>? ?? [];

      final articles = <Article>[];
      for (final rawItem in resultsList) {
        if (rawItem is Map<String, dynamic>) {
          final model = ArticleModel.safeFromJson(rawItem);
          if (model != null) {
            articles.add(model.toDomain());
          }
        }
      }

      final hasMore = (offset + articles.length) < total && json['next'] != null;

      return Result.success(
        NewsPage(
          items: articles,
          hasMore: hasMore,
          total: total,
        ),
      );
    } catch (e) {
      final failure = DioErrorMapper.mapToFailure(e);
      if (failure == null) {
        // Request was cancelled
        return Result.err(const Failure.unknown('Request cancelled'));
      }
      return Result.err(failure);
    }
  }

  @override
  Future<Result<Article>> getArticleById(
    int id, {
    CancelToken? cancelToken,
  }) async {
    try {
      final model = await remoteDataSource.getArticleById(
        id,
        cancelToken: cancelToken,
      );
      return Result.success(model.toDomain());
    } catch (e) {
      final failure = DioErrorMapper.mapToFailure(e);
      return Result.err(failure ?? const Failure.unknown('Request cancelled'));
    }
  }
}
