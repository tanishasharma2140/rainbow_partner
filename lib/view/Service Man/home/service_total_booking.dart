import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_loader.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service Man/home/service_booking_detail.dart';
import 'package:rainbow_partner/view/service/ringtone_service.dart';
import 'package:rainbow_partner/view_model/service_man/accept_order_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/ignore_service_order_view_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../view_model/user_view_model.dart';

class ServiceTotalBooking extends StatefulWidget {
  const ServiceTotalBooking({super.key});

  @override
  State<ServiceTotalBooking> createState() => _ServiceTotalBookingState();
}

class _ServiceTotalBookingState extends State<ServiceTotalBooking> {
  List<Map<String, dynamic>> pending = [];

  @override
  @override
  void initState() {
    super.initState();
    _initSocket(); // async method call
  }

  Future<void> _initSocket() async {
    UserViewModel userViewModel = UserViewModel();
    String? userId = await userViewModel.getUser();


    if (userId == null || userId.isEmpty) {
      print("❌ servicemanId NULL hai, socket connect nahi hoga");
      return;
    }


    SocketService().connect(
      servicemanId: userId,

      onPendingOrders: (orders) {
        if (!mounted) return;
        setState(() {
          pending = orders.map((e) => mapOrder(e)).toList();
        });
      },

      onNewOrder: (order) {
        if (!mounted) return;
        setState(() {
          pending.insert(0, mapOrder(order));
        });
        RingtoneService().playRingtone();
      },

      onOrderRemoved: (orderId) {
        if (!mounted) return;
        setState(() {
          pending.removeWhere((e) => e["order_id"] == orderId);
        });
      },
    );
  }

  @override
  void dispose() {
    RingtoneService().stopRingtone();
    super.dispose();
  }

  Map<String, dynamic> mapOrder(Map<String, dynamic> o) {
    return {
      "order_id": o["order_id"],
      "id": "#${o["order_id"]}",
      "status": "Pending",
      "title": o["service_name"] ?? "",
      "price": "₹${o["final_amount"]}",
      "image": o["service_image"] ?? "",
      "address": o["service_address"] ?? "No address",
      "datetime": o["formatted_date"] ?? "",
      "customer": o["customer_name"] ?? "",
      "distance":
          "${double.tryParse(o["distance"].toString())?.toStringAsFixed(1)} km",
      "Quantity": o["quantity"] ?? "",
      "Description": o["description"] ?? "",
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  RingtoneService().stopRingtone();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const TextConst(
                title: "Pending Bookings",
                color: Colors.white,
                size: 20,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),

        body: pending.isEmpty
            ? const Center(
                child: Text(
                  "No pending bookings available",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(15),
                reverse: false,
                itemCount: pending.length,

                itemBuilder: (context, index) {
                  print("📦 UI INDEX $index → ${pending[index]["order_id"]}");
                  return bookingCard(pending[index]);
                },
              ),
      ),
    );
  }

  // ---------------- BOOKING CARD ----------------
  Widget bookingCard(Map<String, dynamic> b) {
    final acceptOrderVm = Provider.of<AcceptOrderViewModel>(context);
    final ignoreOrderVm = Provider.of<IgnoreServiceOrderViewModel>(context);
    final int orderId = b["order_id"];
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => ServiceBookingDetail(data: b)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// -------- TOP ROW --------
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      (b["image"] != null && b["image"].toString().isNotEmpty)
                      ? Image.network(
                          b["image"],
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/prooo.jpg",
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          "assets/prooo.jpg",
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextConst(
                            title: b["id"],
                            size: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.orange),
                            ),
                            child: const Text(
                              "Pending",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      SizedBox(
                        height: 20,
                        child: Marquee(
                          text: b["title"],
                          blankSpace: 40,
                          velocity: 25,
                          style: const TextStyle(
                            fontFamily: AppFonts.kanitReg,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      TextConst(
                        title: b["price"],
                        size: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.royalBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            infoRow("Address:", b["address"], marquee: true),
            infoRow("Date:", b["datetime"]),
            infoRow("Customer:", b["customer"]),
            infoRow("Distance:", b["distance"]),
            infoRow("Qty:", b["Quantity"].toString()),
            if (b["Description"] != null &&
                b["Description"].toString().trim().isNotEmpty)
              infoRow("Desc:", b["Description"].toString(), marquee: true),

            const SizedBox(height: 14),

            /// -------- BOTTOM ACTION --------
            Row(
              children: [
                Container(
                  height: 45,
                  width: 45,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColor.royalBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.royalBlue),
                  ),
                  child: Image.asset("assets/clock.gif", fit: BoxFit.contain),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      backgroundColor: Colors.red.withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      final int orderId = b["order_id"];

                      /// 🔥 stop ringtone
                      await RingtoneService().stopRingtone();

                      /// 🔥 CALL IGNORE API
                      ignoreOrderVm.ignoreServiceOrderApi(orderId, context);

                      /// 🔥 OPTIONAL: UI se hata do
                      setState(() {
                        pending.removeWhere((e) => e["order_id"] == orderId);
                      });
                    },
                    child:
                    ignoreOrderVm.loading(orderId)
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Text(
                      "Ignore",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColor.royalBlue),
                      backgroundColor: AppColor.royalBlue.withOpacity(0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      final int orderId = b["order_id"];
                      final dynamic distance = b["distance"];
                      await RingtoneService().stopRingtone();
                      acceptOrderVm.acceptOrderApi(orderId,distance, context);
                    },

                    child: acceptOrderVm.isLoading(orderId)
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CustomLoader(color: AppColor.royalBlue),
                          )
                        : TextConst(
                            title: "Accept",
                            fontWeight: FontWeight.w600,
                            size: 15,
                            color: AppColor.royalBlue,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- INFO ROW ----------------
  Widget infoRow(String title, String value, {bool marquee = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: AppFonts.kanitReg,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: marquee
                ? SizedBox(
                    height: 20,
                    child: Marquee(text: value, blankSpace: 40, velocity: 25),
                  )
                : Text(
                    value,
                    style: const TextStyle(fontFamily: AppFonts.kanitReg),
                  ),
          ),
        ],
      ),
    );
  }
}


class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect({
    required String servicemanId,
    required Function(List<dynamic>) onPendingOrders,
    required Function(Map<String, dynamic>) onNewOrder,
    required Function(int orderId) onOrderRemoved,
  }) {
    print("🟡 [UI SOCKET] connect() called");
    print("🆔 [UI SOCKET] servicemanId = $servicemanId");

    socket?.disconnect();
    socket?.dispose();

    socket = IO.io(
      "https://admin.rainbowsenterprises.com",
      IO.OptionBuilder()
          .setPath("/socket/live")
          .setTransports(['websocket'])
          .enableForceNew()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print("🟢 [UI SOCKET] CONNECTED");
      socket!.emit("register_serviceman", servicemanId);
    });

    socket!.on("pending_orders", (data) {
      print("📦 [UI SOCKET] pending_orders = $data");
      if (data != null) {
        onPendingOrders(List.from(data));
      }
    });

    socket!.on("new_order", (data) {
      print("🔥 [UI SOCKET] new_order = $data");
      if (data != null) {
        onNewOrder(Map<String, dynamic>.from(data));
      }
    });

    socket!.on("order_removed", (data) {
      print("🗑 [UI SOCKET] order_removed = $data");
      if (data != null) {
        onOrderRemoved(data["order_id"]);
      }
    });

    socket!.onDisconnect((_) {
      print("🔴 [UI SOCKET] DISCONNECTED");
    });
  }

  void dispose() {
    print("🛑 [UI SOCKET] dispose()");
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }
}
