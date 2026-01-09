// features/auth/presentation/pages/forgot_password_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_text_field.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/validators.dart';

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
              'Reset link sent to ${_emailController.text}',
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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
          onPressed: _navigateToLogin,
        ),
        title: Text(
          'Forgot Password',
          style: AppTextStyles.interSemiBoldw600F18.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
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
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  style: AppTextStyles.interRegularw400F14.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 32.h),

                // Email Input
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'name@example.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleSendResetLink(),
                  validator: Validators.email,
                  enabled: !_isLoading,
                ),

                SizedBox(height: 32.h),

                // Send Reset Link Button
                PrimaryButton(
                  text: 'Send reset link',
                  onPressed: _handleSendResetLink,
                  isLoading: _isLoading,
                ),

                SizedBox(height: 24.h),

                // Back to Login Link
                Center(
                  child: GestureDetector(
                    onTap: _isLoading ? null : _navigateToLogin,
                    child: Text(
                      'Back to login',
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
