// features/prescriptions/presentation/pages/prescription_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../widgets/medicine_item.dart';

class PrescriptionDetailsPage extends StatelessWidget {
  final String prescriptionId;
  final String date;
  final String doctorName;
  final List<Map<String, dynamic>> medicines;
  final String notes;

  const PrescriptionDetailsPage({
    super.key,
    required this.prescriptionId,
    required this.date,
    required this.doctorName,
    required this.medicines,
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'prescription_details_title'.tr(context),
        showBackButton: true,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Prescription Info Card
                  _buildInfoCard(
                    title: 'label_prescription_info'.tr(context),
                    icon: Iconsax.document_text,
                    children: [
                      _InfoItem(
                          label: 'label_prescription_id'.tr(context),
                          value: '#$prescriptionId',
                          isAccent: true),
                      _InfoItem(
                          label: 'label_date'.tr(context),
                          value: date,
                          icon: Iconsax.calendar),
                      _InfoItem(
                          label: 'label_doctor'.tr(context),
                          value: doctorName,
                          icon: Iconsax.user),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  // Medicines Section
                  _buildMedicinesSection(context),

                  SizedBox(height: 24.h),

                  // Doctor's Notes Section
                  if (notes.isNotEmpty) ...[
                    _buildNotesSection(context),
                    SizedBox(height: 32.h),
                  ],
                ],
              ),
            ),
          ),

          // Fixed Bottom Action Buttons
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(
                  color: AppColors.border.withOpacity(0.5),
                ),
              ),
            ),
            child: SafeArea(top: false, child: _buildActionButtons(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: AppColors.accent, size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: AppTextStyles.interSemiBoldw600F16.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMedicinesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent,
                    AppColors.accentLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Iconsax.health, color: Colors.white, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Text(
              'label_medicines'.tr(context),
              style: AppTextStyles.interSemiBoldw600F16.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${medicines.length}',
                style: AppTextStyles.interSemiBoldw600F12.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...medicines.map((medicine) => MedicineItem(
              name: medicine['name'] as String,
              dosage: medicine['dosage'] as String,
              type: medicine['type'] as String? ?? 'Tablet',
            )),
      ],
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlue.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.note_2, color: AppColors.accent, size: 18.sp),
              SizedBox(width: 10.w),
              Text(
                'label_doctors_notes'.tr(context),
                style: AppTextStyles.interSemiBoldw600F14.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            notes,
            style: AppTextStyles.interMediumw500F14.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Share Button
        Expanded(
          child: Container(
            height: 52.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.accent,
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // TODO: Implement share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('msg_share_soon'.tr(context)),
                      backgroundColor: AppColors.surface,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.share, color: AppColors.accent, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'btn_share'.tr(context),
                      style: AppTextStyles.interSemiBoldw600F14.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Download PDF Button
        Expanded(
          flex: 2,
          child: Container(
            height: 52.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primaryDark,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // TODO: Implement PDF download functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('msg_download_soon'.tr(context)),
                      backgroundColor: AppColors.surface,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.document_download,
                        color: Colors.white, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      'btn_download_pdf'.tr(context),
                      style: AppTextStyles.interSemiBoldw600F14.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool isAccent;

  const _InfoItem({
    required this.label,
    required this.value,
    this.icon,
    this.isAccent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              label,
              style: AppTextStyles.interMediumw500F14.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          if (icon != null) ...[
            Icon(icon,
                size: 16.sp,
                color: isAccent ? AppColors.accent : AppColors.textSecondary),
            SizedBox(width: 6.w),
          ],
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.interMediumw500F14.copyWith(
                color: isAccent ? AppColors.accent : AppColors.textPrimary,
                fontWeight: isAccent ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
