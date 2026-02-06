import 'package:socket_io_client/socket_io_client.dart' as IO;

class DriverSocketService {
  static final DriverSocketService _instance = DriverSocketService._internal();
  factory DriverSocketService() => _instance;
  DriverSocketService._internal();

  IO.Socket? socket;

  void connect({
    required String baseUrl,
    required int driverId,
    required Function(List<dynamic>) onSyncRides,
    Function()? onNewRide,
    Function()? onEmptyRide,
  }) {
    if (socket != null && socket!.connected) {
      print("⚠️ Socket already connected");
      return;
    }

    socket = IO.io(
      baseUrl,
      {
        'path': '/socket/live',

        // 🔥 MOST IMPORTANT FIX
        'transports': ['websocket', 'polling'],

        'autoConnect': false,
        'forceNew': true,

        // 🔥 HEARTBEAT SAFE
        'timeout': 30000,
        'reconnection': true,
        'reconnectionAttempts': 999999,
        'reconnectionDelay': 2000,
      },
    );

    socket!.onConnect((_) {
      print("✅ Socket connected");
      socket!.emit("JOIN_DRIVER", driverId);
    });

    socket!.onDisconnect((reason) {
      print("🔌 Disconnected: $reason");
    });

    socket!.onConnectError((err) {
      print("❌ Connect error: $err");
    });

    socket!.onError((err) {
      print("❌ Socket error: $err");
    });

    socket!.on("SYNC_RIDES", (rides) {
      print("🔄 SYNC_RIDES: $rides");

      onSyncRides(List<dynamic>.from(rides));

      if (rides.isNotEmpty) {
        onNewRide?.call();
      } else {
        onEmptyRide?.call();
      }
    });

    socket!.on("NEW_RIDE", (_) => onNewRide?.call());
    socket!.on("REMOVE_RIDE", (_) => onEmptyRide?.call());

    socket!.connect();
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }
}