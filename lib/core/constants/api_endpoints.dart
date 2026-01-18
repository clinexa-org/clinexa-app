// core/constants/api_endpoints.dart
/// Centralized API endpoints constants
/// All API paths should be defined here to avoid hardcoding
class ApiEndpoints {
  ApiEndpoints._();

  // ============ Sprint 1 — Auth Endpoints ============
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String authMe = '/auth/me';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // ============ User Endpoints ============
  static const String userProfile = '/users/profile';
  static const String userAvatar = '/users/avatar';

  // ============ Sprint 2 — Doctors Endpoints ============
  static const String doctors = '/doctors';
  static const String doctorMe = '/doctors/me';
  static String doctorById(String id) => '/doctors/$id';

  // ============ Sprint 2 — Clinics Endpoints ============
  static const String clinics = '/clinics';
  static const String clinicMe = '/clinics/me';
  static String clinicByDoctorId(String doctorId) => '/clinics/$doctorId';

  // ============ Sprint 3 — Patients Endpoints ============
  static const String patients = '/patients';
  static const String patientMe = '/patients/me';
  static String patientById(String id) => '/patients/$id';

  // ============ Sprint 4 — Appointments Endpoints ============
  static const String appointments = '/appointments';
  static const String appointmentsMy = '/appointments/my';
  static const String appointmentsDoctor = '/appointments/doctor';
  static String appointmentConfirm(String id) => '/appointments/confirm/$id';
  static String appointmentCancel(String id) => '/appointments/cancel/$id';
  static String appointmentComplete(String id) => '/appointments/complete/$id';
  static String appointmentReschedule(String id) =>
      '/appointments/reschedule/$id';

  // ============ Sprint 5 — Prescriptions Endpoints ============
  static const String prescriptions = '/prescriptions';
  static const String prescriptionsMy = '/prescriptions/my';
  static String prescriptionById(String id) => '/prescriptions/$id';
  static String prescriptionsByPatient(String patientId) =>
      '/prescriptions/patient/$patientId';
  static String prescriptionsByAppointment(String appointmentId) =>
      '/prescriptions/appointment/$appointmentId';

  // ============ Sprint 6 — Admin Endpoints ============
  static const String adminStats = '/admin/stats';
  static const String adminPatients = '/admin/patients';
  static String adminPatientToggleActive(String patientId) =>
      '/admin/patients/$patientId/toggle-active';
  static const String adminAppointments = '/admin/appointments';
  static String adminAppointmentStatus(String appointmentId) =>
      '/admin/appointments/$appointmentId/status';
  static const String adminPrescriptions = '/admin/prescriptions';
  static const String adminClinic = '/admin/clinic';
}
