/*
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect({
    required dynamic servicemanId,
    required Function(List<dynamic>) onPendingOrders,
    required Function(Map<String, dynamic>) onNewOrder,
    required Function(int orderId) onOrderRemoved,
  }) {
    // 🔥 prevent duplicate listeners
    socket?.disconnect();
    socket?.dispose();

    socket = IO.io(
      "https://admin.rainbowsenterprises.com",
      IO.OptionBuilder()
          .setPath("/socket/live")
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print("✅ SOCKET CONNECTED");
      socket!.emit("register_serviceman", servicemanId);
    });

    socket!.on("pending_orders", (orders) {
      if (orders == null) return;
      onPendingOrders(List.from(orders));
    });

    socket!.on("new_order", (data) {
      if (data == null) return;
      onNewOrder(Map<String, dynamic>.from(data));
    });

    socket!.on("order_removed", (data) {
      if (data == null) return;
      onOrderRemoved(data["order_id"]);
    });

    socket!.onDisconnect((_) {
      print("❌ SOCKET DISCONNECTED");
    });
  }

  void dispose() {
    socket?.off("pending_orders");
    socket?.off("new_order");
    socket?.off("order_removed");
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }
}
*/

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ServicemanSocketService {
  static final ServicemanSocketService _instance =
  ServicemanSocketService._internal();

  factory ServicemanSocketService() => _instance;
  ServicemanSocketService._internal();

  IO.Socket? socket;

  void connect({
    required String baseUrl,
    required int servicemanId,
    required Function(Map<String, dynamic>) onNewOrder,
    required Function() onOrderRemoved,
  }) {
    print("🟡 [BG SOCKET] connect() called");
    print("🆔 [BG SOCKET] servicemanId = $servicemanId");

    socket?.disconnect();
    socket?.dispose();

    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setPath("/socket/live")
          .setTransports(['websocket'])
          .enableForceNew() // 🔥 VERY IMPORTANT
          .build(),
    );

    print("🟡 [BG SOCKET] Connecting...");
    socket!.connect();

    socket!.onConnect((_) {
      print("🟢 [BG SOCKET] CONNECTED");
      socket!.emit("register_serviceman", servicemanId);
      print("📤 [BG SOCKET] register_serviceman emitted");
    });

    socket!.onConnectError((err) {
      print("❌ [BG SOCKET] CONNECT ERROR → $err");
    });

    socket!.onError((err) {
      print("❌ [BG SOCKET] ERROR → $err");
    });

    socket!.on("new_order", (data) {
      print("🔥🔥🔥 [BG SOCKET] new_order RECEIVED");
      print("📦 [BG SOCKET] DATA = $data");

      if (data != null) {
        onNewOrder(Map<String, dynamic>.from(data));
      }
    });

    socket!.on("order_removed", (data) {
      print("🗑 [BG SOCKET] order_removed RECEIVED");
      print("📦 [BG SOCKET] DATA = $data");
      onOrderRemoved();
    });

    socket!.onDisconnect((_) {
      print("🔴 [BG SOCKET] DISCONNECTED");
    });
  }

  void dispose() {
    print("🛑 [BG SOCKET] dispose()");
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }
}



