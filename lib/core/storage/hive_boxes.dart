import 'package:hive_ce_flutter/hive_ce_flutter.dart';

abstract class HiveBoxes {
  static const String bookmarks = 'bookmarks';
  static const String session = 'session';
  static const String settings = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<dynamic>(bookmarks),
      Hive.openBox<dynamic>(session),
      Hive.openBox<dynamic>(settings),
    ]);
  }

  static Box<dynamic> get bookmarksBox => Hive.box<dynamic>(bookmarks);
  static Box<dynamic> get sessionBox => Hive.box<dynamic>(session);
  static Box<dynamic> get settingsBox => Hive.box<dynamic>(settings);
}
