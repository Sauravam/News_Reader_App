import 'package:dio/dio.dart';

import '../../../core/utils/result.dart';
import 'article.dart';
import 'news_page.dart';

abstract class NewsRepository {
  Future<Result<NewsPage>> getArticles({
    required int limit,
    required int offset,
    String? search,
    CancelToken? cancelToken,
  });

  Future<Result<Article>> getArticleById(
    int id, {
    CancelToken? cancelToken,
  });
}
