// features/auth/presentation/widgets/auth_logo.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/constants/app_assets.dart';

/// Shared logo widget for authentication screens
class AuthLogo extends StatelessWidget {
  final double? size;

  const AuthLogo({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final logoSize = size ?? 150.h;

    return Image.asset(
      AppAssets.logo,
      height: logoSize,
      width: logoSize,
      fit: BoxFit.cover,
    );
  }
}
