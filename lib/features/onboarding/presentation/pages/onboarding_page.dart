// features/onboarding/presentation/pages/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/constants/app_assets.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/widgets/primary_button.dart';
import '../../../../core/storage/onboarding_storage.dart';

class OnboardingPage extends StatefulWidget {
  final OnboardingStorage onboardingStorage;

  const OnboardingPage({super.key, required this.onboardingStorage});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      iconPath: AppAssets.onboardingIcon1,
      title: 'Book appointments easily',
      description:
          'Schedule your visit with your doctor in just a few taps — no waiting on hold.',
    ),
    OnboardingData(
      iconPath: AppAssets.onboardingIcon2,
      title: 'Track your appointments',
      description:
          'Stay organized with a clear view of your upcoming visits and history with Dr. Ahmed Hassan.',
    ),
    OnboardingData(
      iconPath: AppAssets.onboardingIcon3,
      title: 'Your prescriptions on your phone',
      description:
          'View your medications, download PDF copies, and easily share them with pharmacies.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _skipToLogin() async {
    await widget.onboardingStorage.markOnboardingAsSeen();
    if (mounted) {
      context.go(Routes.login);
    }
  }

  Future<void> _nextOrGetStarted() async {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await widget.onboardingStorage.markOnboardingAsSeen();
      if (mounted) {
        context.go(Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: _skipToLogin,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.interRegularw400F14
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
            // Top Bar
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         'Onboarding...',
            //         style: TextStyle(
            //           fontSize: 14.sp,
            //           color: const Color(0xFF757575),
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //       GestureDetector(
            //         onTap: _skipToLogin,
            //         child: Text(
            //           'Skip',
            //           style: TextStyle(
            //             fontSize: 14.sp,
            //             color: const Color(0xFF757575),
            //             fontWeight: FontWeight.w400,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingSlide(data: _pages[index]);
                },
              ),
            ),

            // Dots Indicator
            Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _DotIndicator(isActive: index == _currentPage),
                ),
              ),
            ),

            // Next/Get Started Button
            Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 32.h),
              child: PrimaryButton(
                text:
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                onPressed: _nextOrGetStarted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final OnboardingData data;

  const _OnboardingSlide({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SVG Icon
          SvgPicture.asset(
            data.iconPath,
            width: 200.w,
            height: 200.h,
            color: AppColors.primary,
          ),

          SizedBox(height: 40.h),

          // Title
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.interBoldw700F20.copyWith(
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 16.h),

          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: AppTextStyles.interRegularw400F14.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 24.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(4.r),
      ),
    );
  }
}

class OnboardingData {
  final String iconPath;
  final String title;
  final String description;

  OnboardingData({
    required this.iconPath,
    required this.title,
    required this.description,
  });
}
