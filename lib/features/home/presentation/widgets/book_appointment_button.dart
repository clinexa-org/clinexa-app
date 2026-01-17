import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';

import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/toast_helper.dart';
import '../../../../core/localization/app_localizations.dart';

class BookAppointmentButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const BookAppointmentButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: 'book_new_appointment'.tr(context),
      icon: Iconsax.add,
      onPressed: onPressed ??
          () {
            ToastHelper.showError(
              context: context,
              message: 'booking_failed'.tr(context),
            );
          },
    );
  }
}
