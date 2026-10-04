import 'package:freezed_annotation/freezed_annotation.dart';

import 'article.dart';

part 'news_page.freezed.dart';

@freezed
abstract class NewsPage with _$NewsPage {
  const factory NewsPage({
    required List<Article> items,
    required bool hasMore,
    required int total,
  }) = _NewsPage;
}
