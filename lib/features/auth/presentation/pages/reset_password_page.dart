// features/auth/presentation/pages/reset_password_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/app_dialog.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../app/widgets/custom_text_field.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/toast_helper.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().resetPassword(
            email: widget.email,
            otp: _otpController.text.trim(),
            newPassword: _passwordController.text,
          );
    }
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _resendOTP() {
    context.read<AuthCubit>().forgotPassword(email: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.resetPasswordSuccess) {
          // Show success dialog and navigate to login
          AppDialog.success(
            context: context,
            title: 'reset_password_success_title'.tr(context),
            message: 'reset_password_success_msg'.tr(context),
            confirmText: 'go_to_login'.tr(context),
            onConfirm: () {
              context.go(Routes.login);
            },
          );
        } else if (state.status == AuthStatus.errorResetPassword) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'reset_password_error'.tr(context),
          );
        } else if (state.status == AuthStatus.forgotPasswordSuccess) {
          ToastHelper.showSuccess(
            context: context,
            message: 'otp_resent'.tr(context),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: 'reset_password_title'.tr(context),
          onBackPressed: () => context.pop(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoading =
                      state.status == AuthStatus.loadingResetPassword ||
                          state.status == AuthStatus.loadingForgotPassword;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.h),

                      // Icon
                      Center(
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Iconsax.shield_tick,
                            size: 40.sp,
                            color: AppColors.success,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Instruction Text
                      Text(
                        'reset_password_instruction'.tr(context),
                        style: AppTextStyles.interRegularw400F14.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 8.h),

                      // Email display
                      Center(
                        child: Text(
                          widget.email,
                          style: AppTextStyles.interSemiBoldw600F14.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // OTP Input
                      CustomTextField(
                        controller: _otpController,
                        labelText: 'otp_code'.tr(context),
                        hintText: 'enter_6_digit_otp'.tr(context),
                        prefixIcon: const Icon(Iconsax.password_check),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'otp_required'.tr(context);
                          }
                          if (value.length < 6) {
                            return 'otp_must_be_6_digits'.tr(context);
                          }
                          return null;
                        },
                        enabled: !isLoading,
                      ),

                      SizedBox(height: 16.h),

                      // New Password Input
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'new_password'.tr(context),
                        hintText: 'enter_new_password'.tr(context),
                        prefixIcon: const Icon(Iconsax.lock),
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        validator: Validators.password,
                        enabled: !isLoading,
                      ),

                      SizedBox(height: 16.h),

                      // Confirm Password Input
                      CustomTextField(
                        controller: _confirmPasswordController,
                        labelText: 'confirm_password'.tr(context),
                        hintText: 'confirm_new_password'.tr(context),
                        prefixIcon: const Icon(Iconsax.lock_1),
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleResetPassword(),
                        validator: _validateConfirmPassword,
                        enabled: !isLoading,
                      ),

                      SizedBox(height: 32.h),

                      // Reset Password Button
                      PrimaryButton(
                        text: 'reset_password_btn'.tr(context),
                        onPressed: _handleResetPassword,
                        isLoading: isLoading,
                      ),

                      SizedBox(height: 24.h),

                      // Resend OTP Link
                      Center(
                        child: GestureDetector(
                          onTap: isLoading ? null : _resendOTP,
                          child: Text(
                            'resend_otp'.tr(context),
                            style: AppTextStyles.interMediumw500F14.copyWith(
                              color: isLoading
                                  ? AppColors.textMuted
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
