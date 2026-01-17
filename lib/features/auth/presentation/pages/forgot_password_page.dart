// features/auth/presentation/pages/forgot_password_page.dart
import 'package:flutter/material.dart';
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

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetLink() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // TODO: Implement forgot password logic
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'reset_link_sent'
                  .tr(context, params: {'email': _emailController.text}),
              style: AppTextStyles.interRegularw400F14,
            ),
            backgroundColor: AppColors.success,
          ),
        );

        // Navigate back to login
        context.go(Routes.login);
      }
    }
  }

  void _navigateToLogin() {
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),

                // Instruction Text
                Text(
                  'forgot_password_instruction'.tr(context),
                  style: AppTextStyles.interRegularw400F14.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
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
                  enabled: !_isLoading,
                ),

                SizedBox(height: 32.h),

                // Send Reset Link Button
                PrimaryButton(
                  text: 'send_reset_link'.tr(context),
                  onPressed: _handleSendResetLink,
                  isLoading: _isLoading,
                ),

                SizedBox(height: 24.h),

                // Back to Login Link
                Center(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _navigateToLogin,
                    child: Text(
                      'back_to_login'.tr(context),
                      style: AppTextStyles.interRegularw400F14.copyWith(
                        color: _isLoading
                            ? AppColors.textMuted
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
