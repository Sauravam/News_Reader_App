import 'package:go_router/go_router.dart';

import '../core/network/connectivity_service.dart';
import '../features/auth/presentation/auth_view_model.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/bookmarks/presentation/bookmarks_screen.dart';
import '../features/news/domain/article.dart';
import '../features/news/presentation/article_detail_screen.dart';
import '../features/news/presentation/news_feed_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/shell/presentation/shell_screen.dart';

abstract class AppRouter {
  static GoRouter createRouter({
    required AuthViewModel authViewModel,
    required ConnectivityService connectivityService,
  }) {
    return GoRouter(
      initialLocation: authViewModel.isLoggedIn ? '/home' : '/login',
      refreshListenable: authViewModel,
      redirect: (context, state) {
        final isLoggedIn = authViewModel.isLoggedIn;
        final isLoggingIn = state.matchedLocation == '/login';

        if (!isLoggedIn && !isLoggingIn) {
          return '/login';
        }
        if (isLoggedIn && isLoggingIn) {
          return '/home';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return ShellScreen(
              navigationShell: navigationShell,
              connectivityService: connectivityService,
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  name: 'home',
                  builder: (context, state) => const NewsFeedScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/bookmarks',
                  name: 'bookmarks',
                  builder: (context, state) => const BookmarksScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/settings',
                  name: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/article/:id',
          name: 'articleDetail',
          builder: (context, state) {
            final articleIdStr = state.pathParameters['id'];
            final articleId = int.tryParse(articleIdStr ?? '');
            final extraArticle = state.extra as Article?;

            return ArticleDetailScreen(
              articleId: articleId,
              article: extraArticle,
            );
          },
        ),
      ],
    );
  }
}
