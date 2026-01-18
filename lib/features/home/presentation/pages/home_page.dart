import 'package:clinexa_mobile/features/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:clinexa_mobile/features/appointments/presentation/pages/appointments_page.dart';
import 'package:clinexa_mobile/features/booking/presentation/pages/booking_flow_page.dart';
import 'package:clinexa_mobile/features/prescriptions/presentation/cubit/prescriptions_cubit.dart';
import 'package:clinexa_mobile/features/prescriptions/presentation/pages/prescriptions_page.dart';
import 'package:clinexa_mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:clinexa_mobile/core/di/injection.dart';

import 'package:clinexa_mobile/features/home/presentation/widgets/book_appointment_button.dart';
import 'package:clinexa_mobile/features/home/presentation/widgets/clinic_badge.dart';
import 'package:clinexa_mobile/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:clinexa_mobile/features/home/presentation/widgets/home_header.dart';
import 'package:clinexa_mobile/features/home/presentation/widgets/next_appointment_card.dart';
import 'package:clinexa_mobile/features/home/presentation/widgets/recent_prescriptions_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _HomeContent(),
    const AppointmentsPage(),
    const PrescriptionsPage(),
    const ProfilePage(),
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
          const HomeHeader(),
          SizedBox(height: 24.h),
          const ClinicBadge(),
          SizedBox(height: 32.h),
          const NextAppointmentCard(),
          BookAppointmentButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookingFlowPage(),
                ),
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
