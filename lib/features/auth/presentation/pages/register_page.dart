// features/auth/presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_text_field.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/validators.dart';
import '../widgets/auth_logo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement register logic
      context.go(Routes.home);
    }
  }

  void _navigateToLogin() {
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 24.h),

                // Logo
                const AuthLogo(),

                // Title
                Text(
                  'Join Clinexa',
                  style: AppTextStyles.interSemiBoldw600F24.copyWith(
                    color: AppColors.accentLight,
                  ),
                ),

                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  'Create your patient account',
                  style: AppTextStyles.interRegularw400F14.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: 40.h),

                // Full Name Input
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Full Name',
                  hintText: 'e.g. Ahmed Hassan',
                  prefixIcon: const Icon(Icons.person_outline),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: Validators.name,
                ),

                SizedBox(height: 20.h),

                // Email Address Input
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'e.g. name@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                ),

                SizedBox(height: 20.h),

                // Password Input
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Create a password',
                  isPassword: true, // Built-in visibility toggle
                  prefixIcon: const Icon(Icons.lock_outline),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleRegister(),
                  validator: Validators.passwordBuilder(strong: true),
                ),

                SizedBox(height: 32.h),

                // Create Account Button
                PrimaryButton(
                  text: 'Create Account',
                  onPressed: _handleRegister,
                ),

                SizedBox(height: 24.h),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppTextStyles.interRegularw400F14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToLogin,
                      child: Text(
                        'Login',
                        style: AppTextStyles.interSemiBoldw600F14.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
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
