import 'package:flutter_test/flutter_test.dart';
import 'package:newspulse/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter', () {
    final now = DateTime(2026, 10, 3, 12, 0, 0);

    test('returns empty string for null or empty ISO string', () {
      expect(DateFormatter.formatRelative(null), '');
      expect(DateFormatter.formatRelative(''), '');
      expect(DateFormatter.formatRelative('invalid-date'), '');
    });

    test('formats less than 60s as Just now', () {
      final iso = now.subtract(const Duration(seconds: 30)).toIso8601String();
      expect(DateFormatter.formatRelative(iso, now: now), 'Just now');
    });

    test('formats minutes under 60m as Nm ago', () {
      final iso = now.subtract(const Duration(minutes: 15)).toIso8601String();
      expect(DateFormatter.formatRelative(iso, now: now), '15m ago');
    });

    test('formats hours under 24h as Nh ago', () {
      final iso = now.subtract(const Duration(hours: 4)).toIso8601String();
      expect(DateFormatter.formatRelative(iso, now: now), '4h ago');
    });

    test('formats dates 24h or older as dd MMM yyyy', () {
      final iso = DateTime(2026, 9, 20, 10, 0, 0).toIso8601String();
      expect(DateFormatter.formatRelative(iso, now: now), '20 Sep 2026');
    });
  });
}
