import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/view/Cab%20Driver/action/driver_profile.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: const Color(0xffF4F6FA),

        body: SingleChildScrollView(
          child: Column(
            children: [

              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: topPadding + 15,
                      bottom: 40,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.royalBlue,
                          AppColor.royalBlue.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 48,
                            color: AppColor.royalBlue,
                          ),
                        ),

                        const SizedBox(width: 18),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            TextConst(
                              title: "Welcome back 👋",
                              size: 15,
                              color: Colors.white70,
                            ),
                            SizedBox(height: 5),
                            TextConst(
                              title: "Driver John Doe",
                              size: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// ONLINE INDICATOR
                  Positioned(
                    right: 20,
                    bottom: -25,
                    child: _onlineSwitch(),
                  ),
                ],
              ),

              const SizedBox(height: 45),

              // -------------------------------------------------
              //                   STATISTICS SECTION
              // -------------------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    _statsBox("Rides", "05", Icons.local_taxi_rounded),
                    const SizedBox(width: 12),
                    _statsBox("Earnings", "₹ 540", Icons.payments_rounded),
                    const SizedBox(width: 12),
                    _statsBox("Distance", "12 km", Icons.route_rounded),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // -------------------------------------------------
              //                  ACTIVE RIDE BOX
              // -------------------------------------------------
              _activeRideCard(),

              const SizedBox(height: 30),

              // -------------------------------------------------
              //                    QUICK ACTIONS
              // -------------------------------------------------
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextConst(
                    title: "Quick Actions",
                    size: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 0.82,
                  children: [
                    _actionItem(Icons.person, "Profile",onTap: (){
                      print("tapped");
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverProfile()));
                    }),
                    _actionItem(Icons.account_balance_wallet, "Wallet"),
                    _actionItem(Icons.history_rounded, "History"),
                    _actionItem(Icons.star_rate_rounded, "Ratings"),
                    _actionItem(Icons.support_agent_rounded, "Support"),
                    _actionItem(Icons.settings_rounded, "Settings"),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------
  //              ONLINE / OFFLINE SWITCH
  // -------------------------------------------------
  Widget _onlineSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: AppColor.royalBlue.withOpacity(0.18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          TextConst(
            title: isOnline ? "Online" : "Offline",
            size: 14,
            color: isOnline ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(width: 8),
          CupertinoSwitch(
            value: isOnline,
            activeColor: Colors.green,
            onChanged: (v) => setState(() => isOnline = v),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------
  //                     STATS BOX
  // -------------------------------------------------
  Widget _statsBox(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColor.royalBlue.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: AppColor.royalBlue),
            const SizedBox(height: 8),
            TextConst(title: title, size: 13, color: Colors.black54),
            const SizedBox(height: 4),
            TextConst(
              title: value,
              size: 18,
              color: AppColor.royalBlue,
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------
  //                ACTIVE RIDE CARD
  // -------------------------------------------------
  Widget _activeRideCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColor.royalBlue.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.royalBlue.withOpacity(0.12),
              ),
              child: Icon(
                Icons.location_searching_rounded,
                size: 30,
                color: AppColor.royalBlue,
              ),
            ),

            const SizedBox(width: 18),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                TextConst(
                  title: "No active rides",
                  size: 17,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 4),
                TextConst(
                  title: "Waiting for new ride requests",
                  size: 14,
                  color: Colors.black54,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------
  //                QUICK ACTION ITEM
  // -------------------------------------------------
  Widget _actionItem(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 63,
            width: 63,
            decoration: BoxDecoration(
              color: AppColor.royalBlue.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: AppColor.royalBlue),
          ),
          const SizedBox(height: 8),
          TextConst(
            title: label,
            size: 14,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

}
