import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/error_view.dart';
import '../../bookmarks/presentation/bookmarks_view_model.dart';
import '../domain/article.dart';
import '../domain/news_repository.dart';

class ArticleDetailScreen extends StatefulWidget {
  final int? articleId;
  final Article? article;

  const ArticleDetailScreen({
    super.key,
    this.articleId,
    this.article,
  });

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  Article? _resolvedArticle;
  bool _isLoading = false;
  Object? _fetchError;

  @override
  void initState() {
    super.initState();
    _resolveArticle();
  }

  Future<void> _resolveArticle() async {
    if (widget.article != null) {
      setState(() {
        _resolvedArticle = widget.article;
      });
      return;
    }

    if (widget.articleId == null) return;

    final bookmarksVM = context.read<BookmarksViewModel>();
    final bookmarked = bookmarksVM.bookmarkedArticles.firstWhere(
      (a) => a.id == widget.articleId,
      orElse: () => const Article(id: -1, title: '', url: ''),
    );

    if (bookmarked.id != -1) {
      setState(() {
        _resolvedArticle = bookmarked;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _fetchError = null;
    });

    final newsRepo = context.read<NewsRepository>();
    final result = await newsRepo.getArticleById(widget.articleId!);

    if (!mounted) return;

    result.when(
      success: (article) {
        setState(() {
          _resolvedArticle = article;
          _isLoading = false;
        });
      },
      err: (failure) {
        setState(() {
          _fetchError = failure;
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final Uri? uri = Uri.tryParse(urlString);
    if (uri == null) {
      _showErrorSnackBar('Invalid URL link');
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        _showErrorSnackBar('Could not launch URL');
      }
    } catch (_) {
      if (mounted) {
        _showErrorSnackBar('Could not launch browser');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_fetchError != null || _resolvedArticle == null) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          title: 'Article Not Found',
          message: 'Unable to load the requested article.',
          onRetry: _resolveArticle,
        ),
      );
    }

    final article = _resolvedArticle!;
    final formattedDate = DateFormatter.formatRelative(article.publishedAt);
    final isSaved = context.select<BookmarksViewModel, bool>(
      (vm) => vm.isBookmarked(article.id),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with Hero Image or Fallback Artwork
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            actions: [
              Semantics(
                label: isSaved ? 'Remove bookmark' : 'Bookmark article',
                button: true,
                child: IconButton(
                  onPressed: () {
                    context.read<BookmarksViewModel>().toggleBookmark(article);
                  },
                  icon: Icon(
                    isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                    color: isSaved ? AppColors.secondaryLight : null,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'hero_article_image_${article.id}',
                child: article.imageUrl != null && article.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: article.imageUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => _buildFallbackHeader(),
                      )
                    : _buildFallbackHeader(),
              ),
            ),
          ),

          // Content Body
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source Chip & Date
                      Row(
                        children: [
                          if (article.newsSite != null && article.newsSite!.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.tertiaryLight.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                article.newsSite!,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: AppColors.tertiaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                          ],
                          if (formattedDate.isNotEmpty)
                            Text(
                              formattedDate,
                              style: theme.textTheme.bodySmall,
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Article Title
                      Text(
                        article.title,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Full Summary Body
                      if (article.summary != null && article.summary!.trim().isNotEmpty)
                        Text(
                          article.summary!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                        ),
                      const SizedBox(height: 32.0),

                      // Read Full Article Button
                      FilledButton.icon(
                        onPressed: () => _launchUrl(article.url),
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: const Text('Read full article'),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
      ),
      child: const Center(
        child: Icon(
          Icons.newspaper_rounded,
          size: 64.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
