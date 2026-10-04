import '../../news/domain/article.dart';

abstract class BookmarkRepository {
  List<Article> getBookmarks();
  bool isBookmarked(int articleId);
  Future<void> addBookmark(Article article);
  Future<void> removeBookmark(int articleId);
}
