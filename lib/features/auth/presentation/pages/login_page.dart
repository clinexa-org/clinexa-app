// features/auth/presentation/pages/login_page.dart
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement login logic
      context.go(Routes.home);
    }
  }

  void _navigateToRegister() {
    context.go(Routes.register);
  }

  void _navigateToForgotPassword() {
    context.go(Routes.forgotPassword);
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
                SizedBox(height: 60.h),

                // Logo
                const AuthLogo(),

                SizedBox(height: 24.h),

                // Title
                Text(
                  'Clinexa',
                  style: AppTextStyles.interSemiBoldw600F24.copyWith(
                    color: AppColors.accentLight,
                  ),
                ),

                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  'Welcome back, please login',
                  style: AppTextStyles.interRegularw400F14.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                SizedBox(height: 40.h),

                // Email Input
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'patient@example.com',
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
                  hintText: 'Enter your password',
                  isPassword: true, // Built-in visibility toggle
                  prefixIcon: const Icon(Icons.lock_outline),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleLogin(),
                  validator: Validators.password,
                ),

                SizedBox(height: 12.h),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _navigateToForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.interRegularw400F14.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Login Button
                PrimaryButton(
                  text: 'Login',
                  onPressed: _handleLogin,
                ),

                SizedBox(height: 24.h),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.interRegularw400F14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToRegister,
                      child: Text(
                        'Register',
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
