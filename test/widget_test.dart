import 'package:flutter_test/flutter_test.dart';

import 'unit/validators_test.dart' as validators_test;

void main() {
  group('App Bootstrap Tests', () {
    test('Placeholder test runner', () {
      expect(true, isTrue);
    });
  });

  validators_test.main();
}
