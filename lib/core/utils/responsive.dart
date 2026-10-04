/// Shared responsive-layout utilities used across the app.
abstract class AppResponsive {
  /// Returns the number of grid columns for a given screen [width].
  ///
  /// Breakpoints:
  /// - ≥ 1000 px → 3 columns (large tablet / desktop)
  /// - ≥ 600 px  → 2 columns (tablet / landscape phone)
  /// - < 600 px  → 1 column  (phone)
  static int crossAxisCount(double width) {
    if (width >= 1000.0) return 3;
    if (width >= 600.0) return 2;
    return 1;
  }
}
