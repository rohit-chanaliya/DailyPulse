import 'package:dailypulse/core/router/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppRoutes', () {
    test('publicRoutes contains verifyEmail route', () {
      expect(AppRoutes.publicRoutes.contains(AppRoutes.verifyEmail), isTrue);
    });

    test('verifyEmail path is correct', () {
      expect(AppRoutes.verifyEmail, equals('/verify-email'));
    });
  });
}
