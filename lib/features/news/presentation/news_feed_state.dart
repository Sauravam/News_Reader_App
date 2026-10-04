import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/failures.dart';
import '../domain/article.dart';

part 'news_feed_state.freezed.dart';

enum NewsFeedStatus { initial, loading, success, empty, error }

@freezed
abstract class NewsFeedState with _$NewsFeedState {
  const factory NewsFeedState({
    @Default(NewsFeedStatus.initial) NewsFeedStatus status,
    @Default([]) List<Article> items,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default(0) int totalResults,
    Failure? failure,
    Failure? paginationFailure,
    @Default('') String query,
  }) = _NewsFeedState;
}
