import 'package:clinexa_mobile/core/utils/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/book_appointment_button.dart';
import '../widgets/clinic_badge.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../widgets/home_header.dart';
import '../widgets/next_appointment_card.dart';
import '../widgets/recent_prescriptions_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeContent(),
    const Center(child: Text('Bookings Coming Soon')),
    const Center(child: Text('Meds Coming Soon')),
    const Center(child: Text('Profile Coming Soon')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          const HomeHeader(),
          SizedBox(height: 24.h),
          const ClinicBadge(),
          SizedBox(height: 32.h),
          const NextAppointmentCard(),
          SizedBox(height: 24.h),
          BookAppointmentButton(
            onPressed: () {
              ToastHelper.showSuccess(
                context: context,
                message: 'Appointment booked successfully',
              );
            },
          ),
          SizedBox(height: 32.h),
          const RecentPrescriptionsList(),
        ],
      ),
    );
  }
}
