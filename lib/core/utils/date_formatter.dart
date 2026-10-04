import 'package:intl/intl.dart';

abstract class DateFormatter {
  static String formatRelative(String? isoString, {DateTime? now}) {
    if (isoString == null || isoString.isEmpty) {
      return '';
    }

    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      final currentTime = now ?? DateTime.now();
      final difference = currentTime.difference(dateTime);

      if (difference.isNegative) {
        return DateFormat('dd MMM yyyy').format(dateTime);
      }

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return DateFormat('dd MMM yyyy').format(dateTime);
      }
    } catch (_) {
      return '';
    }
  }
}
