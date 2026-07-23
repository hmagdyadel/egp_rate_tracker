import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart' as loader;

import 'package:egp_rate_tracker/core/theme/app_colors.dart';

/// Reusable spinner widget wrapping [loader.SpinKitThreeBounce].
class Loader extends StatelessWidget {
  const Loader({this.size, this.color, super.key});

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return loader.SpinKitThreeBounce(
      color: color ?? AppColors.primary,
      size: size ?? 30.0,
    );
  }
}
