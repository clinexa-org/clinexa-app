// app/theme/app_text_styles.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Font weight constants for easy reuse
class AppFontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w900;
}

/// Comprehensive text styles using Google Fonts Inter
/// All sizes use flutter_screenutil (.sp) for responsive design
class AppTextStyles {
  // Base font style
  static TextStyle get _baseFont => GoogleFonts.inter();

  // ============== Font Size 10 ==============
  static TextStyle interLightw300F10 = _baseFont.copyWith(
    fontWeight: AppFontWeight.light,
    fontSize: 10.sp,
  );
  static TextStyle interRegularw400F10 = _baseFont.copyWith(
    fontWeight: AppFontWeight.regular,
    fontSize: 10.sp,
  );
  static TextStyle interMediumw500F10 = _baseFont.copyWith(
    fontWeight: AppFontWeight.medium,
    fontSize: 10.sp,
  );
  static TextStyle interSemiBoldw600F10 = _baseFont.copyWith(
    fontWeight: AppFontWeight.semiBold,
    fontSize: 10.sp,
  );
  static TextStyle interBoldw700F10 = _baseFont.copyWith(
    fontWeight: AppFontWeight.bold,
    fontSize: 10.sp,
  );
  static TextStyle interExtraBoldw900F10 = _baseFont.copyWith(
    fontWeight: AppFontWeight.extraBold,
    fontSize: 10.sp,
  );

  // ============== Font Size 12 ==============
  static TextStyle interLightw300F12 = _baseFont.copyWith(
    fontWeight: AppFontWeight.light,
    fontSize: 12.sp,
  );
  static TextStyle interRegularw400F12 = _baseFont.copyWith(
    fontWeight: AppFontWeight.regular,
    fontSize: 12.sp,
  );
  static TextStyle interMediumw500F12 = _baseFont.copyWith(
    fontWeight: AppFontWeight.medium,
    fontSize: 12.sp,
  );
  static TextStyle interSemiBoldw600F12 = _baseFont.copyWith(
    fontWeight: AppFontWeight.semiBold,
    fontSize: 12.sp,
  );
  static TextStyle interBoldw700F12 = _baseFont.copyWith(
    fontWeight: AppFontWeight.bold,
    fontSize: 12.sp,
  );
  static TextStyle interExtraBoldw900F12 = _baseFont.copyWith(
    fontWeight: AppFontWeight.extraBold,
    fontSize: 12.sp,
  );

  // ============== Font Size 14 ==============
  static TextStyle interLightw300F14 = _baseFont.copyWith(
    fontWeight: AppFontWeight.light,
    fontSize: 14.sp,
  );
  static TextStyle interRegularw400F14 = _baseFont.copyWith(
    fontWeight: AppFontWeight.regular,
    fontSize: 14.sp,
  );
  static TextStyle interMediumw500F14 = _baseFont.copyWith(
    fontWeight: AppFontWeight.medium,
    fontSize: 14.sp,
  );
  static TextStyle interSemiBoldw600F14 = _baseFont.copyWith(
    fontWeight: AppFontWeight.semiBold,
    fontSize: 14.sp,
  );
  static TextStyle interBoldw700F14 = _baseFont.copyWith(
    fontWeight: AppFontWeight.bold,
    fontSize: 14.sp,
  );
  static TextStyle interExtraBoldw900F14 = _baseFont.copyWith(
    fontWeight: AppFontWeight.extraBold,
    fontSize: 14.sp,
  );

  // ============== Font Size 16 ==============
  static TextStyle interLightw300F16 = _baseFont.copyWith(
    fontWeight: AppFontWeight.light,
    fontSize: 16.sp,
  );
  static TextStyle interRegularw400F16 = _baseFont.copyWith(
    fontWeight: AppFontWeight.regular,
    fontSize: 16.sp,
  );
  static TextStyle interMediumw500F16 = _baseFont.copyWith(
    fontWeight: AppFontWeight.medium,
    fontSize: 16.sp,
  );
  static TextStyle interSemiBoldw600F16 = _baseFont.copyWith(
    fontWeight: AppFontWeight.semiBold,
    fontSize: 16.sp,
  );
  static TextStyle interBoldw700F16 = _baseFont.copyWith(
    fontWeight: AppFontWeight.bold,
    fontSize: 16.sp,
  );
  static TextStyle interExtraBoldw900F16 = _baseFont.copyWith(
    fontWeight: AppFontWeight.extraBold,
    fontSize: 16.sp,
  );

  // ============== Font Size 18 ==============
  static TextStyle interLightw300F18 = _baseFont.copyWith(
    fontWeight: AppFontWeight.light,
    fontSize: 18.sp,
  );
  static TextStyle interRegularw400F18 = _baseFont.copyWith(
    fontWeight: AppFontWeight.regular,
    fontSize: 18.sp,
  );
  static TextStyle interMediumw500F18 = _baseFont.copyWith(
    fontWeight: AppFontWeight.medium,
    fontSize: 18.sp,
  );
  static TextStyle interSemiBoldw600F18 = _baseFont.copyWith(
    fontWeight: AppFontWeight.semiBold,
    fontSize: 18.sp,
  );
  static TextStyle interBoldw700F18 = _baseFont.copyWith(
    fontWeight: AppFontWeight.bold,
    fontSize: 18.sp,
  );
  static TextStyle interExtraBoldw900F18 = _baseFont.copyWith(
    fontWeight: AppFontWeight.extraBold,
    fontSize: 18.sp,
  );

