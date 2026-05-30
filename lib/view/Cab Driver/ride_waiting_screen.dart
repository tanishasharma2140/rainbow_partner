import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/cabdriver/accept_later_ride_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/delete_expired_order_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_can_discount_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_ignore_order_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_offer_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';
import 'home/driver_accepted_scree.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class RideWaitingScreen extends StatefulWidget {
  const RideWaitingScreen({super.key});

  @override
  State<RideWaitingScreen> createState() => _RideWaitingScreenState();
}

class _RideWaitingScreenState extends State<RideWaitingScreen> {
  Timer? _deleteOrderTimer;
  final Map<String, bool> _discountFetchedForOrder = {};
  BitmapDescriptor? _currentLocationIcon;

  // Store selected amounts to prevent reset on stream update
  final Map<String, ValueNotifier<int>> _orderAmounts = {};

  // 🔊 RINGER MANAGEMENT
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Set<String> _playedOrderIds = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
      _loadMarkerIcon();
      _startSocket();
    });
  }

  Future<void> _startSocket() async {
    final userViewModel = UserViewModel();

    String? driverId = await userViewModel.getUser();

    if (driverId == null || driverId == 0) {
      debugPrint("❌ Driver ID not found, socket not started");
      return;
    }

    debugPrint("✅ Starting socket with driverId: $driverId");
  }

  Future<BitmapDescriptor> _resizeMarker(String assetPath, int width) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? bytes = await fi.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Future<void> _loadMarkerIcon() async {
    _currentLocationIcon = await _resizeMarker('assets/location_oin.png', 190);

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
    _audioPlayer.dispose();
    for (var notifier in _orderAmounts.values) {
      notifier.dispose();
    }
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

    _updateCurrentLocationMarker(latLng);

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
  }

  void _goToAcceptedRide({required int orderId}) {
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
    final loc = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: TextConst(
            title: loc.searching_ride,
            size: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        body: Stack(
          children: [
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
                myLocationEnabled: false,
                markers: _markers,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),

            /// ================= REALTIME FIREBASE =================
            if (driverId != null)
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cab_orders')
                    .where('matched_driver_ids', arrayContains: driverId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _waitingUI();
                  }

                  if (snapshot.hasError) {
                    return _waitingUI(error: true);
                  }

                  final docs = snapshot.data?.docs ?? [];

                  final filteredDocs = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final status = data['order_status'] ?? 0;
                    final assignedDriverId = data['driver_id'];

                    if (status == 0) return true;
                    if (status == 1) {
                      return assignedDriverId.toString() == driverId.toString();
                    }
                    return false;
                  }).toList();

                  if (filteredDocs.isNotEmpty) {
                    for (var doc in filteredDocs) {
                      final orderId = doc.id;
                      if (!_playedOrderIds.contains(orderId)) {
                        _playedOrderIds.add(orderId);
                        break;
                      }
                    }
                  } else {
                    _playedOrderIds.clear();
                  }

                  if (filteredDocs.isEmpty) {
                    _playedOrderIds.clear();
                    return _waitingUI();
                  }

                  return Positioned(
                    top: MediaQuery.of(context).size.height * 0.35,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _orderListSheet(filteredDocs, driverId!),
                  );
                },
              ),

            if (driverId == null)
              Center(child: Text(loc.loading_driver_profile)),
          ],
        ),
      ),
    );
  }

  Widget _waitingUI({bool error = false}) {
    final loc = AppLocalizations.of(context)!;
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
                TextConst(
                  title: loc.waiting_for_ride,
                  size: 16,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 6),
                TextConst(
                  title: loc.please_stay_online,
                  size: 14,
                  color: Colors.black54,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      backgroundColor: AppColor.royalBlue.withOpacity(0.15),
                      valueColor: const AlwaysStoppedAnimation(
                        AppColor.royalBlue,
                      ),
                    ),
                  ),
                ),
              ] else
                Text(
                  loc.error_loading_rides,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderListSheet(List<QueryDocumentSnapshot> docs, int currentDriverId) {
    final loc = AppLocalizations.of(context)!;
    final driverCanDiscountVm = Provider.of<DriverCanDiscountViewModel>(context);
    final driverOfferVm = Provider.of<DriverOfferViewModel>(context);
    final driverIgnoreVm = Provider.of<DriverIgnoreOrderViewModel>(context);
    final acceptLaterRideVm = Provider.of<AcceptLaterRideViewModel>(context);

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
          Text(
            loc.new_ride_requests,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.kanitReg,
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.separated(
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final int baseAmount = data['estimated_amount'] ?? 0;
                final String orderId = docs[index].id;
                final String userIdOrder = data['user_id']?.toString() ?? '';
                final int vehicleId = data['vehicle_id'] ?? 0;
                final int orderType = data['order_type'] ?? 1;

                if (orderType == 1 && _discountFetchedForOrder[orderId] != true) {
                  _discountFetchedForOrder[orderId] = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (driverCanDiscountVm.driverDiscount == null) {
                      driverCanDiscountVm.driverDiscountApi(vehicleId, baseAmount, context);
                    }
                  });
                }

                // New Logic: 10%, 15%, 20%, 25% Increase and Decrease from base price
                final List<int> possibleAmounts = {
                  (baseAmount * 0.75).round(), // -25%
                  (baseAmount * 0.80).round(), // -20%
                  (baseAmount * 0.85).round(), // -15%
                  (baseAmount * 0.90).round(), // -10%
                  baseAmount,                  // original
                  (baseAmount * 1.10).round(), // +10%
                  (baseAmount * 1.15).round(), // +15%
                  (baseAmount * 1.20).round(), // +20%
                  (baseAmount * 1.25).round(), // +25%
                }.toList()..sort();

                final ValueNotifier<int> amount = _orderAmounts.putIfAbsent(
                  orderId,
                  () => ValueNotifier<int>(baseAmount),
                );

                if (data['order_status'] == 1 &&
                    _currentLatLng != null &&
                    data['driver_id'].toString() == currentDriverId.toString()) {
                  _goToAcceptedRide(orderId: data['order_id']);
                }

                if (orderType == 2) {
                  return _buildOrderType2Card(
                    data: data,
                    orderId: orderId,
                    userIdOrder: userIdOrder,
                    userName: data['user_name'] ?? '',
                    userMobile: data['user_mobile']?.toString() ?? '',
                    baseAmount: baseAmount,
                    acceptLaterRideVm: acceptLaterRideVm,
                    driverIgnoreVm: driverIgnoreVm,
                  );
                } else {
                  return _buildOrderType1Card(
                    data: data,
                    orderId: orderId,
                    userIdOrder: userIdOrder,
                    baseAmount: baseAmount,
                    possibleAmounts: possibleAmounts,
                    amount: amount,
                    driverOfferVm: driverOfferVm,
                    driverIgnoreVm: driverIgnoreVm,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderType2Card({
    required Map<String, dynamic> data,
    required String orderId,
    required String userIdOrder,
    required String userName,
    required String userMobile,
    required int baseAmount,
    required AcceptLaterRideViewModel acceptLaterRideVm,
    required DriverIgnoreOrderViewModel driverIgnoreVm,
  }) {
    final loc = AppLocalizations.of(context)!;
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
          Row(
            children: [
              TextConst(
                title: "${loc.order} #${data['order_id'] ?? orderId}",
                size: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              const Spacer(),
              InkWell(
                onTap: () => driverIgnoreVm.driverIgnoreOrderApi(orderId, context),
                child: Container(
                  height: 28, width: 28,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: AppColor.royalBlue),
              const SizedBox(width: 8),
              TextConst(title: userName, size: 14, fontWeight: FontWeight.w600),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.radio_button_checked, size: 14, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(child: TextConst(title: data['pickup_location'] ?? '', size: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(child: TextConst(title: data['drop_location'] ?? '', size: 13)),
            ],
          ),
          const SizedBox(height: 16),
          acceptLaterRideVm.loading
              ? const Center(child: CircularProgressIndicator(color: AppColor.royalBlue))
              : CustomButton(
                  title: loc.accept,
                  bgColor: AppColor.royalBlue,
                  onTap: () {
                    acceptLaterRideVm.acceptLaterRideApi(
                      orderId,
                      _currentLatLng!.latitude,
                      _currentLatLng!.longitude,
                      context,
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildOrderType1Card({
    required Map<String, dynamic> data,
    required String orderId,
    required String userIdOrder,
    required int baseAmount,
    required List<int> possibleAmounts,
    required ValueNotifier<int> amount,
    required DriverOfferViewModel driverOfferVm,
    required DriverIgnoreOrderViewModel driverIgnoreVm,
  }) {
    final loc = AppLocalizations.of(context)!;
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
          Row(
            children: [
              TextConst(
                title: "${loc.order} #${data['order_id'] ?? orderId}",
                size: 13,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
              const Spacer(),
              InkWell(
                onTap: () => driverIgnoreVm.driverIgnoreOrderApi(orderId, context),
                child: Container(
                  height: 28, width: 28,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.radio_button_checked, size: 14, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(child: TextConst(title: data['pickup_location'] ?? '', size: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(child: TextConst(title: data['drop_location'] ?? '', size: 13)),
            ],
          ),
          const SizedBox(height: 16),
          TextConst(
            title: "${loc.estimated_amount}: ₹${data['estimated_amount']}",
            size: 13,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<int>(
            valueListenable: amount,
            builder: (_, value, __) {
              int currentIndex = possibleAmounts.indexOf(value);
              if (currentIndex == -1) currentIndex = possibleAmounts.indexOf(baseAmount);

              final bool canMinus = currentIndex > 0;
              final bool canPlus = currentIndex < possibleAmounts.length - 1;

              return Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: canMinus ? () => amount.value = possibleAmounts[currentIndex - 1] : null,
                        child: Center(
                          child: Icon(
                            Icons.remove_circle,
                            color: canMinus ? AppColor.royalBlue : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
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
                    Expanded(
                      child: InkWell(
                        onTap: canPlus ? () => amount.value = possibleAmounts[currentIndex + 1] : null,
                        child: Center(
                          child: Icon(
                            Icons.add_circle,
                            color: canPlus ? AppColor.royalBlue : Colors.grey.shade400,
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
          driverOfferVm.loading
              ? const Center(child: CircularProgressIndicator(color: AppColor.royalBlue))
              : CustomButton(
                  title: loc.agree,
                  bgColor: AppColor.royalBlue,
                  onTap: () {
                    final int offerAmount = amount.value;
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
  }
}
