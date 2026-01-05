import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/animated_gradient_border.dart';
import 'package:rainbow_partner/res/app_color.dart';
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
      context.read<CabEarningViewModel>().cabEarningApi("1", context);
    });
  }

  void _onTabChange(int index) {
    setState(() => _selectedTab = index);
    context
        .read<CabEarningViewModel>()
        .cabEarningApi(index == 0 ? "1" : "2", context);
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

    if (data == null) {
      return const Scaffold(
        body: Center(child: Text("No earning data")),
      );
    }

    /// ---- CALCULATIONS ----
    double onlineAmount = 0;
    double cashAmount = 0;

    final completedTrips = (data.tripDetails ?? [])
        .where((e) => e.orderStatus == 5)
        .toList();

    for (var t in completedTrips) {
      final amt = double.tryParse(t.finalAmount ?? "0") ?? 0;
      if (t.payMode == 1) {
        onlineAmount += amt;
      } else if (t.payMode == 2) {
        cashAmount += amt;
      }
    }

    return Scaffold(
      backgroundColor: AppColor.whiteDark,
      appBar: AppBar(
        backgroundColor: AppColor.royalBlue,
        title: const TextConst(
          title: "Earnings Report",
          size: 17,
          fontWeight: FontWeight.w700,
          color: AppColor.white,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildTabSelector(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _buildEarningsCard(
                    total: data.totalEarning ?? 0,
                    online: onlineAmount,
                    cash: cashAmount,
                  ),
                  const SizedBox(height: 16),
                  _buildStatsGrid(data),
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

  // ---------------- TAB ----------------

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _tabButton("Today", _selectedTab == 0, () => _onTabChange(0)),
          ),
          Expanded(
            child:
            _tabButton("Weekly", _selectedTab == 1, () => _onTabChange(1)),
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
              AppColor.royalBlue.withOpacity(0.8),
            ],
          )
              : null,
          borderRadius: BorderRadius.circular(12),
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

  Widget _buildEarningsCard({
    required double total,
    required double online,
    required double cash,
  }) {
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
                  fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _earningType("Cash", cash),
                _earningType("Online", online),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _earningType(String title, double amount) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          "₹${amount.toStringAsFixed(2)}",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // ---------------- STATS ----------------

  Widget _buildStatsGrid(Data data) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _statCard(
          "Trips Completed",
          "${data.totalCompletedRide ?? 0}",
          Icons.directions_car,
          Colors.blue,
        ),
        _statCard(
          "Online Hours",
          "${data.onlineTime?.hours ?? 0}h ${data.onlineTime?.minutes ?? 0}m",
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // ---------------- TRIPS ----------------

  Widget _buildTripDetails(List<TripDetails> trips) {
    if (trips.isEmpty) {
      return const Center(child: Text("No trips found"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Trip Details",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...trips.map(_buildTripItem),
      ],
    );
  }

  Widget _buildTripItem(TripDetails trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Trip #${trip.id}",
              style:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 6),
          Text(trip.pickupLocation ?? ""),
          Text(trip.dropLocation ?? ""),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${trip.distanceKm} km"),
              Text(
                "₹${trip.finalAmount}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(trip.payMode == 1 ? "Online" : "Cash",
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}
