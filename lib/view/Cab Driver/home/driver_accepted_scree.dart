import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class DriverRideAcceptedScreen extends StatefulWidget {
  final int orderId;
  final double driverLat;
  final double driverLng;

  const DriverRideAcceptedScreen({
    super.key,
    required this.orderId,
    required this.driverLat,
    required this.driverLng,
  });

  @override
  State<DriverRideAcceptedScreen> createState() => _DriverRideAcceptedScreenState();
}

class _DriverRideAcceptedScreenState extends State<DriverRideAcceptedScreen> {
  GoogleMapController? _mapController;

  Map<String, dynamic>? orderData;
  bool isLoading = true;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  StreamSubscription? _orderSubscription;
  Timer? _etaTimer;
  String estimatedTime = "Calculating...";

  @override
  void initState() {
    super.initState();
    _loadOrderData();
    _startETACalculation();
  }

  @override
  void dispose() {
    _orderSubscription?.cancel();
    _etaTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _startETACalculation() {
    // Update ETA every 30 seconds
    _etaTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (orderData != null) {
        _calculateETA();
      }
    });
  }

  void _calculateETA() {
    final pickupLat = orderData!['pickup_latitude'] ?? 0.0;
    final pickupLng = orderData!['pickup_longitude'] ?? 0.0;

    // Simple distance calculation (in km)
    final distance = _calculateDistance(
      widget.driverLat,
      widget.driverLng,
      pickupLat,
      pickupLng,
    );

    // Assume average speed of 30 km/h
    final timeInMinutes = (distance / 30 * 60).round();

    setState(() {
      estimatedTime = "$timeInMinutes min";
    });
  }

  double _calculateDistance(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    const double earthRadius = 6371; // km

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
            math.cos(_toRadians(lat1)) *
                math.cos(_toRadians(lat2)) *
                math.sin(dLon / 2) *
                math.sin(dLon / 2);

    final double c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c;
  }


  double _toRadians(double degree) {
    return degree * (3.141592653589793 / 180);
  }



  Future<void> _loadOrderData() async {
    try {
      _orderSubscription = FirebaseFirestore.instance
          .collection('cab_orders')
          .doc(widget.orderId.toString())
          .snapshots()
          .listen((orderDoc) {
        if (orderDoc.exists) {
          setState(() {
            orderData = orderDoc.data();
            isLoading = false;
          });
          _updateMapMarkers();
          _calculateETA();
        }
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateMapMarkers() {
    if (orderData == null) return;

    final pickupLat = orderData!['pickup_latitude'] ?? 0.0;
    final pickupLng = orderData!['pickup_longitude'] ?? 0.0;

    setState(() {
      markers = {
        Marker(
          markerId: MarkerId('pickup'),
          position: LatLng(pickupLat, pickupLng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Pickup Location'),
        ),
        Marker(
          markerId: MarkerId('driver'),
          position: LatLng(widget.driverLat, widget.driverLng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Your Location'),
        ),
      };

      polylines = {
        Polyline(
          polylineId: PolylineId('driver_to_pickup'),
          points: [
            LatLng(widget.driverLat, widget.driverLng),
            LatLng(pickupLat, pickupLng),
          ],
          color: Colors.blue,
          width: 4,
        ),
      };
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              widget.driverLat < pickupLat ? widget.driverLat : pickupLat,
              widget.driverLng < pickupLng ? widget.driverLng : pickupLng,
            ),
            northeast: LatLng(
              widget.driverLat > pickupLat ? widget.driverLat : pickupLat,
              widget.driverLng > pickupLng ? widget.driverLng : pickupLng,
            ),
          ),
          100,
        ),
      );
    }
  }

  Future<void> _openNavigator() async {
    if (orderData == null) return;

    final pickupLat = orderData!['pickup_latitude'];
    final pickupLng = orderData!['pickup_longitude'];

    // Google Maps URL
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=${widget.driverLat},${widget.driverLng}&destination=$pickupLat,$pickupLng&travelmode=driving',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (orderData == null) {
      return Scaffold(
        body: Center(child: Text('Error loading ride data')),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          /// ================= MAP =================
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.driverLat, widget.driverLng),
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              _updateMapMarkers();
            },
            markers: markers,
            polylines: polylines,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
            mapToolbarEnabled: false,
            compassEnabled: true,
          ),

          /// ================= TOP GRADIENT OVERLAY =================
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// ================= HEADER SECTION =================
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                /// Back Button
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    iconSize: 18,
                  ),
                ),

                Spacer(),

                /// ETA Card
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: AppColor.royalBlue,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        estimatedTime,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColor.royalBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                /// Distance Info Card
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColor.royalBlue,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "${orderData?['distance_km'] ?? 0} km",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ================= FLOATING NAVIGATOR BUTTON =================
          Positioned(
            bottom: 180,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.royalBlue.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: _openNavigator,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColor.royalBlue,
                        AppColor.royalBlue.withOpacity(0.9),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.navigation_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),

          /// ================= DRAGGABLE BOTTOM SHEET =================
          DraggableScrollableSheet(
            initialChildSize: 0.40,
            minChildSize: 0.32,
            maxChildSize: 0.75,
            snap: true,
            snapSizes: [0.32, 0.40, 0.75],
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 0,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// DRAG HANDLE
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        children: [
                          /// USER INFO SECTION
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                /// User Avatar
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppColor.royalBlue.withOpacity(0.8),
                                        AppColor.royalBlue.withOpacity(0.4),
                                      ],
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                SizedBox(width: 16),

                                /// User Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orderData!['user_name'] ?? 'Customer',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Order #${widget.orderId}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// Call Button
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF4CAF50),
                                        Color(0xFF2E7D32),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.phone_rounded, size: 20),
                                    color: Colors.white,
                                    onPressed: () => _makePhoneCall(
                                      orderData!['user_mobile'].toString(),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          /// RIDE INFO CARD
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                /// Distance & Amount Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: _infoItem(
                                        icon: Icons.location_on_outlined,
                                        title: 'Distance',
                                        value: "${orderData?['distance_km'] ?? 0} km",
                                        color: Colors.blue.shade600,
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      width: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                    Expanded(
                                      child: _infoItem(
                                        icon: Icons.currency_rupee_rounded,
                                        title: 'Amount',
                                        value: "₹${orderData!['estimated_amount']}",
                                        color: Color(0xFF4CAF50),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                /// PICKUP LOCATION
                                _locationRow(
                                  icon: Icons.circle,
                                  iconColor: Colors.green,
                                  iconBgColor: Colors.green.withOpacity(0.1),
                                  title: 'Pickup',
                                  address: orderData!['pickup_location'] ?? 'N/A',
                                  showDivider: true,
                                ),

                                SizedBox(height: 16),

                                /// DROP LOCATION
                                _locationRow(
                                  icon: Icons.location_pin,
                                  iconColor: Colors.red,
                                  iconBgColor: Colors.red.withOpacity(0.1),
                                  title: 'Drop',
                                  address: orderData!['drop_location'] ?? 'N/A',
                                  showDivider: false,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24),

                          /// I'M HERE BUTTON
                          Container(
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppColor.royalBlue,
                                  AppColor.royalBlue.withOpacity(0.9),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.royalBlue.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 0,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              child: InkWell(
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection('cab_orders')
                                      .doc(widget.orderId.toString())
                                      .update({'order_status': 2});

                                  // Show confirmation
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Arrival marked successfully!'),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "I'm Here",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

// Helper Widgets


    );
  }
  Widget _infoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _locationRow({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String address,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Location Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 18,
              ),
            ),
            SizedBox(width: 12),

            /// Location Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          SizedBox(height: 16),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade200,
          ),
        ],
      ],
    );
  }

}