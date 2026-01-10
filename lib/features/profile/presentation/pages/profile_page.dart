// features/profile/presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../app/router/route_names.dart';
import '../cubit/patient_cubit.dart';
import '../cubit/patient_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<PatientCubit>().getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.edit),
            onPressed: () => context.push(Routes.editProfile),
          ),
        ],
      ),
      body: BlocConsumer<PatientCubit, PatientState>(
        listener: (context, state) {
          if (state.status == PatientStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Error loading profile'),
                backgroundColor: Colors.red,
              ),
            );
            PatientCubit.get(context).clearError();
          }
        },
        builder: (context, state) {
          if (state.status == PatientStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == PatientStatus.error && !state.hasProfile) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.danger, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Failed to load profile',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<PatientCubit>().getMyProfile(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!state.hasProfile) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Iconsax.profile_remove,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No profile found'),
                  const SizedBox(height: 8),
                  const Text(
                    'Please complete your profile',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push(Routes.editProfile),
                    child: const Text('Complete Profile'),
                  ),
                ],
              ),
            );
          }

          final patient = state.patient!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Iconsax.user, size: 50),
                ),
                const SizedBox(height: 24),
                _InfoCard(
                  icon: Iconsax.cake,
                  label: 'Age',
                  value: patient.age?.toString() ?? 'Not set',
                ),
                _InfoCard(
                  icon: Iconsax.woman,
                  label: 'Gender',
                  value: patient.gender ?? 'Not set',
                ),
                _InfoCard(
                  icon: Iconsax.call,
                  label: 'Phone',
                  value: patient.phone ?? 'Not set',
                ),
                _InfoCard(
                  icon: Iconsax.location,
                  label: 'Address',
                  value: patient.address ?? 'Not set',
                ),
                if (!patient.isComplete) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        const Icon(Iconsax.warning_2, color: Colors.orange),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Profile Incomplete',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Please complete your profile to book appointments',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(label),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
