import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:newspulse/features/bookmarks/domain/bookmark_repository.dart';
import 'package:newspulse/features/bookmarks/presentation/bookmarks_view_model.dart';
import 'package:newspulse/features/news/domain/article.dart';
import 'package:newspulse/features/news/presentation/widgets/article_card.dart';
import 'package:provider/provider.dart';

class MockBookmarkRepository extends Mock implements BookmarkRepository {}

void main() {
  late MockBookmarkRepository mockBookmarkRepository;
  late BookmarksViewModel bookmarksViewModel;

  const sampleArticle = Article(
    id: 42,
    title: 'Artemis Moon Landing Scheduled',
    url: 'https://nasa.gov/artemis',
    newsSite: 'NASA',
    summary: 'NASA prepares for crewed lunar landing.',
  );

  setUp(() {
    mockBookmarkRepository = MockBookmarkRepository();
    when(() => mockBookmarkRepository.getBookmarks()).thenReturn([]);
    when(() => mockBookmarkRepository.isBookmarked(42)).thenReturn(false);
    bookmarksViewModel = BookmarksViewModel(bookmarkRepository: mockBookmarkRepository);
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: ChangeNotifierProvider<BookmarksViewModel>.value(
            value: bookmarksViewModel,
            child: const ArticleCard(article: sampleArticle),
          ),
        ),
      ),
    );
  }

  group('ArticleCard Widget Tests', () {
    testWidgets('renders title, newsSite, and summary correctly', (tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Artemis Moon Landing Scheduled'), findsOneWidget);
      expect(find.text('NASA'), findsOneWidget);
      expect(find.text('NASA prepares for crewed lunar landing.'), findsOneWidget);
    });
  });
}
