import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/localization/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Use context.select to listen only to specific changes, or context.watch() for all state changes.
    // This avoids the nesting of BlocBuilder.
    final state = context.watch<AuthCubit>().state;
    final name = state.userName?.split(' ').first ?? 'guest'.tr(context);
    final id = state.userId != null
        ? '#${state.userId!.substring(0, 4)}'
        : 'not_available'.tr(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'good_morning'.tr(context, params: {'name': name}),
              style:
                  AppTextStyles.interBoldw700F20.copyWith(color: Colors.white),
            ),
            SizedBox(height: 4.h),
            Text(
              '${'patient_id'.tr(context)}: $id',
              style: AppTextStyles.interRegularw400F14.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 20.r,
          backgroundColor: AppColors.surfaceElevated,
          backgroundImage: (state.avatar != null && state.avatar!.isNotEmpty)
              ? CachedNetworkImageProvider(state.avatar!) as ImageProvider
              : null,
          child: (state.avatar == null || state.avatar!.isEmpty)
              ? Icon(
                  Iconsax.user,
                  size: 20.sp,
                  color: AppColors.textSecondary,
                )
              : null,
        ),
      ],
    );
  }
}
