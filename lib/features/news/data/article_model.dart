import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/article.dart';

part 'article_model.freezed.dart';
part 'article_model.g.dart';

@freezed
abstract class ArticleModel with _$ArticleModel {
  const ArticleModel._();

  const factory ArticleModel({
    required int id,
    required String title,
    required String url,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'news_site') String? newsSite,
    String? summary,
    @JsonKey(name: 'published_at') String? publishedAt,
  }) = _ArticleModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Article toDomain() {
    return Article(
      id: id,
      title: title,
      url: url,
      imageUrl: imageUrl,
      newsSite: newsSite,
      summary: summary,
      publishedAt: publishedAt,
    );
  }

  /// Parses a json map safety. Returns null and logs if required fields are missing.
  static ArticleModel? safeFromJson(Map<String, dynamic> json) {
    try {
      if (!json.containsKey('id') || !json.containsKey('title') || !json.containsKey('url')) {
        debugPrint('[ArticleModel] Missing required fields in JSON item: $json');
        return null;
      }
      if (json['id'] == null || json['title'] == null || json['url'] == null) {
        debugPrint('[ArticleModel] Null required fields in JSON item: $json');
        return null;
      }
      return ArticleModel.fromJson(json);
    } catch (e) {
      debugPrint('[ArticleModel] Exception parsing JSON item: $e');
      return null;
    }
  }
}
