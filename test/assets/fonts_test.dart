import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Urbanist font variants are bundled for offline use', () async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = manifest.listAssets();

    for (final variant in [
      'Regular',
      'Medium',
      'SemiBold',
      'Bold',
      'ExtraBold',
    ]) {
      expect(
        assets.any((asset) => asset.endsWith('Urbanist-$variant.ttf')),
        isTrue,
        reason: 'Urbanist-$variant.ttf is missing from the asset bundle',
      );
    }
  });
}
