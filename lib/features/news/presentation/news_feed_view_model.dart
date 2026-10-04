import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../core/error/failures.dart';
import '../../../core/utils/debouncer.dart';
import '../domain/article.dart';
import '../domain/news_repository.dart';
import 'news_feed_state.dart';

class NewsFeedViewModel extends ChangeNotifier {
  final NewsRepository newsRepository;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 400));

  NewsFeedState _state = const NewsFeedState();
  CancelToken? _cancelToken;
  int _requestId = 0;

  List<Article>? _cachedDefaultPage;
  int _cachedDefaultTotal = 0;
  bool _cachedDefaultHasMore = true;

  NewsFeedViewModel({required this.newsRepository}) {
    fetchInitialFeed();
  }

  NewsFeedState get state => _state;

  @override
  void dispose() {
    _debouncer.dispose();
    _cancelToken?.cancel('ViewModel disposed');
    super.dispose();
  }

  Future<void> fetchInitialFeed() async {
    _cancelToken?.cancel('New fetch started');
    _cancelToken = CancelToken();

    final currentRequestId = ++_requestId;

    _state = _state.copyWith(
      status: NewsFeedStatus.loading,
      failure: null,
      paginationFailure: null,
    );
    notifyListeners();

    final result = await newsRepository.getArticles(
      limit: 10,
      offset: 0,
      search: _state.query,
      cancelToken: _cancelToken,
    );

    if (currentRequestId != _requestId) return;

    result.when(
      success: (page) {
        if (_state.query.isEmpty) {
          _cachedDefaultPage = page.items;
          _cachedDefaultTotal = page.total;
          _cachedDefaultHasMore = page.hasMore;
        }

        if (page.items.isEmpty) {
          _state = _state.copyWith(
            status: NewsFeedStatus.empty,
            items: [],
            hasMore: false,
            totalResults: page.total,
          );
        } else {
          _state = _state.copyWith(
            status: NewsFeedStatus.success,
            items: page.items,
            hasMore: page.hasMore,
            totalResults: page.total,
          );
        }
        notifyListeners();
      },
      err: (failure) {
        if (failure == const Failure.unknown('Request cancelled')) return;

        _state = _state.copyWith(
          status: NewsFeedStatus.error,
          failure: failure,
        );
        notifyListeners();
      },
    );
  }

  void onSearchQueryChanged(String newQuery) {
    final trimmed = newQuery.trim();
    if (_state.query == trimmed) return;

    _state = _state.copyWith(query: trimmed);

    if (trimmed.isEmpty) {
      _debouncer.cancel();
      _cancelToken?.cancel('Search cleared');

      if (_cachedDefaultPage != null) {
        _state = _state.copyWith(
          status: _cachedDefaultPage!.isEmpty ? NewsFeedStatus.empty : NewsFeedStatus.success,
          items: _cachedDefaultPage!,
          hasMore: _cachedDefaultHasMore,
          totalResults: _cachedDefaultTotal,
          failure: null,
        );
        notifyListeners();
      } else {
        fetchInitialFeed();
      }
      return;
    }

    _debouncer.run(() {
      fetchInitialFeed();
    });
  }

  void clearSearch() {
    onSearchQueryChanged('');
  }

  Future<void> fetchNextPage() async {
    if (_state.isLoadingMore || !_state.hasMore || _state.status != NewsFeedStatus.success) {
      return;
    }

    final currentRequestId = _requestId;

    _state = _state.copyWith(
      isLoadingMore: true,
      paginationFailure: null,
    );
    notifyListeners();

    final offset = _state.items.length;
    final result = await newsRepository.getArticles(
      limit: 10,
      offset: offset,
      search: _state.query,
      cancelToken: _cancelToken,
    );

    if (currentRequestId != _requestId) return;

    result.when(
      success: (page) {
        final combined = [..._state.items, ...page.items];
        // Deduplicate by ID
        final seenIds = <int>{};
        final deduped = combined.where((item) => seenIds.add(item.id)).toList();

        _state = _state.copyWith(
          items: deduped,
          isLoadingMore: false,
          hasMore: page.hasMore,
          totalResults: page.total,
        );
        notifyListeners();
      },
      err: (failure) {
        if (failure == const Failure.unknown('Request cancelled')) return;

        _state = _state.copyWith(
          isLoadingMore: false,
          paginationFailure: failure,
        );
        notifyListeners();
      },
    );
  }

  Future<Failure?> refresh() async {
    _cancelToken?.cancel('Refresh triggered');
    _cancelToken = CancelToken();
    final currentRequestId = ++_requestId;

    final result = await newsRepository.getArticles(
      limit: 10,
      offset: 0,
      search: _state.query,
      cancelToken: _cancelToken,
    );

    if (currentRequestId != _requestId) return null;

    return result.when(
      success: (page) {
        if (_state.query.isEmpty) {
          _cachedDefaultPage = page.items;
          _cachedDefaultTotal = page.total;
          _cachedDefaultHasMore = page.hasMore;
        }

        _state = _state.copyWith(
          status: page.items.isEmpty ? NewsFeedStatus.empty : NewsFeedStatus.success,
          items: page.items,
          hasMore: page.hasMore,
          totalResults: page.total,
          failure: null,
          paginationFailure: null,
        );
        notifyListeners();
        return null;
      },
      err: (failure) {
        if (failure == const Failure.unknown('Request cancelled')) return null;
        // Keep existing list, return failure to surface via SnackBar
        notifyListeners();
        return failure;
      },
    );
  }

  void onConnectivityRestored() {
    if (_state.status == NewsFeedStatus.error) {
      fetchInitialFeed();
    }
  }
}
