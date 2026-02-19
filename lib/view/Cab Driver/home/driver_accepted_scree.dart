import 'dart:convert';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/driver_home_page.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_cancel_reason_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/change_cab_order_status_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import '../../../res/slide_to_button.dart' show SlideToButton;

class DriverRideAcceptedScreen extends StatefulWidget {
  final int orderId;
  final double driverLat;
  final double driverLng;
  final int? orderStatus;


  const DriverRideAcceptedScreen({
    super.key,
    required this.orderId,
    required this.driverLat,
    required this.driverLng, this.orderStatus,
  });

  @override
  State<DriverRideAcceptedScreen> createState() => _DriverRideAcceptedScreenState();
}

class _DriverRideAcceptedScreenState extends State<DriverRideAcceptedScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool isVerifyingOtp = false;
  bool isCompletingRide = false;
  GoogleMapController? _mapController;
  bool _rideCompletedDialogShown = false;
  bool _navigatedToPaymentScreen = false;
  int? _previousOrderStatus;
  int? _previousPayMode;
  bool _paymentSuccessDialogShown = false;



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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cabCancelReasonVm = Provider.of<CabCancelReasonViewModel>(
        context,
        listen: false,
      );
      cabCancelReasonVm.cabCancelReasonApi("2");
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _orderSubscription?.cancel();
    _etaTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _startETACalculation() {
    _etaTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (orderData != null) {
        _calculateETA();
      }
    });
  }

  void _calculateETA() {
    final pickupLat = orderData!['pickup_latitude'] ?? 0.0;
    final pickupLng = orderData!['pickup_longitude'] ?? 0.0;

    final distance = _calculateDistance(
      widget.driverLat,
      widget.driverLng,
      pickupLat,
      pickupLng,
    );

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
    const double earthRadius = 6371;

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
          final data = orderDoc.data();
          final int newStatus = data?['order_status'] ?? 0;
          final int newPayMode = data?['pay_mode'] ?? 0;

// 🔥 STORE PREVIOUS VALUES
          final int? oldStatus = _previousOrderStatus;
          final int? oldPayMode = _previousPayMode;

// 🔥 UPDATE CURRENT
          _previousOrderStatus = newStatus;
          _previousPayMode = newPayMode;

          setState(() {
            orderData = data;
            isLoading = false;
          });

          print("🟡 OLD STATUS = $oldStatus → NEW STATUS = $newStatus");
          print("🟡 OLD PAYMODE = $oldPayMode → NEW PAYMODE = $newPayMode");
          _updateMapMarkers();
          _calculateETA();

          final int orderStatus = data?['order_status'] ?? 0;
          final int payMode = data?['pay_mode'] ?? 0;

          print("🔥 DRIVER LISTENER");
          print("➡️ orderStatus = $orderStatus");
          print("➡️ payMode = $payMode");
          print("➡️ navigated = $_navigatedToPaymentScreen");

          if (oldStatus != 4 && newStatus == 4) {
            _goToPaymentFlow();
          }

          if (newStatus == 4 &&
              oldPayMode != null &&
              oldPayMode != newPayMode) {

            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;

              print("🔁 SWITCH PAYMENT SCREEN: $oldPayMode → $newPayMode");

              final amount = _getPayableAmount(orderData!);
              final userName = orderData!['user_name'];

              /// 🔥 IMPORTANT: replace current payment screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    if (newPayMode == 1) {
                      /// 💳 ONLINE
                      return WaitingForPaymentScreen(
                        orderId: widget.orderId,
                        amount: amount,
                        userName: userName,
                      );
                    }

                    else if (newPayMode == 2) {
                      /// 💵 CASH
                      return CollectCashScreen(
                        orderId: widget.orderId,
                        amount: amount,
                        userName: userName,
                      );
                    }

                    else {
                      /// 👛 WALLET
                      return CollectByWalletScreen(
                        orderId: widget.orderId,
                        amount: amount,
                        userName: userName,
                      );
                    }
                  },
                ),
              );
            });
          }

          bool _finalHandled = false;

          if (newStatus == 5 && !_finalHandled) {
            _finalHandled = true;

            debugPrint("🔥 STATUS 5 FINAL | payMode = $newPayMode");

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (!mounted) return;

              if (Navigator.of(context, rootNavigator: true).canPop()) {
                Navigator.of(context, rootNavigator: true).pop();
              }

              await Future.delayed(const Duration(milliseconds: 300));
              if (!mounted) return;

              if (newPayMode == 2) {
                _showRideCompletedPopup();
              } else if (newPayMode == 1) {
                _showPaymentSuccessPopup();
              } else if (newPayMode == 3) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => DriverHomePage()),
                      (_) => false,
                );
              }
            });
          }
          if (oldStatus != 6 && newStatus == 6) {
            _showUserCancelledPopup();
            return;
          }


        }
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showUserCancelledPopup() {
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cancel,
                      size: 42,
                      color: Colors.red,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Ride Cancelled",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "User has cancelled this ride",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const DriverHomePage()),
                              (route) => false,
                        );
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }


  void _goToPaymentFlow() {
    final payMode = orderData!['pay_mode'] ?? 1;
    final walletApply = orderData!['wallet_apply'] ?? 0;
    final amount = _getPayableAmount(orderData!);

    if (_navigatedToPaymentScreen) return;
    _navigatedToPaymentScreen = true;

    print("🚗 GOING TO PAYMENT FLOW");

    Future.microtask(() {
      if (!mounted) return;

      if (payMode == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WaitingForPaymentScreen(
              orderId: widget.orderId,
              amount: amount,
              userName: orderData!['user_name'],
            ),
          ),
        );
      }
      else if (payMode == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CollectCashScreen(
              orderId: widget.orderId,
              amount: amount,
              userName: orderData!['user_name'],
            ),
          ),
        );
      }
      else if (payMode == 3 && walletApply == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CollectByWalletScreen(
              orderId: widget.orderId,
              amount: amount,
              userName: orderData!['user_name'],
            ),
          ),
        );
      }
    });
  }


  void _showPaymentSuccessPopup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return Dialog(
            backgroundColor: AppColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 60,
                      color: Colors.orange,
                    ),
                  ),

                  const SizedBox(height: 20),

                   TextConst(
                     title:
                    "Payment Successful",
                     size: 18,
                     fontWeight: FontWeight.w700,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Customer has completed the payment",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: AppFonts.kanitReg,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => DriverHomePage()),
                            (route) => false,
                      );
                    },
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }


  double _getPayableAmount(Map<String, dynamic> orderData) {
    final int payMode = orderData['pay_mode'] ?? 1;
    final int walletApply = orderData['wallet_apply'] ?? 0;

    if ((payMode == 1 && walletApply == 1) ||
        (payMode == 3 && walletApply == 1)) {
      return (orderData['amount_after_wallet'] ?? 0).toDouble();
    }

    return (orderData['final_amount'] ?? 0).toDouble();
  }


  void _handleRideCompletion() {
    if (!mounted) return;

    final int payMode = orderData?['pay_mode'] ?? 1;
    final int walletApply = orderData?['wallet_apply'] ?? 0;
    final double amount = _getPayableAmount(orderData!);

    print("➡️ HANDLE COMPLETION FIXED");

    /// 🔥 VERY IMPORTANT
    _orderSubscription?.cancel();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final navigator = Navigator.of(context, rootNavigator: true);

      if (payMode == 1) {
        print("✅ PUSH WaitingForPaymentScreen");
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (_) => WaitingForPaymentScreen(
              orderId: widget.orderId,
              amount: amount,
              userName: orderData!['user_name'],
            ),
          ),
        );
      }
      else if (payMode == 2) {
        print("✅ PUSH CollectCashScreen");
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (_) => CollectCashScreen(
              orderId: widget.orderId,
              amount: amount,
              userName: orderData!['user_name'],
            ),
          ),
        );
      }
      else if (payMode == 3 && walletApply == 1) {
        print("✅ PUSH CollectByWalletScreen");
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (_) => CollectByWalletScreen(
              orderId: widget.orderId,
              amount: amount,
              userName: orderData!['user_name'],
            ),
          ),
        );
      }
    });
  }






  void _showRideCompletedPopup() {
    if (_rideCompletedDialogShown) return;
    _rideCompletedDialogShown = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Dialog(
            backgroundColor: AppColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 60,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 20),

                   TextConst(
                     title:
                    "Ride Completed",
                     size: 18,
                     fontWeight: FontWeight.w700,
                  ),

                  const SizedBox(height: 8),

                  const TextConst(
                    title:
                    "Thank you for riding with us",
                    textAlign: TextAlign.center,
                    size: 14,
                    color: Colors.black54,
                  ),

                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => DriverHomePage()),
                            (route) => false,
                      );
                    },
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.kanitReg,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }


  void _updateMapMarkers() {
    if (orderData == null) return;

    final int orderStatus = orderData!['order_status'] ?? 1;

    final pickup = LatLng(
      orderData!['pickup_latitude'],
      orderData!['pickup_longitude'],
    );

    final drop = LatLng(
      orderData!['drop_latitude'],
      orderData!['drop_longitude'],
    );

    final driver = LatLng(widget.driverLat, widget.driverLng);

    if (orderStatus == 3) {
      /// PICKUP ➝ DROP
      markers = {
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickup,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
        Marker(
          markerId: const MarkerId('drop'),
          position: drop,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      };

      _drawRoutePolyline(
        origin: pickup,
        destination: drop,
      );
    } else {
      /// DRIVER ➝ PICKUP
      markers = {
        Marker(
          markerId: const MarkerId('driver'),
          position: driver,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        ),
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickup,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      };

      _drawRoutePolyline(
        origin: driver,
        destination: pickup,
      );
    }

    setState(() {});
  }

  Future<void> _drawRoutePolyline({
    required LatLng origin,
    required LatLng destination,
  }) async {
    const String googleApiKey = "AIzaSyCm7ErTUTWLiTIT9KvG9bziUokOEt5wCBI";
    final String url =
        "https://maps.googleapis.com/maps/api/directions/json"
        "?origin=${origin.latitude},${origin.longitude}"
        "&destination=${destination.latitude},${destination.longitude}"
        "&mode=driving"
        "&key=$googleApiKey";

    try {
      final response = await Uri.parse(url).resolveUri(Uri());
      final result = await NetworkAssetBundle(response).load("");

      final decoded = String.fromCharCodes(result.buffer.asUint8List());
      final data = jsonDecode(decoded);

      if (data['routes'] == null || data['routes'].isEmpty) return;

      final String encodedPolyline =
      data['routes'][0]['overview_polyline']['points'];

      final List<LatLng> polylinePoints = _decodePolyline(encodedPolyline);

      setState(() {
        polylines = {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylinePoints,
            color: AppColor.royalBlue,
            width: 5,
          ),
        };
      });
    } catch (e) {
      debugPrint("❌ Polyline error: $e");
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      // Latitude
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      // Longitude
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }


  Future<void> _openNavigator() async {
    if (orderData == null) return;

    final int orderStatus = orderData!['order_status'] ?? 1;

    if (orderStatus == 3) {
      // Navigate from pickup to drop
      final pickupLat = orderData!['pickup_latitude'];
      final pickupLng = orderData!['pickup_longitude'];
      final dropLat = orderData!['drop_latitude'];
      final dropLng = orderData!['drop_longitude'];

      final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=$pickupLat,$pickupLng&destination=$dropLat,$dropLng&travelmode=driving',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } else {
      // Navigate from driver to pickup
      final pickupLat = orderData!['pickup_latitude'];
      final pickupLng = orderData!['pickup_longitude'];

      final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&origin=${widget.driverLat},${widget.driverLng}&destination=$pickupLat,$pickupLng&travelmode=driving',
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _verifyOtp(ChangeCabOrderStatusViewModel cabOrderStatusVm) async {
    if (isVerifyingOtp) return;

    if (_otpController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid OTP")),
      );
      return;
    }

    setState(() => isVerifyingOtp = true);

    await cabOrderStatusVm.changeCabOrderApi(
      orderData!['order_id'],
      3,
      _otpController.text,
      "",
      context,
    );

    setState(() => isVerifyingOtp = false);
  }

  Future<void> _completeRide(ChangeCabOrderStatusViewModel cabOrderStatusVm) async {
    if (isCompletingRide) return;

    setState(() => isCompletingRide = true);

    await cabOrderStatusVm.changeCabOrderApi(
      orderData!['order_id'],
      4,
      "",
      "",
      context,
    );

    setState(() => isCompletingRide = false);
  }

  String _getStatusText() {
    final int orderStatus = orderData?['order_status'] ?? 1;
    final String userName = orderData?['user_name'] ?? 'User';

    switch (orderStatus) {
      case 1:
        return "$userName waiting at pickup point";
      case 2:
        return "Arrived at pickup";
      case 3:
        return "OTP verified - Ride started";
      case 4:
        return "Ride completed";
      default:
        return "$userName waiting at pickup point";
    }
  }

  Color _getStatusColor() {
    final int orderStatus = orderData?['order_status'] ?? 1;

    switch (orderStatus) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  bool _shouldShowNavigateButton() {
    final int orderStatus = orderData?['order_status'] ?? 1;
    return orderStatus == 1 || orderStatus == 3;
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

    final cabOrderStatusVm = Provider.of<ChangeCabOrderStatusViewModel>(context);

    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// ICON
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: AppColor.royalBlue.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_outline,
                        color: AppColor.royalBlue,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// MESSAGE
                     TextConst(
                       title:
                      "Ride in progress",
                       size: 16,
                       fontWeight: FontWeight.w600,
                    ),

                    const SizedBox(height: 6),

                     TextConst(
                       title:
                      "Please complete the ride before going back.",
                      textAlign: TextAlign.center,
                       size: 13,
                       color: Colors.black54,
                    ),

                    const SizedBox(height: 18),

                    /// SMALL CONTAINER BUTTON
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColor.royalBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "OK",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        return false;
      },


      child: Scaffold(
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
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.5),
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
              child: Column(
                children: [
                  /// Back Button + Distance
                  Row(
                    children: [
                      GestureDetector(

                        child: Container(
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
                            onPressed: () {
                              // 🔥 Block manual back during ride
                            Utils.showErrorMessage(context, "Back disabled during active ride");
                            },
                            padding: EdgeInsets.zero,
                            iconSize: 18,
                          ),
                        ),
                      ),

                      SizedBox(width: 12),

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

                  SizedBox(height: 12),

                  /// ✅ STATUS TEXT
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _getStatusColor(),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _getStatusText(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// ================= BOTTOM SHEET =================
            DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.34,
              maxChildSize: 0.75,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    physics: const ClampingScrollPhysics(),
                    children: [
                      /// DRAG HANDLE
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      /// USER INFO
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
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
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextConst(
                                    title: orderData!['user_name'] ?? 'Customer',
                                    size: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(height: 3),
                                  TextConst(
                                    title: 'Order #${widget.orderId}',
                                    size: 13,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.royalBlue,
                                    AppColor.royalBlue.withOpacity(0.7),
                                  ],
                                ),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.phone, size: 18),
                                color: Colors.white,
                                padding: EdgeInsets.zero,
                                onPressed: () => _makePhoneCall(
                                  orderData!['user_mobile'].toString(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// RIDE INFO
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _infoItem(
                                    icon: Icons.location_on_outlined,
                                    title: 'Distance',
                                    value: "${orderData!['distance_km'] ?? 0} km",
                                    color: Colors.blue,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 30,
                                  color: Colors.grey.shade300,
                                ),
                                Expanded(
                                  child: _infoItem(
                                    icon: Icons.currency_rupee,
                                    title: 'Amount',
                                    value: "₹${_getPayableAmount(orderData!)}",
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            _locationRow(
                              icon: Icons.circle,
                              iconColor: Colors.green,
                              iconBgColor: Colors.green.withOpacity(0.1),
                              title: 'Pickup',
                              address: orderData!['pickup_location'] ?? 'N/A',
                              showDivider: true,
                            ),

                            const SizedBox(height: 12),

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

                      const SizedBox(height: 20),

                      /// ACTION SECTION
                      if (orderData!['order_status'] == 1) ...[
                        /// Status 1: I'm Here Button
                        CustomButton(
                          bgColor: AppColor.royalBlue,
                          title: "I'm Here",
                          onTap: () {
                            cabOrderStatusVm.changeCabOrderApi(
                              orderData!['order_id'],
                              2,
                              "",
                              "",
                              context,
                            );
                          },
                        ),
                      ] else if (orderData!['order_status'] == 2) ...[
                        /// Status 2: OTP Verify Widget
                        _otpVerifyWidget(cabOrderStatusVm),
                      ] else if (orderData!['order_status'] == 3) ...[
                        /// Status 3: Complete Ride Button
                        GestureDetector(
                          onTap: isCompletingRide
                              ? null
                              : () => _completeRide(cabOrderStatusVm),
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isCompletingRide
                                  ? Colors.green.withOpacity(0.5)
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: isCompletingRide
                                ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Completing...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                                : const Text(
                              "Reached Destination",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (orderData!['order_status'] == 1 || orderData!['order_status'] == 2) ...[
                        SizedBox(height: 15,),
                        GestureDetector(
                          onTap: () {
                            _showCancelReasonBottomSheet(context);
                          },
                          child: Container(
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.red,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: const Text(
                              "Cancel Ride",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 10,
                      ),


                    ],
                  ),
                );
              },
            ),

            /// ================= NAVIGATION BUTTON (Conditional) =================
            if (_shouldShowNavigateButton())
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.40 + 20,
                right: 16,
                child: Column(
                  children: [
                    if (orderData!['order_status'] == 3)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          "Navigate to Drop",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.royalBlue,
                          ),
                        ),
                      ),
                    if (orderData!['order_status'] == 3) SizedBox(height: 8),
                    Container(
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
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCancelReasonBottomSheet(BuildContext context) {
    String? selectedReason;
    int? selectedReasonId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Consumer<CabCancelReasonViewModel>(
                builder: (context, vm, _) {
                  final reasons = vm.cabCancelReasonModel?.data ?? [];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Cancel Ride",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const TextConst(
                        title:
                        "Please tell us why you want to cancel?",
                      ),
                      const SizedBox(height: 18),

                      /// LOADER
                      if (vm.loading)
                        const Center(child: CircularProgressIndicator()),

                      /// EMPTY STATE
                      if (!vm.loading && reasons.isEmpty)
                        const Center(
                          child: Text("No cancel reasons available"),
                        ),

                      /// LIST
                      if (reasons.isNotEmpty)
                        ...reasons.map((e) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedReason = e.reasonTitle;
                                selectedReasonId = e.id;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selectedReasonId == e.id
                                            ? Colors.red
                                            : Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                    child: selectedReasonId == e.id
                                        ? Center(
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      e.reasonTitle,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),

                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedReasonId != null
                                ? Colors.red
                                : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: selectedReasonId == null
                              ? null
                              : () {
                            Navigator.pop(context);
                            _confirmRideCancellation(
                              selectedReasonId!,
                              selectedReason!,
                            );
                          },
                          // _confirmRideCancellation(selectedReasonId!, selectedReason!);
                          child: const Text(
                            "Confirm Cancel",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void _confirmRideCancellation(int reasonId, String reasonTitle) async {
    if (!mounted) return;

    final changeStatusVm = Provider.of<ChangeCabOrderStatusViewModel>(
      context,
      listen: false,
    );

    // API call
    await changeStatusVm.changeCabOrderApi(
      widget.orderId,
      7, // Cancel status
      "",
      reasonTitle,
      context,
    );

    // After successful cancel → Ride screen close
    // Firebase listener bhi close hoga
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => DriverHomePage()),
          (_) => false,
    );
  }



  /// =====================================================
  /// HELPER WIDGETS
  /// =====================================================

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextConst(
                    title: title,
                    size: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 4),
                  TextConst(
                    title: address,
                    size: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
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

  Widget _otpVerifyWidget(ChangeCabOrderStatusViewModel cabOrderStatusVm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.royalBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.royalBlue.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter Ride OTP",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          /// OTP FIELD
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: InputDecoration(
              hintText: "Enter OTP",
              counterText: "",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColor.royalBlue),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// VERIFY BUTTON
          InkWell(
            onTap: isVerifyingOtp
                ? null
                : () {
              _verifyOtp(cabOrderStatusVm);
            },
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isVerifyingOtp
                    ? AppColor.royalBlue.withOpacity(0.5)
                    : AppColor.royalBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                isVerifyingOtp ? "Verifying..." : "Verify OTP",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =====================================================
/// WAITING FOR PAYMENT SCREEN
/// =====================================================

class WaitingForPaymentScreen extends StatefulWidget {
  final int orderId;
  final dynamic amount;
  final String userName;

  const WaitingForPaymentScreen({
    super.key,
    required this.orderId,
    required this.amount,
    required this.userName,
  });

  @override
  State<WaitingForPaymentScreen> createState() =>
      _WaitingForPaymentScreenState();
}

class _WaitingForPaymentScreenState extends State<WaitingForPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// ICON WITH LOADER
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 60,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        height: 110,
                        width: 110,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// TITLE
                TextConst(
                  title: "Waiting for Payment",
                  textAlign: TextAlign.center,
                  size: 22,
                  fontWeight: FontWeight.bold,
                ),

                const SizedBox(height: 10),

                /// SUB TITLE
                TextConst(
                  title: "Waiting for ${widget.userName} to complete payment",
                  textAlign: TextAlign.center,
                  size: 16,
                  color: Colors.grey,
                ),

                const SizedBox(height: 36),

                /// AMOUNT CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withOpacity(0.1),
                        Colors.orange.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const TextConst(title: "Amount"),
                      const SizedBox(height: 8),
                      Text(
                        "₹${widget.amount}",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Order #${widget.orderId}",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                /// WAITING TEXT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Please wait...",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/// =====================================================
/// COLLECT CASH SCREEN
/// =====================================================
class CollectCashScreen extends StatefulWidget {
  final int orderId;
  final dynamic amount;
  final String userName;

  const CollectCashScreen({
    super.key,
    required this.orderId,
    required this.amount,
    required this.userName,
  });

  @override
  State<CollectCashScreen> createState() => _CollectCashScreenState();
}

class _CollectCashScreenState extends State<CollectCashScreen> {
  bool isCollected = false;

  @override
  Widget build(BuildContext context) {
    final changeCabOrder = Provider.of<ChangeCabOrderStatusViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// Cash Icon
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 70,
                  color: Colors.green,
                ),
              ),

              SizedBox(height: 32),

              TextConst(
                title:
                "Collect Cash Payment",
                size: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),

              SizedBox(height: 12),

              TextConst(
                title:
                "Collect cash from $widget.userName",
                textAlign: TextAlign.center,
                size: 15,
                color: Colors.grey.shade600,
              ),

              SizedBox(height: 40),

              /// Amount Card
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.1),
                      Colors.green.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      "Amount to Collect",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "₹${widget.amount}",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Order #${widget.orderId}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 50),

              SlideToButton(
                title: "Collect Cash",
                onAccepted: () async {
                  await changeCabOrder.changeCabOrderApi(
                    widget.orderId,
                    5,
                    "",
                    "",
                    context,
                  );
                  // Navigator.pop(context);
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class CollectByWalletScreen extends StatelessWidget {
  final int orderId;
  final double amount;
  final String userName;

  const CollectByWalletScreen({
    super.key,
    required this.orderId,
    required this.amount,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 70,
                  color: Colors.purple,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Wallet Payment",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "$userName paid via wallet",
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.purple.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Text("Amount Received"),
                    const SizedBox(height: 8),
                    Text(
                      "₹$amount",
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .popUntil((route) => route.isFirst);
                },
                child: const Text("Done"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
