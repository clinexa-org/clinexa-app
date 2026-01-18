// features/auth/presentation/pages/forgot_password_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_app_bar.dart';
import '../../../../app/widgets/custom_text_field.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/toast_helper.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendResetLink() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().forgotPassword(
            email: _emailController.text.trim(),
          );
    }
  }

  void _navigateToLogin() {
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.forgotPasswordSuccess) {
          // Navigate to reset password page with email
          context.push(
            Routes.resetPassword,
            extra: _emailController.text.trim(),
          );
        } else if (state.status == AuthStatus.errorForgotPassword) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'forgot_password_error'.tr(context),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: 'forgot_password_title'.tr(context),
          onBackPressed: _navigateToLogin,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  final isLoading =
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
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Iconsax.lock_1,
                            size: 40.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Instruction Text
                      Text(
                        'forgot_password_instruction'.tr(context),
                        style: AppTextStyles.interRegularw400F14.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 32.h),

                      // Email Input
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'email_address'.tr(context),
                        hintText: 'email_example'.tr(context),
                        prefixIcon: const Icon(Iconsax.sms),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _handleSendResetLink(),
                        validator: Validators.email,
                        enabled: !isLoading,
                      ),

                      SizedBox(height: 32.h),

                      // Send Reset Link Button
                      PrimaryButton(
                        text: 'send_reset_link'.tr(context),
                        onPressed: _handleSendResetLink,
                        isLoading: isLoading,
                      ),

                      SizedBox(height: 24.h),

                      // Back to Login Link
                      Center(
                        child: GestureDetector(
                          onTap: isLoading ? null : _navigateToLogin,
                          child: Text(
                            'back_to_login'.tr(context),
                            style: AppTextStyles.interRegularw400F14.copyWith(
                              color: isLoading
                                  ? AppColors.textMuted
                                  : AppColors.textSecondary,
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
