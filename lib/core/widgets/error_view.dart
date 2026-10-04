import 'package:flutter/material.dart';

import '../error/failures.dart';
import '../theme/app_colors.dart';

class ErrorView extends StatelessWidget {
  final Failure? failure;
  final String? title;
  final String? message;
  final IconData? icon;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    this.failure,
    this.title,
    this.message,
    this.icon,
    this.onRetry,
  });

  IconData _getIcon(BuildContext context) {
    if (icon != null) return icon!;
    return failure?.when(
          noInternet: () => Icons.wifi_off_rounded,
          timeout: () => Icons.timer_off_rounded,
          invalidResponse: () => Icons.data_object_rounded,
          server: (code) => Icons.dns_rounded,
          unknown: (msg) => Icons.error_outline_rounded,
        ) ??
        Icons.error_outline_rounded;
  }

  String _getTitle() {
    if (title != null) return title!;
    return failure?.when(
          noInternet: () => 'No Internet Connection',
          timeout: () => 'Connection Timed Out',
          invalidResponse: () => 'Invalid Response',
          server: (code) => code != null ? 'Server Error ($code)' : 'Server Error',
          unknown: (msg) => 'Something Went Wrong',
        ) ??
        'Error Occurred';
  }

  String _getMessage() {
    if (message != null) return message!;
    return failure?.when(
          noInternet: () => 'Please check your internet connection and try again.',
          timeout: () => 'The request took too long to respond. Please try again.',
          invalidResponse: () => 'Received an unexpected response format from the server.',
          server: (code) => 'The server returned an error. Please try again later.',
          unknown: (msg) => msg ?? 'An unexpected error occurred. Please try again.',
        ) ??
        'An error occurred while loading content.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorIcon = _getIcon(context);
    final errorTitle = _getTitle();
    final errorMessage = _getMessage();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                errorIcon,
                size: 48.0,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              errorTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
