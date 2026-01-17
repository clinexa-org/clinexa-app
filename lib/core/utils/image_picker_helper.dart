// core/utils/image_picker_helper.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'toast_helper.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Pick image from camera
  static Future<File?> pickImageFromCamera(BuildContext context) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 500,
        maxHeight: 500,
      );

      if (photo != null) {
        return File(photo.path);
      }
      return null;
    } catch (e) {
      if (!context.mounted) return null;
      ToastHelper.showError(
        context: context,
        message: 'Failed to take photo',
      );
      return null;
    }
  }

  /// Pick image from gallery
  static Future<File?> pickImageFromGallery(BuildContext context) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 500,
        maxHeight: 500,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      if (!context.mounted) return null;
      ToastHelper.showError(
        context: context,
        message: 'Failed to pick image',
      );
      return null;
    }
  }

  /// Show dialog to choose image source and return selected file
  static Future<File?> showImageSourceDialog(BuildContext context) async {
    // First show dialog to get source choice
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Image Source',
                  style: AppTextStyles.interSemiBoldw600F18.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.white),
                  title: Text(
                    'Camera',
                    style: AppTextStyles.interRegularw400F16.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onTap: () =>
                      Navigator.pop(bottomSheetContext, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.white),
                  title: Text(
                    'Gallery',
                    style: AppTextStyles.interRegularw400F16.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onTap: () =>
                      Navigator.pop(bottomSheetContext, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );

    // If no source selected, return null
    if (source == null) return null;

    // Now pick image based on selected source
    if (source == ImageSource.camera) {
      return await pickImageFromCamera(context);
    } else {
      return await pickImageFromGallery(context);
    }
  }
}
