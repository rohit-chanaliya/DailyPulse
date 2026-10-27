import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAssetIcon extends StatelessWidget {
  const HomeAssetIcon(this.path, {super.key, this.size = 24});

  final String path;
  final double size;

  @override
  Widget build(BuildContext context) {
    return switch (path.endsWith('.svg')) {
      true => SvgPicture.asset(path, width: size, height: size),
      false => Image.asset(path, width: size, height: size),
    };
  }
}
