import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Use context.select to listen only to specific changes, or context.watch() for all state changes.
    // This avoids the nesting of BlocBuilder.
    final state = context.watch<AuthCubit>().state;
    final name = state.userName?.split(' ').first ?? 'Guest';
    final id =
        state.userId != null ? '#${state.userId!.substring(0, 4)}' : 'N/A';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning, $name',
              style:
                  AppTextStyles.interBoldw700F20.copyWith(color: Colors.white),
            ),
            SizedBox(height: 4.h),
            Text(
              'Patient ID: $id',
              style: AppTextStyles.interRegularw400F14.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
            'https://i.pravatar.cc/150?u=a042581f4e29026024d',
          ),
        ),
      ],
    );
  }
}
