import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';

/// =====================================================
/// STATEFUL WIDGET (IMPORTANT)
/// =====================================================
class RideWaitingScreen extends StatefulWidget {
  const RideWaitingScreen({super.key});

  @override
  State<RideWaitingScreen> createState() => _RideWaitingScreenState();
}

/// =====================================================
/// STATE CLASS
/// =====================================================
class _RideWaitingScreenState extends State<RideWaitingScreen> {
  final double currentLat = 26.8467;
  final double currentLng = 80.9462;

  @override
  Widget build(BuildContext context) {
    final profileVm = Provider.of<DriverProfileViewModel>(context);
    final int? driverId = profileVm.driverProfileModel?.data?.id;

    debugPrint("👤 DRIVER ID => $driverId");

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,

        /// APP BAR
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const TextConst(
            title: "Searching Ride",
            size: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),

        body: Stack(
          children: [
            /// ================= MAP =================
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(currentLat, currentLng),
                zoom: 15,
              ),
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),

            /// ================= REALTIME FIREBASE =================
            if (driverId != null)
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cab_orders')
                    .where(
                  'matched_driver_ids', // ✅ EXACT FIELD
                  arrayContains: driverId,
                )
                    .snapshots(),
                builder: (context, snapshot) {
                  debugPrint(
                    "📡 STREAM | state=${snapshot.connectionState} | hasData=${snapshot.hasData}",
                  );

                  // LOADING
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _waitingCenter();
                  }

                  // ERROR
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error loading rides"),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];

                  debugPrint("📦 DOCS COUNT => ${docs.length}");

                  // NO RIDES
                  if (docs.isEmpty) {
                    return _waitingCenter();
                  }

                  // RIDES FOUND
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: _orderListSheet(docs),
                  );
                },
              ),

            /// PROFILE NOT READY
            if (driverId == null)
              const Center(
                child: Text("Loading driver profile..."),
              ),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// WAITING UI
  /// =====================================================
  Widget _waitingCenter() {
    return Align(
      alignment: const Alignment(0, -0.25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: AppColor.royalBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.local_taxi_rounded,
              size: 50,
              color: AppColor.royalBlue,
            ),
          ),
          const SizedBox(height: 16),
          const TextConst(
            title: "Searching for nearby rides…",
            size: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 6),
          const TextConst(
            title: "Please stay online",
            size: 14,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  /// =====================================================
  /// ORDER LIST UI (RAW FIREBASE DATA)
  /// =====================================================
  Widget _orderListSheet(List<QueryDocumentSnapshot> docs) {
    return Container(
      height: 420,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: ListView.builder(
        itemCount: docs.length,
        itemBuilder: (context, index) {
          final data = docs[index].data() as Map<String, dynamic>;

          debugPrint("🧾 Render order => ${docs[index].id}");

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order ID: ${data['order_id'] ?? docs[index].id}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text("Amount: ₹${data['estimated_amount']}"),
                  Text("Pickup: ${data['pickup_location']}"),
                  Text("Drop: ${data['drop_location']}"),
                  Text("Matched Drivers: ${data['matched_driver_ids']}"),
                  const SizedBox(height: 10),
                  CustomButton(
                    title: "Accept Ride",
                    bgColor: AppColor.royalBlue,
                    onTap: () {
                      debugPrint(
                        "🚗 ACCEPT CLICKED | docId=${docs[index].id}",
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
