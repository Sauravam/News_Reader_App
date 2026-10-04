import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:newspulse/app/app_router.dart';
import 'package:newspulse/core/network/connectivity_service.dart';
import 'package:newspulse/core/theme/app_theme.dart';
import 'package:newspulse/core/utils/result.dart';
import 'package:newspulse/features/auth/data/mock_auth_repository.dart';
import 'package:newspulse/features/auth/presentation/auth_view_model.dart';
import 'package:newspulse/features/bookmarks/data/bookmark_local_data_source.dart';
import 'package:newspulse/features/bookmarks/data/bookmark_repository_impl.dart';
import 'package:newspulse/features/bookmarks/domain/bookmark_repository.dart';
import 'package:newspulse/features/bookmarks/presentation/bookmarks_view_model.dart';
import 'package:newspulse/features/news/domain/article.dart';
import 'package:newspulse/features/news/domain/news_page.dart';
import 'package:newspulse/features/news/domain/news_repository.dart';
import 'package:newspulse/features/news/presentation/news_feed_view_model.dart';
import 'package:newspulse/features/news/presentation/widgets/article_card.dart';
import 'package:newspulse/features/settings/presentation/theme_view_model.dart';
import 'package:provider/provider.dart';

class MockNewsRepository extends Mock implements NewsRepository {}
class MockConnectivityService extends Mock implements ConnectivityService {}
class FakeCancelToken extends Fake implements CancelToken {}

void main() {
  late Directory tempDir;
  late Box<dynamic> sessionBox;
  late Box<dynamic> bookmarksBox;
  late Box<dynamic> settingsBox;

  setUpAll(() async {
    registerFallbackValue(FakeCancelToken());
    tempDir = Directory.systemTemp.createTempSync('hive_integration_test_');
    Hive.init(tempDir.path);
    sessionBox = await Hive.openBox<dynamic>('integration_session');
    bookmarksBox = await Hive.openBox<dynamic>('integration_bookmarks');
    settingsBox = await Hive.openBox<dynamic>('integration_settings');
  });

  late MockAuthRepository authRepository;
  late BookmarkRepository bookmarkRepository;
  late MockNewsRepository mockNewsRepository;
  late MockConnectivityService mockConnectivityService;

  late AuthViewModel authViewModel;
  late ThemeViewModel themeViewModel;
  late BookmarksViewModel bookmarksViewModel;
  late NewsFeedViewModel newsFeedViewModel;

  const testArticle = Article(
    id: 501,
    title: 'Starship Orbital Test Flight',
    url: 'https://spacex.com/starship',
    imageUrl: null,
    newsSite: 'SpaceX',
    summary: 'Starship flight test successful.',
  );

  tearDownAll(() {
    if (tempDir.existsSync()) {
      try {
        tempDir.deleteSync(recursive: true);
      } catch (_) {}
    }
  });

  setUp(() async {
    await sessionBox.clear();
    await bookmarksBox.clear();
    await settingsBox.clear();

    authRepository = MockAuthRepository(sessionBox: sessionBox);
    final bookmarkLocalDS = BookmarkLocalDataSourceImpl(bookmarksBox: bookmarksBox);
    bookmarkRepository = BookmarkRepositoryImpl(localDataSource: bookmarkLocalDS);

    mockNewsRepository = MockNewsRepository();
    mockConnectivityService = MockConnectivityService();

    when(() => mockConnectivityService.isOnlineStream).thenAnswer((_) => Stream.value(true));
    when(() => mockConnectivityService.isOnline).thenAnswer((_) async => true);

    when(() => mockNewsRepository.getArticles(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
          search: any(named: 'search'),
          cancelToken: any(named: 'cancelToken'),
        )).thenAnswer((_) async => Result.success(
          const NewsPage(items: [testArticle], hasMore: false, total: 1),
        ));

    authViewModel = AuthViewModel(authRepository: authRepository);
    themeViewModel = ThemeViewModel(settingsBox: settingsBox);
    bookmarksViewModel = BookmarksViewModel(bookmarkRepository: bookmarkRepository);
    newsFeedViewModel = NewsFeedViewModel(newsRepository: mockNewsRepository);
  });

  tearDown(() async {
    authViewModel.dispose();
    themeViewModel.dispose();
    bookmarksViewModel.dispose();
    newsFeedViewModel.dispose();
  });

  Widget buildAppWidget() {
    final router = AppRouter.createRouter(
      authViewModel: authViewModel,
      connectivityService: mockConnectivityService,
    );

    return MultiProvider(
      providers: [
        Provider<NewsRepository>.value(value: mockNewsRepository),
        Provider<BookmarkRepository>.value(value: bookmarkRepository),
        Provider<ConnectivityService>.value(value: mockConnectivityService),
        ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
        ChangeNotifierProvider<ThemeViewModel>.value(value: themeViewModel),
        ChangeNotifierProvider<BookmarksViewModel>.value(value: bookmarksViewModel),
        ChangeNotifierProvider<NewsFeedViewModel>.value(value: newsFeedViewModel),
      ],
      child: MaterialApp.router(
        title: 'News Reader Test',
        theme: AppTheme.light,
        routerConfig: router,
      ),
    );
  }

  testWidgets('Integration Flow: Login -> News Feed -> Bookmark Article -> Bookmarks Tab', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(buildAppWidget());
    await tester.pump();

    // 1. Verify Login Screen displays
    expect(find.text('Welcome Back'), findsOneWidget);

    // 2. Enter valid credentials and Submit
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'Password123');

    final submitButton = find.text('Sign In');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 300));

    // 3. Verify Home Screen
    expect(find.text('News Reader'), findsWidgets);
    expect(find.text('Starship Orbital Test Flight'), findsOneWidget);

    // 4. Bookmark Article
    final cardIconButton = find.descendant(
      of: find.byType(ArticleCard),
      matching: find.byType(IconButton),
    );
    await tester.tap(cardIconButton);
    await tester.pump(const Duration(milliseconds: 250));

    // 5. Navigate to Bookmarks Tab
    final bookmarksNavIcon = find.byIcon(Icons.bookmark_outline_rounded);
    await tester.tap(bookmarksNavIcon);
    await tester.pump(const Duration(milliseconds: 300));

    // 6. Verify Bookmarks Tab
    expect(find.text('Starship Orbital Test Flight'), findsWidgets);
  });
}
