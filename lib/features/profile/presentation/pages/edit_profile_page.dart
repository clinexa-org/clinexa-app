// features/profile/presentation/pages/edit_profile_page.dart
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clinexa_mobile/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../app/widgets/custom_text_field.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/image_picker_helper.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../cubit/patient_cubit.dart';
import '../cubit/patient_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedGender = 'male';
  File? _selectedImage;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    // Load user name from auth cubit state
    final authState = context.read<AuthCubit>().state;
    if (authState.userName != null) {
      _nameController.text = authState.userName!;
    }

    // Load patient data
    final patient = context.read<PatientCubit>().state.patient;
    if (patient != null) {
      _ageController.text = patient.age?.toString() ?? '';
      _selectedGender = patient.gender ?? 'male';
      _phoneController.text = patient.phone ?? '';
      _addressController.text = patient.address ?? '';
      _existingImageUrl = patient.avatar;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!mounted) return;
    context.read<PatientCubit>().updateProfile(
          name: _nameController.text.trim(),
          age: int.parse(_ageController.text),
          gender: _selectedGender,
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          avatar: _selectedImage,
        );
  }

  Future<void> _pickImage() async {
    final image = await ImagePickerHelper.showImageSourceDialog(context);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientCubit, PatientState>(
      listener: (context, state) {
        if (state.status == PatientStatus.success) {
          // Update AuthCubit state to reflect changes immediately
          final patient = state.patient;
          if (patient != null && patient.user != null) {
            context.read<AuthCubit>().updateUser(
                  name: patient.user!.name,
                  avatar: patient.user!.avatar,
                );
          }

          ToastHelper.showSuccess(
            context: context,
            message: 'profile_updated_success'.tr(context),
          );
          context.pop();
        }

        if (state.status == PatientStatus.error) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'profile_update_failed'.tr(context),
          );
          PatientCubit.get(context).clearError();
        }
      },
      builder: (context, state) {
        final isLoading = state.status == PatientStatus.loading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            centerTitle: true,
            title: 'edit_profile'.tr(context),
            onBackPressed: () => context.pop(),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 28.h),

                  // Profile Avatar
                  GestureDetector(
                    onTap: () => _pickImage(),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundColor: AppColors.surface,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!)
                              : (_existingImageUrl != null &&
                                      _existingImageUrl!.isNotEmpty)
                                  ? CachedNetworkImageProvider(
                                      _existingImageUrl!) as ImageProvider
                                  : null,
                          child: (_selectedImage == null &&
                                  (_existingImageUrl == null ||
                                      _existingImageUrl!.isEmpty))
                              ? Icon(
                                  Iconsax.user,
                                  size: 50.sp,
                                  color: AppColors.textSecondary,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.background,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Iconsax.camera,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Full Name Field
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'full_name'.tr(context),
                    hintText: 'name_placeholder'.tr(context),
                    prefixIcon: const Icon(Iconsax.user),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'name_required'.tr(context);
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),

                  SizedBox(height: 20.h),

                  // Age and Gender Row
                  Row(
                    children: [
                      // Age Field
                      Expanded(
                        child: CustomTextField(
                          controller: _ageController,
                          labelText: 'age'.tr(context),
                          hintText: 'age_hint'.tr(context),
                          prefixIcon: const Icon(Iconsax.calendar),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'required'.tr(context);
                            }
                            final age = int.tryParse(value);
                            if (age == null || age < 1 || age > 120) {
                              return 'invalid'.tr(context);
                            }
                            return null;
                          },
                          enabled: !isLoading,
                        ),
                      ),

                      SizedBox(width: 16.w),

                      // Gender Field
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'gender'.tr(context),
                              style: AppTextStyles.interRegularw400F14.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Expanded(
                                  child: _GenderButton(
                                    label: 'male'.tr(context),
                                    isSelected: _selectedGender == 'male',
                                    onTap: isLoading
                                        ? null
                                        : () {
                                            setState(() {
                                              _selectedGender = 'male';
                                            });
                                          },
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: _GenderButton(
                                    label: 'female'.tr(context),
                                    isSelected: _selectedGender == 'female',
                                    onTap: isLoading
                                        ? null
                                        : () {
                                            setState(() {
                                              _selectedGender = 'female';
                                            });
                                          },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  // Phone Field
                  CustomTextField(
                    controller: _phoneController,
                    labelText: 'phone_number'.tr(context),
                    hintText: '+20 123 456 7890',
                    prefixIcon: const Icon(Iconsax.call),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: Validators.phoneBuilder(egyptOnly: true),
                    enabled: !isLoading,
                  ),

                  SizedBox(height: 20.h),

                  // Address Field
                  CustomTextField(
                    controller: _addressController,
                    labelText: 'address'.tr(context),
                    hintText: 'address_hint'.tr(context),
                    maxLines: 3,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleSave(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'address_required'.tr(context);
                      }
                      return null;
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    enabled: !isLoading,
                  ),

                  SizedBox(height: 32.h),

                  // Save Button
                  PrimaryButton(
                    text: 'save_changes'.tr(context),
                    onPressed: _handleSave,
                    isLoading: isLoading, // Handled by overlay
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _GenderButton({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.interRegularw400F14.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
