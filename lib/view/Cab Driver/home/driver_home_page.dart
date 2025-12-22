import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/view/Cab%20Driver/action/driver_profile.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/ride%20history/cab_ride_history.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/schedule/schedule_ride_card.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/wallet/add_bank.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/wallet/cab_bank_update_status.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/wallet/wallet_and_settlement.dart';
import 'package:rainbow_partner/view/Cab%20Driver/ride_waiting_screen.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/driver_online_status_view_model.dart';

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
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await hitProfileApi();
    });
  }

  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    final driverProfileVm = Provider.of<DriverProfileViewModel>(context);
    final data = driverProfileVm.driverProfileModel?.data;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,

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
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: (data?.profilePhoto != null &&
                              data!.profilePhoto.toString().isNotEmpty)
                              ? NetworkImage(data.profilePhoto.toString())
                              : null,
                          child: (data?.profilePhoto == null ||
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
                          children:  [
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
                    _statsBox("Rides", "05", Icons.local_taxi_rounded),

                  const SizedBox(width: 12),
                  _statsBox("Earnings", "₹ 540", Icons.payments_rounded,
                  onTap: (){
                    Navigator.push(context, CupertinoPageRoute(builder: (context)=> DailyWeeklyEarningReport()));

                  }
                  ),
                    const SizedBox(width: 12),
                    _statsBox("Distance", "12 km", Icons.route_rounded),
                  ],
                ),
              ),

              const SizedBox(height: 17),


              _activeRideCard(),
              _scheduledRideCard(context),

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
                    _actionItem(Icons.person, "Profile",onTap: (){
                      print("tapped");
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> DriverProfile()));
                    }),
                    _actionItem(Icons.account_balance_wallet, "Wallet Settlemant",onTap: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> WalletSettlement()));
                    }),
                    _actionItem(Icons.account_balance, "Add Bank",onTap: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> AddBank()));
                    }),
                    _actionItem(Icons.account_balance_outlined, "Bank Update Status",onTap: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> CabBanUpdateStatus()));
                    }),
                    _actionItem(Icons.local_taxi, "Ride History",onTap: (){
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> CabRideHistory()));
                    }),
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
    final driverOnlineVm =
    Provider.of<DriverOnlineStatusViewModel>(context, listen: false);

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
            onChanged: (value) async {
              setState(() => isOnline = value);

              int status = value ? 1 : 0;

              final position = await LocationUtils.getLocation();
              driverOnlineVm.driverOnlineStatusApi(status, position.latitude, position.longitude, context);

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
      ),
    );
  }

  // -------------------------------------------------
  //                ACTIVE RIDE CARD
  // -------------------------------------------------
  Widget _activeRideCard() {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (context)=> RideWaitingScreen()));
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
      ),
    );
  }

  Widget _scheduledRideCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScheduledRideCard(
                userName: "Rajesh Kumar",
                userMobile: "+91 98765 43210",
                pickup: "Gomti Nagar",
                drop: "Indira Nagar, Lucknow",
                distance: 8.5,
                fare: 180.0,
                scheduledTime: DateTime(2025, 9, 25, 8, 30),
                status: RideStatus.scheduled,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ICON
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.schedule_rounded,
                  size: 28,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(width: 16),

              /// CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextConst(
                      title: "Scheduled Ride",
                      size: 16,
                      fontWeight: FontWeight.w700,
                    ),

                    const SizedBox(height: 4),

                    TextConst(
                      title: DateFormat('dd MMM • hh:mm a')
                          .format(DateTime(2025, 9, 25, 8, 30)),
                      size: 13,
                      color: Colors.black54,
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: const [
                        Icon(Icons.place, size: 16, color: Colors.green),
                        SizedBox(width: 6),
                        Expanded(
                          child: TextConst(
                            title: "Gomti Nagar → Indira Nagar",
                            size: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// STATUS
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const TextConst(
                  title: "UPCOMING",
                  size: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.orange,
                ),
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
