import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/error_view.dart';
import 'news_feed_state.dart';
import 'news_feed_view_model.dart';
import 'widgets/article_card.dart';
import 'widgets/news_search_bar.dart';
import 'widgets/shimmer_article_card.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= 400.0) {
      context.read<NewsFeedViewModel>().fetchNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final crossAxisCount = AppResponsive.crossAxisCount(width);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Reader',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Consumer<NewsFeedViewModel>(
        builder: (context, viewModel, child) {
          final state = viewModel.state;

          return RefreshIndicator(
            onRefresh: () async {
              final failure = await viewModel.refresh();
              if (failure != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      failure.when(
                        noInternet: () => 'No internet connection',
                        timeout: () => 'Connection timed out',
                        invalidResponse: () => 'Invalid response',
                        server: (code) => 'Server error ($code)',
                        unknown: (msg) => msg ?? 'Failed to refresh feed',
                      ),
                    ),
                  ),
                );
              }
            },
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200.0),
                child: CustomScrollView(
                  controller: _scrollController,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    // Search Bar
                    SliverToBoxAdapter(
                      child: NewsSearchBar(
                        initialQuery: state.query,
                        onChanged: viewModel.onSearchQueryChanged,
                        onClear: viewModel.clearSearch,
                      ),
                    ),

                    // Query Header Count
                    if (state.query.isNotEmpty && state.status == NewsFeedStatus.success)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                            vertical: AppSpacing.sm,
                          ),
                          child: Text(
                            '${state.totalResults} results for "${state.query}"',
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),

                    // Main Content
                    ..._buildSliversForStatus(context, viewModel, state, crossAxisCount),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildSliversForStatus(
    BuildContext context,
    NewsFeedViewModel viewModel,
    NewsFeedState state,
    int crossAxisCount,
  ) {
    final theme = Theme.of(context);

    switch (state.status) {
      case NewsFeedStatus.initial:
      case NewsFeedStatus.loading:
        return [
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: crossAxisCount == 1
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const ShimmerArticleCard(),
                      childCount: 4,
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
                      (context, index) => const ShimmerArticleCard(),
                      childCount: 6,
                    ),
                  ),
          ),
        ];

      case NewsFeedStatus.error:
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: ErrorView(
              failure: state.failure,
              onRetry: viewModel.fetchInitialFeed,
            ),
          ),
        ];

      case NewsFeedStatus.empty:
        return [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 64.0,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      state.query.isNotEmpty
                          ? 'No results for "${state.query}"'
                          : 'No articles yet',
                      style: theme.textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      state.query.isNotEmpty
                          ? 'Try searching with different keywords.'
                          : 'Check back later for updates.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (state.query.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xl),
                      OutlinedButton.icon(
                        onPressed: viewModel.clearSearch,
                        icon: const Icon(Icons.clear_rounded),
                        label: const Text('Clear search'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ];

      case NewsFeedStatus.success:
        return [
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            sliver: crossAxisCount == 1
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ArticleCard(article: state.items[index]);
                      },
                      childCount: state.items.length,
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
                      (context, index) {
                        return ArticleCard(article: state.items[index]);
                      },
                      childCount: state.items.length,
                    ),
                  ),
          ),

          // Pagination Footer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: _buildFooter(context, viewModel, state),
            ),
          ),
        ];
    }
  }

  Widget _buildFooter(
    BuildContext context,
    NewsFeedViewModel viewModel,
    NewsFeedState state,
  ) {
    final theme = Theme.of(context);

    if (state.isLoadingMore) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.paginationFailure != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Couldn\'t load more',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            TextButton.icon(
              onPressed: viewModel.fetchNextPage,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!state.hasMore && state.items.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            'You\'re all caught up',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
