import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../bookmarks/presentation/bookmarks_view_model.dart';
import '../../domain/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = DateFormatter.formatRelative(article.publishedAt);
    final isSaved = context.select<BookmarksViewModel, bool>(
      (vm) => vm.isBookmarked(article.id),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: InkWell(
        onTap: () {
          context.pushNamed(
            'articleDetail',
            pathParameters: {'id': article.id.toString()},
            extra: article,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 16:9 Thumbnail Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Hero(
                tag: 'hero_article_image_${article.id}',
                child: article.imageUrl != null && article.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: article.imageUrl!,
                        fit: BoxFit.cover,
                        memCacheWidth: 600,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: theme.brightness == Brightness.dark
                              ? AppColors.surfaceDark
                              : Colors.grey.shade300,
                          highlightColor: theme.brightness == Brightness.dark
                              ? AppColors.outlineDark
                              : Colors.grey.shade100,
                          child: Container(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => _buildFallbackImage(theme),
                      )
                    : _buildFallbackImage(theme),
              ),
            ),

            // Content Area
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta Row: Source Chip & Date & Bookmark Button
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
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      if (formattedDate.isNotEmpty)
                        Text(
                          formattedDate,
                          style: theme.textTheme.bodySmall,
                        ),
                      const Spacer(),

                      // Bookmark Toggle Button
                      Semantics(
                        label: isSaved ? 'Remove bookmark' : 'Bookmark article',
                        button: true,
                        child: SizedBox(
                          width: 48.0,
                          height: 48.0,
                          child: IconButton(
                            iconSize: 24.0,
                            onPressed: () {
                              context.read<BookmarksViewModel>().toggleBookmark(article);
                            },
                            icon: AnimatedScale(
                              scale: isSaved ? 1.15 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Icon(
                                isSaved
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_outline_rounded,
                                color: isSaved
                                    ? AppColors.secondaryLight
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Title (max 2 lines)
                  Text(
                    article.title,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Summary (max 3 lines)
                  if (article.summary != null && article.summary!.trim().isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      article.summary!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage(ThemeData theme) {
    return Container(
      color: theme.brightness == Brightness.dark
          ? AppColors.surfaceDark
          : AppColors.outlineLight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper_rounded,
              size: 48.0,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'News Reader',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
