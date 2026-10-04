import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app_router.dart';
import 'core/network/connectivity_service.dart';
import 'core/network/dio_client.dart';
import 'core/storage/hive_boxes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/mock_auth_repository.dart';
import 'features/auth/domain/auth_repository.dart';
import 'features/auth/presentation/auth_view_model.dart';
import 'features/bookmarks/data/bookmark_local_data_source.dart';
import 'features/bookmarks/data/bookmark_repository_impl.dart';
import 'features/bookmarks/domain/bookmark_repository.dart';
import 'features/bookmarks/presentation/bookmarks_view_model.dart';
import 'features/news/data/news_remote_data_source.dart';
import 'features/news/data/news_repository_impl.dart';
import 'features/news/domain/news_repository.dart';
import 'features/news/presentation/news_feed_view_model.dart';
import 'features/settings/presentation/theme_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveBoxes.init();

  final authRepository = MockAuthRepository(sessionBox: HiveBoxes.sessionBox);
  await authRepository.restoreSession();

  final connectivityService = ConnectivityServiceImpl();
  final dio = DioClient.create();

  final newsRemoteDataSource = NewsRemoteDataSourceImpl(dio: dio);
  final newsRepository = NewsRepositoryImpl(remoteDataSource: newsRemoteDataSource);

  final bookmarkLocalDataSource = BookmarkLocalDataSourceImpl(bookmarksBox: HiveBoxes.bookmarksBox);
  final bookmarkRepository = BookmarkRepositoryImpl(localDataSource: bookmarkLocalDataSource);

  runApp(
    NewsReaderApp(
      authRepository: authRepository,
      connectivityService: connectivityService,
      newsRepository: newsRepository,
      bookmarkRepository: bookmarkRepository,
    ),
  );
}

class NewsReaderApp extends StatefulWidget {
  final AuthRepository authRepository;
  final ConnectivityService connectivityService;
  final NewsRepository newsRepository;
  final BookmarkRepository bookmarkRepository;

  const NewsReaderApp({
    super.key,
    required this.authRepository,
    required this.connectivityService,
    required this.newsRepository,
    required this.bookmarkRepository,
  });

  @override
  State<NewsReaderApp> createState() => _NewsReaderAppState();
}

class _NewsReaderAppState extends State<NewsReaderApp> {
  late final AuthViewModel _authViewModel;
  late final ThemeViewModel _themeViewModel;
  late final BookmarksViewModel _bookmarksViewModel;
  late final NewsFeedViewModel _newsFeedViewModel;

  @override
  void initState() {
    super.initState();
    _authViewModel = AuthViewModel(authRepository: widget.authRepository);
    _themeViewModel = ThemeViewModel(settingsBox: HiveBoxes.settingsBox);
    _bookmarksViewModel = BookmarksViewModel(bookmarkRepository: widget.bookmarkRepository);
    _newsFeedViewModel = NewsFeedViewModel(newsRepository: widget.newsRepository);
  }

  @override
  void dispose() {
    _authViewModel.dispose();
    _themeViewModel.dispose();
    _bookmarksViewModel.dispose();
    _newsFeedViewModel.dispose();
    widget.connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter(
      authViewModel: _authViewModel,
      connectivityService: widget.connectivityService,
    );

    return MultiProvider(
      providers: [
        Provider<NewsRepository>.value(value: widget.newsRepository),
        Provider<BookmarkRepository>.value(value: widget.bookmarkRepository),
        Provider<ConnectivityService>.value(value: widget.connectivityService),
        ChangeNotifierProvider.value(value: _authViewModel),
        ChangeNotifierProvider.value(value: _themeViewModel),
        ChangeNotifierProvider.value(value: _bookmarksViewModel),
        ChangeNotifierProvider.value(value: _newsFeedViewModel),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeVM, child) {
          return MaterialApp.router(
            title: 'News Reader',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeVM.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
