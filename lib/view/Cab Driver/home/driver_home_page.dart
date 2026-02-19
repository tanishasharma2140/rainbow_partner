import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/service/background_service.dart';
import 'package:rainbow_partner/service/driver_socket_service.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/action/driver_profile.dart';
import 'package:rainbow_partner/view/Cab%20Driver/driver_setting.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/driver_accepted_scree.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/ride%20history/cab_ride_history.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/wallet/add_bank.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/wallet/cab_bank_update_status.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/wallet/wallet_and_settlement.dart';
import 'package:rainbow_partner/view/Cab%20Driver/ride_waiting_screen.dart';
import 'package:rainbow_partner/view_model/cabdriver/active_ride_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_earning_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/driver_online_status_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';
import 'earning report/daily_weekly_earning_report.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  Future<void> hitProfileApi() async {
    final vm = Provider.of<DriverProfileViewModel>(context, listen: false);
    final position = await LocationUtils.getLocation();

    await vm.driverProfileApi(
      position.latitude.toString(),
      position.longitude.toString(),
      context,
    );
    final activeRide = await Provider.of<ActiveRideViewModel>(
      context,
      listen: false,
    ).activeRideApi();

    if (activeRide != null && mounted) {
      final position = await LocationUtils.getLocation();
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => DriverRideAcceptedScreen(
            orderId: activeRide["order_id"],
            orderStatus: activeRide["order_status"],
            driverLat: position.latitude,
            driverLng: position.longitude,
          ),
        ),
      );
    }
    final cabEarning = Provider.of<CabEarningViewModel>(context, listen: false);
    cabEarning.cabEarningApi("1", context);
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await hitProfileApi();
    });
  }

  bool isOnline = false;

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 260,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   TextConst(
                     title:
                    "Exit App",
                     size: 17,
                     fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 10),
                   TextConst(
                     title:
                    "Are you sure you want to exit?",
                    textAlign: TextAlign.center,
                     size: 14,
                     color: Colors.black54,
                  ),
                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pop(context); // dialog close
                            await _handleExit();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColor.royalBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Exit",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: AppFonts.kanitReg,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ) ?? false;
  }

  Future<void> _startSocket() async {
    final userViewModel = UserViewModel();

    String? driverId = await userViewModel.getUser();

    if (driverId == null || driverId == 0) {
      debugPrint("❌ Driver ID not found, socket not started");
      return;
    }

    debugPrint("✅ Starting socket with driverId: $driverId");

    // Background service start
    initializeBackgroundService();

  }

  Future<void> _handleExit() async {
    final driverOnlineVm =
    Provider.of<DriverOnlineStatusViewModel>(context, listen: false);

    try {
      // 🔥 Make driver offline
      await driverOnlineVm.driverOnlineStatusApi(
        0, // offline
        0.0,
        0.0,
        context,
      );
    } catch (e) {
      debugPrint("Offline API error: $e");
    }

    // 🔌 Disconnect socket
    DriverSocketService().disconnect();

    // 📴 Stop background service
    await stopBackgroundService();

    // 🚪 Close app
    SystemNavigator.pop();
  }



  @override
  Widget build(BuildContext context) {
    final driverProfileVm = Provider.of<DriverProfileViewModel>(context);
    final data = driverProfileVm.driverProfileModel?.data;
    final driverOnlineVm = Provider.of<DriverOnlineStatusViewModel>(context);
    final cabEarningVm = Provider.of<CabEarningViewModel>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          backgroundColor: AppColor.whiteDark,

          body: Stack(
            children: [
              RefreshIndicator(
                color: AppColor.royalBlue,
                onRefresh: () async {
                  await hitProfileApi();
                },
                child: SingleChildScrollView(
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
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage:
                                      (data?.profilePhoto != null &&
                                          data!.profilePhoto.toString().isNotEmpty)
                                      ? NetworkImage(data.profilePhoto.toString())
                                      : null,
                                  child:
                                      (data?.profilePhoto == null ||
                                          data!.profilePhoto.toString().isEmpty)
                                      ? const Icon(
                                          Icons.person,
                                          size: 70,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),

                                const SizedBox(width: 18),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextConst(
                                      title: "Welcome back 👋",
                                      size: 15,
                                      color: Colors.white70,
                                    ),
                                    SizedBox(height: 5),
                                    TextConst(
                                      title:
                                          "${driverProfileVm.driverProfileModel?.data?.firstName ?? ""} "
                                          "${driverProfileVm.driverProfileModel?.data?.lastName ?? ""}",
                                      size: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 20,
                            bottom: -25,
                            child: _onlineSwitch(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 45),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          children: [
                            _statsBox(
                              "Rides",
                              cabEarningVm.cabEarningModel?.data?.totalCompletedRide
                                      .toString() ??
                                  "0",
                              Icons.local_taxi_rounded,
                            ),

                            const SizedBox(width: 12),
                            _statsBox(
                              "Earnings",
                              "₹${cabEarningVm.cabEarningModel?.data?.totalEarning ?? "0"}",
                              Icons.payments_rounded,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        DailyWeeklyEarningReport(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            _statsBox(
                              "Distance",
                              "${cabEarningVm.cabEarningModel?.data?.totalDistance ?? "0"}km",
                              Icons.route_rounded,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 17),

                      if (driverProfileVm.driverProfileModel?.data?.onlineStatus ==
                          1) ...[
                        _activeRideCard(),
                      ],
                      const SizedBox(height: 15),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 0.82,
                          children: [
                            _actionItem(
                              Icons.person,
                              "Profile",
                              onTap: () {
                                print("tapped");
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => DriverProfile(),
                                  ),
                                );
                              },
                            ),
                            _actionItem(
                              Icons.account_balance_wallet,
                              "Wallet Settlemant",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => WalletSettlement(),
                                  ),
                                );
                              },
                            ),
                            _actionItem(
                              Icons.account_balance,
                              "Add Bank",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => AddBank(),
                                  ),
                                );
                              },
                            ),
                            _actionItem(
                              Icons.account_balance_outlined,
                              "Bank Update Status",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => CabBanUpdateStatus(),
                                  ),
                                );
                              },
                            ),
                            _actionItem(
                              Icons.local_taxi,
                              "Ride History",
                              onTap: () {
                                Navigator.push(
                                  context,

                                  CupertinoPageRoute(
                                    builder: (context) => CabRideHistory(),
                                  ),
                                );
                              },
                            ),
                            _actionItem(Icons.settings_rounded, "Settings",
                            onTap: (){
                              Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverSetting()));
                            }
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
              if (driverOnlineVm.loading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      height: Sizes.screenHeight * 0.13,
                      width: Sizes.screenWidth * 0.28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: GradientCirPro(
                          strokeWidth: 6,
                          size: 70,
                          gradient: AppColor.circularIndicator,
                        ),
                      ),
                    ),
                  ),
                ),
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
    final driverProfileVm = Provider.of<DriverProfileViewModel>(context);
    final driverOnlineVm = Provider.of<DriverOnlineStatusViewModel>(
      context,
      listen: false,
    );

    /// 🔥 ONLINE STATUS DIRECT FROM PROFILE
    final bool isOnline =
        driverProfileVm.driverProfileModel?.data?.onlineStatus == 1;

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
          ),
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
            onChanged: (value) async {
              int status = value ? 1 : 0;

              final position = await LocationUtils.getLocation();

              /// 🔥 1️⃣ ONLINE/OFFLINE API
              await driverOnlineVm.driverOnlineStatusApi(
                status,
                position.latitude,
                position.longitude,
                context,
              );

              /// 🔁 2️⃣ PROFILE REFRESH
              await driverProfileVm.driverProfileApi(
                position.latitude.toString(),
                position.longitude.toString(),
                context,
              );

              /// 🔥 3️⃣ SOCKET CONTROL
              if (status == 1) {
                // ✅ ONLINE → START SOCKET
                await _startSocket();
              } else {
                // ❌ OFFLINE → STOP SOCKET
                await stopBackgroundService ();
              }
            },
          ),

        ],
      ),
    );
  }

  // -------------------------------------------------
  //                     STATS BOX
  // -------------------------------------------------
  Widget _statsBox(
    String title,
    String value,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
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
              ),
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
      ),
    );
  }

  // -------------------------------------------------
  //                ACTIVE RIDE CARD
  // -------------------------------------------------
  Widget _activeRideCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => RideWaitingScreen()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                // padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.royalBlue.withOpacity(0.12),
                ),
                child: Image.asset(
                  "assets/ride_ongoing.gif",
                  height: 40,
                  width: 40,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(width: 18),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  TextConst(
                    title: "Ride ongoing",
                    size: 17,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 4),
                  TextConst(
                    title: "You're on duty — drive safely!",
                    size: 14,
                    color: Colors.black54,
                  ),
                ],
              ),
            ],
          ),
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
