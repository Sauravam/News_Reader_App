import '../../news/domain/article.dart';
import '../domain/bookmark_repository.dart';
import 'bookmark_local_data_source.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final BookmarkLocalDataSource localDataSource;

  BookmarkRepositoryImpl({required this.localDataSource});

  @override
  List<Article> getBookmarks() {
    return localDataSource.getBookmarkedArticles();
  }

  @override
  bool isBookmarked(int articleId) {
    return localDataSource.isBookmarked(articleId);
  }

  @override
  Future<void> addBookmark(Article article) {
    return localDataSource.addBookmark(article);
  }

  @override
  Future<void> removeBookmark(int articleId) {
    return localDataSource.removeBookmark(articleId);
  }
}
