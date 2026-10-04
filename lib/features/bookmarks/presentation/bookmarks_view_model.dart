import 'package:flutter/material.dart';

import '../../news/domain/article.dart';
import '../domain/bookmark_repository.dart';

class BookmarksViewModel extends ChangeNotifier {
  final BookmarkRepository bookmarkRepository;
  List<Article> _bookmarkedArticles = [];
  final Set<int> _bookmarkedIds = {};

  BookmarksViewModel({required this.bookmarkRepository}) {
    loadBookmarks();
  }

  List<Article> get bookmarkedArticles => List.unmodifiable(_bookmarkedArticles);
  Set<int> get bookmarkedIds => Set.unmodifiable(_bookmarkedIds);

  bool isBookmarked(int articleId) => _bookmarkedIds.contains(articleId);

  void loadBookmarks() {
    _bookmarkedArticles = bookmarkRepository.getBookmarks();
    _bookmarkedIds.clear();
    _bookmarkedIds.addAll(_bookmarkedArticles.map((a) => a.id));
    notifyListeners();
  }

  Future<void> toggleBookmark(Article article) async {
    final isSaved = isBookmarked(article.id);
    if (isSaved) {
      _bookmarkedIds.remove(article.id);
      _bookmarkedArticles.removeWhere((a) => a.id == article.id);
      notifyListeners();
      await bookmarkRepository.removeBookmark(article.id);
    } else {
      _bookmarkedIds.add(article.id);
      _bookmarkedArticles.insert(0, article);
      notifyListeners();
      await bookmarkRepository.addBookmark(article);
    }
  }

  Future<void> removeBookmark(int articleId) async {
    _bookmarkedIds.remove(articleId);
    _bookmarkedArticles.removeWhere((a) => a.id == articleId);
    notifyListeners();
    await bookmarkRepository.removeBookmark(articleId);
  }

  Future<void> restoreBookmark(Article article, int index) async {
    _bookmarkedIds.add(article.id);
    if (index >= 0 && index <= _bookmarkedArticles.length) {
      _bookmarkedArticles.insert(index, article);
    } else {
      _bookmarkedArticles.add(article);
    }
    notifyListeners();
    await bookmarkRepository.addBookmark(article);
  }
}
