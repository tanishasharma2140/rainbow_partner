import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/animated_gradient_border.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';

class DailyWeeklyEarningReport extends StatefulWidget {
  const DailyWeeklyEarningReport({super.key});

  @override
  State<DailyWeeklyEarningReport> createState() =>
      _DailyWeeklyEarningReportState();
}

class _DailyWeeklyEarningReportState extends State<DailyWeeklyEarningReport> {
  int _selectedTab = 0; // 0 for Today, 1 for Weekly

  // Static data for Today
  final Map<String, dynamic> todayData = {
    'totalEarnings': '₹1,850',
    'tripsCompleted': 12,
    'onlineHours': '8h 30m',
    'offlineEarnings': '₹1,250',
    'onlineEarnings': '₹600',
    'totalTime': '8h 30m',
    'tripDetails': [
      {
        'id': 'TRIP001',
        'pickup': 'Connaught Place',
        'drop': 'Airport',
        'distance': '18.5 km',
        'amount': 450,
        'time': '10:30 AM',
        'paymentMode': 'Online',
        'status': 'Completed',
      },
      {
        'id': 'TRIP002',
        'pickup': 'Hauz Khas',
        'drop': 'Cyber City',
        'distance': '25.3 km',
        'amount': 620,
        'time': '01:45 PM',
        'paymentMode': 'Cash',
        'status': 'Completed',
      },
      {
        'id': 'TRIP003',
        'pickup': 'Dwarka',
        'drop': 'Rohini',
        'distance': '32.7 km',
        'amount': 780,
        'time': '04:20 PM',
        'paymentMode': 'Online',
        'status': 'Completed',
      },
    ],
  };

  // Static data for Weekly
  final Map<String, dynamic> weeklyData = {
    'totalEarnings': '₹12,750',
    'tripsCompleted': 68,
    'onlineHours': '56h 15m',
    'offlineEarnings': '₹8,500',
    'onlineEarnings': '₹4,250',
    'totalTime': '56h 15m',
    'tripDetails': [
      {
        'id': 'TRIP101',
        'pickup': 'Noida',
        'drop': 'Delhi',
        'distance': '22.1 km',
        'amount': 540,
        'time': 'Mon, 10:30 AM',
        'paymentMode': 'Online',
        'status': 'Completed',
      },
      {
        'id': 'TRIP102',
        'pickup': 'Gurgaon',
        'drop': 'Faridabad',
        'distance': '35.8 km',
        'amount': 850,
        'time': 'Tue, 02:15 PM',
        'paymentMode': 'Cash',
        'status': 'Completed',
      },
      {
        'id': 'TRIP103',
        'pickup': 'Ghaziabad',
        'drop': 'Noida',
        'distance': '28.4 km',
        'amount': 680,
        'time': 'Wed, 11:45 AM',
        'paymentMode': 'Online',
        'status': 'Completed',
      },
      {
        'id': 'TRIP104',
        'pickup': 'Rajouri',
        'drop': 'Dwarka',
        'distance': '42.3 km',
        'amount': 950,
        'time': 'Thu, 04:30 PM',
        'paymentMode': 'Online',
        'status': 'Completed',
      },
      {
        'id': 'TRIP105',
        'pickup': 'Pitampura',
        'drop': 'Connaught Place',
        'distance': '19.7 km',
        'amount': 480,
        'time': 'Fri, 09:15 AM',
        'paymentMode': 'Cash',
        'status': 'Completed',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final data = _selectedTab == 0 ? todayData : weeklyData;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          title:  TextConst(
            title:
            "Earnings Report",
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
                    _buildEarningsCard(data),
                    const SizedBox(height: 16),
                    _buildStatsGrid(data),
                    const SizedBox(height: 20),
                    _buildTripDetails(data),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    return "${now.day}-${_monthName(now.month)}-${now.year}";
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              text: "Today (${_formattedDate()})",
              isSelected: _selectedTab == 0,
              onTap: () => setState(() => _selectedTab = 0),
            ),
          ),
          Expanded(
            child: _buildTabButton(
              text: "Weekly",
              isSelected: _selectedTab == 1,
              onTap: () => setState(() => _selectedTab = 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ?  LinearGradient(
            colors: [
              AppColor.royalBlue,
              AppColor.royalBlue.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextConst(
          title:
          text,
          textAlign: TextAlign.center,
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: FontWeight.w600,
          size: 14,
        ),
      ),
    );
  }

  Widget _buildEarningsCard(Map<String, dynamic> data) {
    return AnimatedGradientBorder(
      borderSize: 2.1,
      glowSize: 0,
      gradientColors: [
        AppColor.royalBlue,
        Colors.transparent,
        AppColor.royalBlue,
      ],
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
          margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              "Total Earnings",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              data['totalEarnings'] ?? "₹0",
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _selectedTab == 0 ? "Today" : "This Week",
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEarningType("Offline", data['offlineEarnings'] ?? '₹0'),
                _buildEarningType("Online", data['onlineEarnings'] ?? '₹0'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningType(String type, String amount) {
    return Column(
      children: [
        Text(
          type,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic> data) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          icon: Icons.directions_car,
          title: "Trips Completed",
          value: "${data['tripsCompleted'] ?? 0}",
          color: Colors.blue,
        ),
        _buildStatCard(
          icon: Icons.timer,
          title: "Online Hours",
          value: data['totalTime'] ?? "0h",
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetails(Map<String, dynamic> data) {
    final List<dynamic> trips = data['tripDetails'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Trip Details",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        if (trips.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                "No trips available",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          Column(
            children: trips.map((trip) => _buildTripItem(trip)).toList(),
          ),
      ],
    );
  }

  Widget _buildTripItem(Map<String, dynamic> trip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Trip ${trip['id'] ?? ''}",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(trip['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trip['status'] ?? 'Pending',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(trip['status']),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.my_location, size: 14, color: Colors.green),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  trip['pickup'] ?? '',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.red),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  trip['drop'] ?? '',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.timelapse, size: 14, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    trip['time'] ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.directions, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    trip['distance'] ?? '',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              Text(
                "₹${trip['amount'] ?? 0}",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  trip['paymentMode'] ?? '',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}