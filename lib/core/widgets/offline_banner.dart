import 'package:flutter/material.dart';

import '../network/connectivity_service.dart';
import '../theme/app_colors.dart';

class OfflineBanner extends StatelessWidget {
  final ConnectivityService connectivityService;

  const OfflineBanner({
    super.key,
    required this.connectivityService,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: connectivityService.isOnlineStream,
      initialData: true,
      builder: (context, snapshot) {
        final isOnline = snapshot.data ?? true;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isOnline
              ? const SizedBox.shrink()
              : Container(
                  key: const ValueKey('offline_banner'),
                  width: double.infinity,
                  color: AppColors.tertiaryLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.wifi_off_rounded,
                        color: Colors.white,
                        size: 18.0,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'You are offline. Showing cached content.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
