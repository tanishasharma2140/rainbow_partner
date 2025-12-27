import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_can_discount_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_offer_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';

import 'home/driver_accepted_scree.dart';


class RideWaitingScreen extends StatefulWidget {
  const RideWaitingScreen({super.key});

  @override
  State<RideWaitingScreen> createState() => _RideWaitingScreenState();
}

class _RideWaitingScreenState extends State<RideWaitingScreen> {

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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

    setState(() {
      _currentLatLng = LatLng(position.latitude, position.longitude);
    });

    // Map camera move
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLatLng!, 16),
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
            /// ================= MAP =================
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLatLng ?? const LatLng(26.8467, 80.9462),
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
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
                    return const Center(child: Text("Error loading rides"));
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
              const Center(child: Text("Loading driver profile...")),
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


  Widget _orderListSheet(List<QueryDocumentSnapshot> docs) {
    final driverCanDiscountVm =
    Provider.of<DriverCanDiscountViewModel>(context);
    final driverOfferVm =
    Provider.of<DriverOfferViewModel>(context);

    return Container(
      height: 460,
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
                final int baseAmount =
                    data['estimated_amount'] ?? 0;

                final ValueNotifier<int> amount =
                ValueNotifier<int>(baseAmount);

                final String userIdOrder =
                    data['user_id']?.toString() ?? '';

                final String orderId = docs[index].id;

                /// CALL DISCOUNT API (ONLY ONCE)
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (driverCanDiscountVm.driverDiscount == null) {
                    driverCanDiscountVm.driverDiscountApi(
                      data['vehicle_id'],
                      baseAmount,
                      context,
                    );
                  }
                });



                /// DISCOUNT LOGIC (± FROM BASE)
                final int maxDiscount =
                (double.tryParse(
                  driverCanDiscountVm.driverDiscount ?? '0',
                ) ??
                    0)
                    .round();

                final int minAllowedAmount =
                    baseAmount - maxDiscount;
                final int maxAllowedAmount =
                    baseAmount + maxDiscount;

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
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          TextConst(
                            title:
                            "Order #${data['order_id'] ?? orderId}",
                            size: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                              Colors.green.withOpacity(0.12),
                              borderRadius:
                              BorderRadius.circular(20),
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
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.radio_button_checked,
                            size: 14,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextConst(
                              title:
                              data['pickup_location'] ?? '',
                              size: 13,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// DROP
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextConst(
                              title:
                              data['drop_location'] ?? '',
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
                          final bool canMinus =
                              value > minAllowedAmount;
                          final bool canPlus =
                              value < maxAllowedAmount;

                          return Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                /// MINUS
                                Expanded(
                                  child: InkWell(
                                    onTap: canMinus
                                        ? () =>
                                    amount.value -= 1
                                        : null,
                                    child: Center(
                                      child: Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: canMinus
                                              ? AppColor
                                              .royalBlue
                                              .withOpacity(
                                            0.12,
                                          )
                                              : Colors.grey.shade200,
                                          border: Border.all(
                                            color: canMinus
                                                ? AppColor
                                                .royalBlue
                                                : Colors
                                                .grey.shade400,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          size: 18,
                                          color: canMinus
                                              ? AppColor
                                              .royalBlue
                                              : Colors
                                              .grey.shade400,
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
                                        fontWeight:
                                        FontWeight.bold,
                                        color:
                                        AppColor.royalBlue,
                                      ),
                                    ),
                                  ),
                                ),

                                /// PLUS
                                Expanded(
                                  child: InkWell(
                                    onTap: canPlus
                                        ? () =>
                                    amount.value += 1
                                        : null,
                                    child: Center(
                                      child: Container(
                                        height: 32,
                                        width: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: canPlus
                                              ? AppColor
                                              .royalBlue
                                              .withOpacity(
                                            0.12,
                                          )
                                              : Colors.grey.shade200,
                                          border: Border.all(
                                            color: canPlus
                                                ? AppColor
                                                .royalBlue
                                                : Colors
                                                .grey.shade400,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 18,
                                          color: canPlus
                                              ? AppColor
                                              .royalBlue
                                              : Colors
                                              .grey.shade400,
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
