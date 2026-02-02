// core/services/socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Handles WebSocket connections for real-time updates
class SocketService {
  IO.Socket? _socket;

  // Events for Patient app
  static const String eventAppointmentUpdated = 'appointment:updated';
  static const String eventPrescriptionCreated = 'prescription:created';

  /// Connect to the socket server with authentication
  void connect(String baseUrl, String token) {
    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling']) // Enable polling fallback
          .setAuth({'token': token})
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print('Socket Connected');
    });

    _socket!.onDisconnect((_) => print('Socket Disconnected'));

    _socket!.onConnectError((data) => print('Socket Connect Error: $data'));
  }

  /// Listen for patient-specific events
  void listenForPatientEvents({
    required Function(dynamic) onAppointmentUpdated,
    required Function(dynamic) onPrescriptionCreated,
  }) {
    _socket?.on(eventAppointmentUpdated, (data) {
      print('Appointment Updated: $data');
      onAppointmentUpdated(data);
    });

    _socket?.on(eventPrescriptionCreated, (data) {
      print('Prescription Created: $data');
      onPrescriptionCreated(data);
    });
  }

  /// Check if socket is connected
  bool get isConnected => _socket?.connected ?? false;

  /// Disconnect from the socket server
  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
