import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/cabdriver/delete_expired_order_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_can_discount_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_offer_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'home/driver_accepted_scree.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';


class RideWaitingScreen extends StatefulWidget {
  const RideWaitingScreen({super.key});

  @override
  State<RideWaitingScreen> createState() => _RideWaitingScreenState();
}

class _RideWaitingScreenState extends State<RideWaitingScreen> {

  Timer? _deleteOrderTimer;
  final Map<String, bool> _discountFetchedForOrder = {};
  BitmapDescriptor? _currentLocationIcon;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
      _loadMarkerIcon();

      final deleteOrder =
      Provider.of<DeleteExpiredOrderViewModel>(context, listen: false);

      /// 🔥 FIRST CALL
      deleteOrder.deleteExpiredOrderApi();

      /// 🔁 EVERY 1 MINUTE
      _deleteOrderTimer = Timer.periodic(
        const Duration(minutes: 1),
            (timer) {
          deleteOrder.deleteExpiredOrderApi();
        },
      );
    });
  }

  Future<BitmapDescriptor> _resizeMarker(
      String assetPath,
      int width,
      ) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width, // 👈 CONTROL SIZE HERE
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? bytes =
    await fi.image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }


  Future<void> _loadMarkerIcon() async {
    _currentLocationIcon = await _resizeMarker(
      'assets/location_oin.png',
      190,
    );

    if (_currentLatLng != null) {
      _updateCurrentLocationMarker(_currentLatLng!);
    }
  }



  Set<Marker> _markers = {};

  void _updateCurrentLocationMarker(LatLng latLng) {
    _markers.clear();

    _markers.add(
      Marker(
        markerId: const MarkerId("current_location"),
        position: latLng,
        icon: _currentLocationIcon ?? BitmapDescriptor.defaultMarker,
        anchor: const Offset(0.5, 0.6),
      ),
    );

    setState(() {});
  }

  @override
  void dispose() {
    _deleteOrderTimer?.cancel();
    super.dispose();
  }

  LatLng? _currentLatLng;
  GoogleMapController? _mapController;

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final latLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentLatLng = latLng;
    });

    // ✅ ADD THIS
    _updateCurrentLocationMarker(latLng);

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 16),
    );
  }



  void _goToAcceptedRide({
    required int orderId,
  }) {
    if (_currentLatLng == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => DriverRideAcceptedScreen(
            orderId: orderId,
            driverLat: _currentLatLng!.latitude,
            driverLng: _currentLatLng!.longitude,
          ),
        ),
      );
    });
  }


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
            /// ================= MAP (REDUCED HEIGHT) =================
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.55,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentLatLng ?? const LatLng(26.8467, 80.9462),
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                myLocationEnabled: false, // ❌ default blue dot off
                markers: _markers,        // ✅ custom image marker
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),



            /// ================= REALTIME FIREBASE =================
            if (driverId != null)
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cab_orders')
                    .where(
                  'matched_driver_ids',
                  arrayContains: driverId,
                )
                    .snapshots(),
                builder: (context, snapshot) {
                  debugPrint(
                    "📡 STREAM | state=${snapshot.connectionState} | hasData=${snapshot.hasData}",
                  );

                  // LOADING
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _waitingUI();
                  }

                  // ERROR
                  if (snapshot.hasError) {
                    return _waitingUI(error: true);
                  }

                  final docs = snapshot.data?.docs ?? [];

                  debugPrint("📦 DOCS COUNT => ${docs.length}");

                  // NO RIDES
                  if (docs.isEmpty) {
                    return _waitingUI();
                  }

                  // RIDES FOUND
                  return Positioned(
                    top: MediaQuery.of(context).size.height * 0.35,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _orderListSheet(docs),
                  );
                },
              ),

            /// PROFILE NOT READY
            if (driverId == null)
              const Center(child: Text("Loading driver profile...")),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// WAITING UI - NOW POSITIONED BELOW MAP
  /// =====================================================
  Widget _waitingUI({bool error = false}) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.55,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!error) ...[
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColor.royalBlue.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.local_taxi_rounded,
                    size: 45,
                    color: AppColor.royalBlue,
                  ),
                ),

                const SizedBox(height: 18),

                const TextConst(
                  title: "Waiting for ride...",
                  size: 16,
                  fontWeight: FontWeight.w700,
                ),

                const SizedBox(height: 6),

                const TextConst(
                  title: "Please stay online",
                  size: 14,
                  color: Colors.black54,
                ),

                const SizedBox(height: 20),

                // 🔥 Uber / Rapido style Linear Progress
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      backgroundColor:
                      AppColor.royalBlue.withOpacity(0.15),
                      valueColor: const AlwaysStoppedAnimation(
                        AppColor.royalBlue,
                      ),
                    ),
                  ),
                ),
              ] else
                const Text(
                  "Error loading rides",
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _orderListSheet(List<QueryDocumentSnapshot> docs) {
    final driverCanDiscountVm =
    Provider.of<DriverCanDiscountViewModel>(context);
    final driverOfferVm =
    Provider.of<DriverOfferViewModel>(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 14,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DRAG HANDLE
          Center(
            child: Container(
              height: 5,
              width: 46,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const Text(
            "New Ride Requests",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: ListView.separated(
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;

                /// ---------------- CORE DATA ----------------
                final int baseAmount = data['estimated_amount'] ?? 0;
                final String orderId = docs[index].id;
                final String userIdOrder = data['user_id']?.toString() ?? '';
                final int vehicleId = data['vehicle_id'] ?? 0;

                /// ✅ FETCH DISCOUNT ONLY ONCE PER ORDER
                if (_discountFetchedForOrder[orderId] != true) {
                  _discountFetchedForOrder[orderId] = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (driverCanDiscountVm.driverDiscount == null) {
                      driverCanDiscountVm.driverDiscountApi(
                        vehicleId,
                        baseAmount,
                        context,
                      );
                    }
                  });
                }

                /// DISCOUNT LOGIC (± FROM BASE)
                final int maxDiscount =
                (double.tryParse(
                  driverCanDiscountVm.driverDiscount ?? '0',
                ) ?? 0).round();

                final int minAllowedAmount = baseAmount - maxDiscount;
                final int maxAllowedAmount = baseAmount + maxDiscount;

                final ValueNotifier<int> amount = ValueNotifier<int>(baseAmount);

                if (data['order_status'] == 1 && _currentLatLng != null) {
                  _goToAcceptedRide(
                    orderId: data['order_id'],
                  );
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColor.whiteDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ORDER ID + DISTANCE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextConst(
                            title: "Order #${data['order_id'] ?? orderId}",
                            size: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextConst(
                              title: "${data['distance_km']} km",
                              color: Colors.green,
                              size: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// PICKUP
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.radio_button_checked,
                            size: 14,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextConst(
                              title: data['pickup_location'] ?? '',
                              size: 13,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// DROP
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextConst(
                              title: data['drop_location'] ?? '',
                              size: 13,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      TextConst(
                        title: "Estimated Amount: ₹${data['estimated_amount']}",
                        size: 13,
                        fontWeight: FontWeight.w600,
                      ),

                      const SizedBox(height: 16),

                      /// FARE AMOUNT (± BASE RANGE)
                      ValueListenableBuilder<int>(
                        valueListenable: amount,
                        builder: (_, value, __) {
                          final bool canMinus = value > minAllowedAmount;
                          final bool canPlus = value < maxAllowedAmount;

                          return Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                /// MINUS
                                Expanded(
                                  child: InkWell(
                                    onTap: canMinus ? () => amount.value -= 1 : null,
                                    child: Center(
                                      child: Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: canMinus
                                              ? AppColor.royalBlue.withOpacity(0.12)
                                              : Colors.grey.shade200,
                                          border: Border.all(
                                            color: canMinus
                                                ? AppColor.royalBlue
                                                : Colors.grey.shade400,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          size: 18,
                                          color: canMinus
                                              ? AppColor.royalBlue
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                /// AMOUNT TEXT
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      "₹$value",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.royalBlue,
                                      ),
                                    ),
                                  ),
                                ),

                                /// PLUS
                                Expanded(
                                  child: InkWell(
                                    onTap: canPlus ? () => amount.value += 1 : null,
                                    child: Center(
                                      child: Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: canPlus
                                              ? AppColor.royalBlue.withOpacity(0.12)
                                              : Colors.grey.shade200,
                                          border: Border.all(
                                            color: canPlus
                                                ? AppColor.royalBlue
                                                : Colors.grey.shade400,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 18,
                                          color: canPlus
                                              ? AppColor.royalBlue
                                              : Colors.grey.shade400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      /// AGREE BUTTON
                      CustomButton(
                        title: "Agree",
                        bgColor: AppColor.royalBlue,
                        onTap: () {
                          final int offerAmount = amount.value;

                          if (offerAmount < minAllowedAmount ||
                              offerAmount > maxAllowedAmount) {
                            Utils.showErrorMessage(
                              context,
                              "Invalid offer amount",
                            );
                            return;
                          }

                          driverOfferVm.driverOfferApi(
                            userIdOrder,
                            orderId,
                            offerAmount,
                            baseAmount,
                            context,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}