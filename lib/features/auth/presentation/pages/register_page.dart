// features/auth/presentation/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/custom_text_field.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            role: 'patient',
          );
    }
  }

  void _navigateToLogin() {
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Show toast only on active registration
        if (state.status == AuthStatus.authenticatedFromRegister) {
          ToastHelper.showSuccess(
            context: context,
            message: 'Account created successfully! Welcome to Clinexa.',
          );
          context.go(Routes.home);
        } else if (state.status == AuthStatus.errorRegister) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'Registration failed',
          );
        }
      },
      builder: (context, state) {
        _isLoading = state.status == AuthStatus.loadingRegister;

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
                      prefixIcon: const Icon(Iconsax.user),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: Validators.name,
                      enabled: !_isLoading,
                    ),

                    SizedBox(height: 20.h),

                    // Email Address Input
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      hintText: 'e.g. name@email.com',
                      prefixIcon: const Icon(Iconsax.sms),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                      enabled: !_isLoading,
                    ),

                    SizedBox(height: 20.h),

                    // Password Input
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Create a password',
                      isPassword: true, // Built-in visibility toggle
                      prefixIcon: const Icon(Iconsax.lock),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _handleRegister(),
                      validator: Validators.passwordBuilder(strong: true),
                      enabled: !_isLoading,
                    ),

                    SizedBox(height: 32.h),

                    // Create Account Button
                    PrimaryButton(
                      text: 'Create Account',
                      onPressed: _handleRegister,
                      isLoading: _isLoading,
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
                          onTap: _isLoading ? null : _navigateToLogin,
                          child: Text(
                            'Login',
                            style: AppTextStyles.interSemiBoldw600F14.copyWith(
                              color: _isLoading
                                  ? AppColors.textMuted
                                  : AppColors.primary,
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
      },
    );
  }
}
