// features/auth/presentation/pages/login_page.dart
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
import '../../../../core/localization/app_localizations.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Show toast only on active login
        if (state.status == AuthStatus.authenticatedFromLogin) {
          ToastHelper.showSuccess(
            context: context,
            message: 'welcome_back'.tr(context),
          );
          context.go(Routes.home);
        }
        // Silent navigation on cached auth
        else if (state.status == AuthStatus.authenticatedFromCache) {
          context.go(Routes.home);
        } else if (state.status == AuthStatus.errorLogin) {
          ToastHelper.showError(
            context: context,
            message: state.errorMessage ?? 'login_failed'.tr(context),
          );
          context.read<AuthCubit>().clearToast();
        }
      },
      builder: (context, state) {
        _isLoading = state.status == AuthStatus.loadingLogin;

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
                      'app_name'.tr(context),
                      style: AppTextStyles.interSemiBoldw600F24.copyWith(
                        color: AppColors.accentLight,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Subtitle
                    Text(
                      'welcome_back_subtitle'.tr(context),
                      style: AppTextStyles.interRegularw400F14.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Email Input
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'email_address'.tr(context),
                      hintText: 'email_hint'.tr(context),
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
                      labelText: 'password'.tr(context),
                      hintText: 'password_hint'.tr(context),
                      isPassword: true, // Built-in visibility toggle
                      prefixIcon: const Icon(Iconsax.lock),
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _handleLogin(),
                      validator: Validators.password,
                      enabled: !_isLoading,
                    ),

                    SizedBox(height: 12.h),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _isLoading ? null : _navigateToForgotPassword,
                        child: Text(
                          'forgot_password'.tr(context),
                          style: AppTextStyles.interRegularw400F14.copyWith(
                            color: _isLoading
                                ? AppColors.textMuted
                                : AppColors.primary,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Login Button
                    PrimaryButton(
                      text: 'login'.tr(context),
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 24.h),

                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'no_account'.tr(context),
                          style: AppTextStyles.interRegularw400F14.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: _isLoading ? null : _navigateToRegister,
                          child: Text(
                            'register'.tr(context),
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
