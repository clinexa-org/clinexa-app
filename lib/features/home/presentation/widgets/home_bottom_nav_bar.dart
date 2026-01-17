import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iconsax/iconsax.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .09.sh,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.border.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        showUnselectedLabels: true,
        selectedLabelStyle: AppTextStyles.interSemiBoldw600F12,
        unselectedLabelStyle: AppTextStyles.interMediumw500F12,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.home),
            label: 'home'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.calendar),
            label: 'bookings'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.receipt_item),
            label: 'meds'.tr(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Iconsax.user),
            label: 'profile'.tr(context),
          ),
        ],
      ),
    );
  }
}