  // ============== Font Size 20 ==============
  static TextStyle interLightw300F20 = _baseFont.copyWith(
    fontWeight: AppFontWeight.light,
    fontSize: 20.sp,
  );
  static TextStyle interRegularw400F20 = _baseFont.copyWith(
    fontWeight: AppFontWeight.regular,
    fontSize: 20.sp,
  );
  static TextStyle interMediumw500F20 = _baseFont.copyWith(
    fontWeight: AppFontWeight.medium,
    fontSize: 20.sp,
  );
  static TextStyle interSemiBoldw600F20 = _baseFont.copyWith(
    fontWeight: AppFontWeight.semiBold,
    fontSize: 20.sp,
  );
  static TextStyle interBoldw700F20 = _baseFont.copyWith(
    fontWeight: AppFontWeight.bold,
    fontSize: 20.sp,
  );
  static TextStyle interExtraBoldw900F20 = _baseFont.copyWith(
    fontWeight: AppFontWeight.extraBold,
    fontSize: 20.sp,
  );

  // ============== Font Size 24 ==============
  static TextStyle interLightw300F24 = _baseFont.copyWith(
    fontWeight: AppFontWeight.light,
    fontSize: 24.sp,
  );
  static TextStyle interRegularw400F24 = _baseFont.copyWith(
    fontWeight: AppFontWeight.regular,
    fontSize: 24.sp,
  );
  static TextStyle interMediumw500F24 = _baseFont.copyWith(
    fontWeight: AppFontWeight.medium,
    fontSize: 24.sp,
  );
  static TextStyle interSemiBoldw600F24 = _baseFont.copyWith(
    fontWeight: AppFontWeight.semiBold,
    fontSize: 24.sp,
  );
  static TextStyle interBoldw700F24 = _baseFont.copyWith(
    fontWeight: AppFontWeight.bold,
    fontSize: 24.sp,
  );
  static TextStyle interExtraBoldw900F24 = _baseFont.copyWith(
    fontWeight: AppFontWeight.extraBold,
    fontSize: 24.sp,
  );

  // ============== Font Size 28 ==============
  static TextStyle interLightw300F28 = _baseFont.copyWith(
    fontWeight: AppFontWeight.light,
    fontSize: 28.sp,
  );
  static TextStyle interRegularw400F28 = _baseFont.copyWith(
    fontWeight: AppFontWeight.regular,
    fontSize: 28.sp,
  );
  static TextStyle interMediumw500F28 = _baseFont.copyWith(
    fontWeight: AppFontWeight.medium,
    fontSize: 28.sp,
  );
  static TextStyle interSemiBoldw600F28 = _baseFont.copyWith(
    fontWeight: AppFontWeight.semiBold,
    fontSize: 28.sp,
  );
  static TextStyle interBoldw700F28 = _baseFont.copyWith(
    fontWeight: AppFontWeight.bold,
    fontSize: 28.sp,
  );
  static TextStyle interExtraBoldw900F28 = _baseFont.copyWith(
    fontWeight: AppFontWeight.extraBold,
    fontSize: 28.sp,
  );

  // ============== Font Size 32 ==============
  static TextStyle interLightw300F32 = _baseFont.copyWith(
    fontWeight: AppFontWeight.light,
    fontSize: 32.sp,
  );
  static TextStyle interRegularw400F32 = _baseFont.copyWith(
    fontWeight: AppFontWeight.regular,
    fontSize: 32.sp,
  );
  static TextStyle interMediumw500F32 = _baseFont.copyWith(
    fontWeight: AppFontWeight.medium,
    fontSize: 32.sp,
  );
  static TextStyle interSemiBoldw600F32 = _baseFont.copyWith(
    fontWeight: AppFontWeight.semiBold,
    fontSize: 32.sp,
  );
  static TextStyle interBoldw700F32 = _baseFont.copyWith(
    fontWeight: AppFontWeight.bold,
    fontSize: 32.sp,
  );
  static TextStyle interExtraBoldw900F32 = _baseFont.copyWith(
    fontWeight: AppFontWeight.extraBold,
    fontSize: 32.sp,
  );

  // ============== Font Size 40 ==============
  static TextStyle interLightw300F40 = _baseFont.copyWith(
    fontWeight: AppFontWeight.light,
    fontSize: 40.sp,
  );
  static TextStyle interRegularw400F40 = _baseFont.copyWith(
    fontWeight: AppFontWeight.regular,
    fontSize: 40.sp,
  );
  static TextStyle interMediumw500F40 = _baseFont.copyWith(
    fontWeight: AppFontWeight.medium,
    fontSize: 40.sp,
  );
  static TextStyle interSemiBoldw600F40 = _baseFont.copyWith(
    fontWeight: AppFontWeight.semiBold,
    fontSize: 40.sp,
  );
  static TextStyle interBoldw700F40 = _baseFont.copyWith(
    fontWeight: AppFontWeight.bold,
    fontSize: 40.sp,
  );
  static TextStyle interExtraBoldw900F40 = _baseFont.copyWith(
    fontWeight: AppFontWeight.extraBold,
    fontSize: 40.sp,
  );

  // ============== Legacy/Semantic Aliases ==============
  // For backward compatibility with existing code
  static TextStyle get display => interBoldw700F32;
  static TextStyle get titleLarge => interSemiBoldw600F24;
  static TextStyle get bodyLarge => interRegularw400F16;
  static TextStyle get bodyMedium => interRegularw400F14;
  static TextStyle get button => interMediumw500F16;

  // Private constructor to prevent instantiation
  AppTextStyles._();
}
