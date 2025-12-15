import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect({
    required int servicemanId,
    required Function(List<dynamic>) onPendingOrders,
    required Function(Map<String, dynamic>) onNewOrder,
    required Function(int orderId) onOrderRemoved,
  }) {
    // 🔥 prevent duplicate listeners
    socket?.disconnect();
    socket?.dispose();

    socket = IO.io(
      "https://yoyomiles.codescarts.com",
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
