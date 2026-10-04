import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../news/domain/article.dart';
import '../../news/presentation/widgets/article_card.dart';
import 'bookmarks_view_model.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = AppResponsive.crossAxisCount(width);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bookmarks',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Consumer<BookmarksViewModel>(
        builder: (context, viewModel, child) {
          final articles = viewModel.bookmarkedArticles;

          if (articles.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_outline_rounded,
                      size: 64.0,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'No bookmarks yet',
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Tap the bookmark icon on any article to save it for offline reading.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200.0),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    sliver: crossAxisCount == 1
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildDismissibleCard(
                                context: context,
                                viewModel: viewModel,
                                article: articles[index],
                                index: index,
                                listMargin: const EdgeInsets.only(bottom: AppSpacing.lg),
                              ),
                              childCount: articles.length,
                            ),
                          )
                        : SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: AppSpacing.lg,
                              crossAxisSpacing: AppSpacing.lg,
                              childAspectRatio: 0.85,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildDismissibleCard(
                                context: context,
                                viewModel: viewModel,
                                article: articles[index],
                                index: index,
                              ),
                              childCount: articles.length,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds a swipe-to-dismiss card with undo snack bar support.
  Widget _buildDismissibleCard({
    required BuildContext context,
    required BookmarksViewModel viewModel,
    required Article article,
    required int index,
    EdgeInsetsGeometry? listMargin,
  }) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey('dismiss_bookmark_${article.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        margin: listMargin,
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 28.0,
        ),
      ),
      onDismissed: (_) {
        viewModel.removeBookmark(article.id);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bookmark removed'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => viewModel.restoreBookmark(article, index),
            ),
          ),
        );
      },
      child: ArticleCard(article: article),
    );
  }
}
