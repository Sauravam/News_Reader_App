import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:newspulse/features/bookmarks/data/bookmark_local_data_source.dart';
import 'package:newspulse/features/news/domain/article.dart';

void main() {
  late Directory tempDir;
  late Box<dynamic> box;
  late BookmarkLocalDataSourceImpl dataSource;

  const sampleArticle = Article(
    id: 99,
    title: 'Saved Article Test',
    url: 'https://example.com/saved',
  );

  setUp(() async {
    tempDir = Directory.systemTemp.createTempSync('hive_test_');
    Hive.init(tempDir.path);
    box = await Hive.openBox<dynamic>('test_bookmarks');
    dataSource = BookmarkLocalDataSourceImpl(bookmarksBox: box);
  });

  tearDown(() async {
    await box.close();
    await Hive.deleteBoxFromDisk('test_bookmarks');
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('BookmarkLocalDataSource', () {
    test('adds article to box and retrieves it', () async {
      expect(dataSource.isBookmarked(99), isFalse);

      await dataSource.addBookmark(sampleArticle);

      expect(dataSource.isBookmarked(99), isTrue);
      final list = dataSource.getBookmarkedArticles();
      expect(list.length, 1);
      expect(list.first.title, 'Saved Article Test');
    });

    test('persists bookmarks after box is closed and reopened', () async {
      await dataSource.addBookmark(sampleArticle);
      await box.close();

      final reopenedBox = await Hive.openBox<dynamic>('test_bookmarks');
      final newDataSource = BookmarkLocalDataSourceImpl(bookmarksBox: reopenedBox);

      expect(newDataSource.isBookmarked(99), isTrue);
      expect(newDataSource.getBookmarkedArticles().first.id, 99);
      await reopenedBox.close();
    });

    test('removes article from box', () async {
      await dataSource.addBookmark(sampleArticle);
      expect(dataSource.isBookmarked(99), isTrue);

      await dataSource.removeBookmark(99);
      expect(dataSource.isBookmarked(99), isFalse);
      expect(dataSource.getBookmarkedArticles(), isEmpty);
    });
  });
}
