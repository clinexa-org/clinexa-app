import 'package:flutter/material.dart';

import 'package:iconsax/iconsax.dart';

import '../../../../app/widgets/primary_button.dart';
import '../../../../core/utils/toast_helper.dart';

class BookAppointmentButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const BookAppointmentButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: 'Book New Appointment',
      icon: Iconsax.add,
      onPressed: onPressed ??
          () {
            ToastHelper.showError(
              context: context,
              message: 'Appointment booking failed',
            );
          },
    );
  }
}
