import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';

class RideWaitingScreen extends StatefulWidget {
  const RideWaitingScreen({super.key});

  @override
  State<RideWaitingScreen> createState() =>
      _RideWaitingScreenState();
}

class _RideWaitingScreenState extends State<RideWaitingScreen> {
  double currentLat = 26.8467;
  double currentLng = 80.9462;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,

        /// 🔹 APP BAR
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        /// 🔹 BODY
        body: Stack(
          children: [
            /// 🗺 MAP
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(currentLat, currentLng),
                zoom: 15,
              ),
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
            ),

            /// 🔵 CENTER SEARCH ANIMATION
            Align(
              alignment: const Alignment(0, -0.25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.royalBlue.withOpacity(0.12),
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
            ),

            /// ⬇️ BOTTOM SHEET
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 14,
                      offset: Offset(0, -6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// DRAG HANDLE
                    Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 18),

                    /// LOADING BAR
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        minHeight: 6,
                        valueColor: AlwaysStoppedAnimation(
                          AppColor.royalBlue,
                        ),
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// TEXT
                    const TextConst(
                      title: "Waiting for ride requests",
                      size: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(height: 6),
                    const TextConst(
                      title:
                      "You will automatically receive a booking when a customer requests a ride nearby.",
                      size: 14,
                      color: Colors.black54,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
