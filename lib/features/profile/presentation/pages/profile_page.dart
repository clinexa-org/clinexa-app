// features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/language_manager.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../core/presentation/cubit/layout_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../core/localization/app_localizations.dart';
import '../cubit/patient_cubit.dart';
import '../cubit/patient_state.dart';
import '../widgets/profile_card.dart';
import '../widgets/settings_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    // Only fetch patient data if user is a patient

    context.read<PatientCubit>().getMyProfile();
  }

  Future<void> _loadLanguage() async {
    final lang = await LanguageManager.getSavedLanguage();
    setState(() {
      _selectedLanguage = lang;
    });
  }

  void _showLanguageDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'language'.tr(context),
                style: AppTextStyles.interSemiBoldw600F18.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              ...LanguageManager.supportedLanguages.map((lang) => ListTile(
                    leading: Icon(
                      _selectedLanguage == lang.code
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: _selectedLanguage == lang.code
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      lang.nativeName,
                      style: AppTextStyles.interRegularw400F16.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      lang.name,
                      style: AppTextStyles.interRegularw400F12.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    onTap: () {
                      context.read<LayoutCubit>().changeLanguage(lang.code);
                      setState(() {
                        _selectedLanguage = lang.code;
                      });
                      Navigator.pop(context);
                      ToastHelper.showSuccess(
                        context: this.context,
                        message: 'Language changed to ${lang.name}',
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'log_out_title'.tr(context),
          style: AppTextStyles.interSemiBoldw600F18.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'log_out_confirmation'.tr(context),
          style: AppTextStyles.interRegularw400F14.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'cancel'.tr(context),
              style: AppTextStyles.interRegularw400F14.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              context.read<AuthCubit>().logout();
              context.go(Routes.login);
            },
            child: Text(
              'log_out_title'.tr(context),
              style: AppTextStyles.interSemiBoldw600F14.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'delete_account'.tr(context),
          style: AppTextStyles.interSemiBoldw600F18.copyWith(
            color: AppColors.error,
          ),
        ),
        content: Text(
          'delete_account_confirmation'.tr(context),
          style: AppTextStyles.interRegularw400F14.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'cancel'.tr(context),
              style: AppTextStyles.interRegularw400F14.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              ToastHelper.showError(
                context: context,
                message: 'delete_account_not_implemented'.tr(context),
              );
            },
            child: Text(
              'delete'.tr(context),
              style: AppTextStyles.interSemiBoldw600F14.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: BlocBuilder<PatientCubit, PatientState>(
          builder: (context, patientState) {
            final authState = context.watch<AuthCubit>().state;
            final userName = authState.userName ?? 'User';
            final userId = authState.userId ?? '---';
            final patient = patientState.patient;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: .07.sh,
                  ),
                  // Profile Card
                  ProfileCard(
                    userName: userName,
                    userId: userId,
                    phoneNumber: patient?.phone,
                    imageUrl: patient?.avatar,
                    onTap: () => context.push(Routes.editProfile),
                  ),

                  SizedBox(height: 32.h),

                  // PREFERENCES Section
                  Text(
                    'preferences_section'.tr(context),
                    style: AppTextStyles.interSemiBoldw600F12.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Language Option
                  SettingsTile(
                    icon: Iconsax.global,
                    title: 'language'.tr(context),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          LanguageManager.getLanguageByCode(_selectedLanguage)
                                  ?.nativeName ??
                              'English',
                          style: AppTextStyles.interRegularw400F14.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    onTap: _showLanguageDialog,
                  ),

                  SizedBox(height: 8.h),

                  // Notifications Toggle
                  SettingsTile(
                    icon: Iconsax.notification,
                    title: 'notifications'.tr(context),
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                        ToastHelper.showSuccess(
                          context: context,
                          message: value
                              ? 'notifications_enabled'.tr(context)
                              : 'notifications_disabled'.tr(context),
                        );
                      },
                      activeColor: AppColors.primary,
                    ),
                    onTap: () {
                      setState(() {
                        _notificationsEnabled = !_notificationsEnabled;
                      });
                    },
                  ),

                  SizedBox(height: 32.h),

                  // ACCOUNT Section
                  Text(
                    'account_section'.tr(context),
                    style: AppTextStyles.interSemiBoldw600F12.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Log Out
                  SettingsTile(
                    icon: Iconsax.logout,
                    title: 'log_out_title'.tr(context),
                    iconColor: AppColors.textPrimary,
                    onTap: _handleLogout,
                  ),

                  SizedBox(height: 8.h),

                  // Delete Account
                  SettingsTile(
                    icon: Iconsax.trash,
                    title: 'delete_account'.tr(context),
                    iconColor: AppColors.error,
                    titleColor: AppColors.error,
                    onTap: _handleDeleteAccount,
                  ),

                  SizedBox(height: 40.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
