// app/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Custom text field used throughout the app
/// Provides consistent styling and behavior
/// Set isPassword=true for automatic visibility toggle
class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword; // NEW: Automatically adds visibility toggle
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;

  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false, // NEW: Default false
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword; // Initialize based on isPassword
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label (if provided)
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTextStyles.interRegularw400F14.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
        ],

        // Text Field
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          textCapitalization: widget.textCapitalization,
          style: AppTextStyles.interRegularw400F14.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlignVertical: widget.maxLines != null && widget.maxLines! > 1
              ? TextAlignVertical.top
              : TextAlignVertical.center,
          decoration: InputDecoration(
            filled: true,
            fillColor:
                widget.enabled ? AppColors.surface : AppColors.surfaceSubtle,
            hintText: widget.hintText,
            hintStyle: AppTextStyles.interRegularw400F14.copyWith(
              color: AppColors.textMuted,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Container(
                    padding: widget.maxLines != null && widget.maxLines! > 1
                        ? EdgeInsets.only(
                            top: 16.h) // Match contentPadding vertical
                        : null,
                    child: IconTheme(
                      data: IconThemeData(
                        color: AppColors.textMuted,
                        size: 20.sp,
                      ),
                      child: widget.prefixIcon!,
                    ),
                  )
                : null,
            alignLabelWithHint: widget.maxLines != null && widget.maxLines! > 1,
            suffixIcon: _buildSuffixIcon(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
            counterText: '', // Hide character counter
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    // If it's a password field, add visibility toggle
    if (widget.isPassword) {
      return IconTheme(
        data: IconThemeData(
          color: AppColors.textMuted,
          size: 20.sp,
        ),
        child: IconButton(
          icon: Icon(
            _obscureText ? Iconsax.eye : Iconsax.eye_slash,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      );
    }

    // Otherwise, use custom suffixIcon if provided
    if (widget.suffixIcon != null) {
      return IconTheme(
        data: IconThemeData(
          color: AppColors.textMuted,
          size: 20.sp,
        ),
        child: widget.suffixIcon!,
      );
    }

    return null;
  }
}
