import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/animated_gradient_border.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_earning_view_model.dart';
import 'package:rainbow_partner/model/cab_earning_model.dart';

class DailyWeeklyEarningReport extends StatefulWidget {
  const DailyWeeklyEarningReport({super.key});

  @override
  State<DailyWeeklyEarningReport> createState() =>
      _DailyWeeklyEarningReportState();
}

class _DailyWeeklyEarningReportState extends State<DailyWeeklyEarningReport> {
  int _selectedTab = 0; // 0 = Today, 1 = Weekly

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<CabEarningViewModel>();
      vm.clearEarningData();
      vm.cabEarningApi("2", context); // ✅ Today
    });
  }

  void _onTabChange(int index) {
    setState(() => _selectedTab = index);

    final vm = context.read<CabEarningViewModel>();
    vm.clearEarningData();

    vm.cabEarningApi(
      index == 0 ? "2" : "3", // Today / Weekly
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CabEarningViewModel>();

    if (vm.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final Data? data = vm.cabEarningModel?.data;

    // -------- ZERO MODE LOGIC --------
    final hasTrips = data?.tripDetails?.isNotEmpty ?? false;


    final totalEarning =
    hasTrips ? (data?.totalEarning ?? 0).toDouble() : 0.0;


    final totalTrips =
    hasTrips ? (data?.totalCompletedRide ?? 0) : 0;
    final hours =
    hasTrips ? (data?.onlineTime?.hours ?? 0) : 0;

    final minutes =
    hasTrips ? (data?.onlineTime?.minutes ?? 0) : 0;

    final List<TripDetails> completedTrips = hasTrips
        ? (data!.tripDetails ?? [])
        .where((e) => e.orderStatus == 5)
        .toList()
        : [];

    return Scaffold(
      backgroundColor: AppColor.whiteDark,
      appBar: AppBar(
        backgroundColor: AppColor.royalBlue,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: AppColor.white,)),
        title: const TextConst(
          title: "Earnings Report",
          size: 17,
          fontWeight: FontWeight.w700,
          color: AppColor.white,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildTabSelector(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _buildEarningsCard(total: totalEarning),
                  const SizedBox(height: 16),
                  _buildStatsGrid(
                    totalTrips: totalTrips,
                    hours: hours,
                    minutes: minutes,
                  ),
                  const SizedBox(height: 20),
                  _buildTripDetails(completedTrips),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- TAB SELECTOR ----------------

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _tabButton(
              "Today",
              _selectedTab == 0,
                  () => _onTabChange(0),
            ),
          ),
          Expanded(
            child: _tabButton(
              "Weekly",
              _selectedTab == 1,
                  () => _onTabChange(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
            colors: [
              AppColor.royalBlue,
              AppColor.royalBlue.withOpacity(0.85),
            ],
          )
              : null,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextConst(
          title: text,
          textAlign: TextAlign.center,
          color: selected ? Colors.white : Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ---------------- EARNINGS CARD ----------------

  Widget _buildEarningsCard({required double total}) {
    return AnimatedGradientBorder(
      borderSize: 2,
      glowSize: 0,
      gradientColors: [
        AppColor.royalBlue,
        Colors.transparent,
        AppColor.royalBlue,
      ],
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: Sizes.screenWidth,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Text("Total Earnings"),
            const SizedBox(height: 8),
            Text(
              "₹${total.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- STATS ----------------

  Widget _buildStatsGrid({
    required int totalTrips,
    required int hours,
    required int minutes,
  }) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _statCard(
          "Trips Completed",
          "$totalTrips",
          Icons.local_taxi,
          Colors.blue,
        ),
        _statCard(
          "Online Hours",
          "${hours}h ${minutes}m",
          Icons.timer,
          Colors.green,
        ),
      ],
    );
  }

  Widget _statCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // ---------------- TRIP LIST ----------------

  Widget _buildTripDetails(List<TripDetails> trips) {
    if (trips.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: Text(
            "No trips found",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Trip Details",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...trips.map(_buildTripItem),
      ],
    );
  }

  // ---------------- SINGLE TRIP CARD ----------------

  Widget _buildTripItem(TripDetails trip) {
    final double distance =
    (trip.distanceKm is num) ? (trip.distanceKm as num).toDouble() : 0.0;

    final double amount =
    (trip.finalAmount is num) ? (trip.finalAmount as num).toDouble() : 0.0;

    final bool isOnline = trip.payMode == 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trip #${trip.id ?? "-"}",
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isOnline
                      ? Colors.green.withOpacity(0.12)
                      : Colors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isOnline ? "ONLINE" : "CASH",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isOnline ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(Icons.circle, size: 12, color: Colors.green),
                  Container(height: 30, width: 1, color: Colors.grey.shade300),
                  Icon(Icons.location_on, size: 16, color: Colors.red),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Pickup",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600)),
                    Text(trip.pickupLocation ?? "-",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    const Text("Drop",
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600)),
                    Text(trip.dropLocation ?? "-",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${distance.toStringAsFixed(1)} km",
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(
                "₹${amount.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
