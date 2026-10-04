import 'package:hive_ce/hive.dart';

import '../../news/domain/article.dart';

abstract class BookmarkLocalDataSource {
  List<Article> getBookmarkedArticles();
  bool isBookmarked(int articleId);
  Future<void> addBookmark(Article article);
  Future<void> removeBookmark(int articleId);
}

class BookmarkLocalDataSourceImpl implements BookmarkLocalDataSource {
  final Box<dynamic> bookmarksBox;

  BookmarkLocalDataSourceImpl({required this.bookmarksBox});

  @override
  List<Article> getBookmarkedArticles() {
    final List<Map<String, dynamic>> items = [];

    for (final key in bookmarksBox.keys) {
      final value = bookmarksBox.get(key);
      if (value is Map) {
        items.add(Map<String, dynamic>.from(value));
      }
    }

    // Sort newest-first by savedAt timestamp
    items.sort((a, b) {
      final aTime = a['savedAt'] as String? ?? '';
      final bTime = b['savedAt'] as String? ?? '';
      return bTime.compareTo(aTime);
    });

    return items.map((map) => Article.fromJson(map)).toList();
  }

  @override
  bool isBookmarked(int articleId) {
    return bookmarksBox.containsKey(articleId.toString());
  }

  @override
  Future<void> addBookmark(Article article) async {
    final map = article.toJson();
    map['savedAt'] = DateTime.now().toIso8601String();
    bookmarksBox.put(article.id.toString(), map);
  }

  @override
  Future<void> removeBookmark(int articleId) async {
    bookmarksBox.delete(articleId.toString());
  }
}
