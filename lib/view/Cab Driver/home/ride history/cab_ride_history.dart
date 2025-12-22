import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';

class CabRideHistory extends StatefulWidget {
  const CabRideHistory({super.key});

  @override
  State<CabRideHistory> createState() => _CabRideHistoryState();
}

class _CabRideHistoryState extends State<CabRideHistory> {
  int _selectedTab = 0; // 0 for Now, 1 for Later

  // Color scheme
  final Color secondaryColor = Color(0xFF34C759); // Green
  final Color accentColor = Color(0xFFFF9500); // Orange
  final Color backgroundColor = Color(0xFFF8F9FA); // Light Grey
  final Color cardColor = Colors.white;
  final Color textPrimary = Color(0xFF1C1C1E);
  final Color textSecondary = Color(0xFF8E8E93);
  final Color textTertiary = Color(0xFFC7C7CC);

  // Sample data for "Now" rides (ongoing/completed today)
  final List<Map<String, dynamic>> nowRides = [
    {
      'id': 'RIDE001',
      'userName': 'Rajesh Kumar',
      'userMobile': '+91 98765 43210',
      'profileImage': 'https://randomuser.me/api/portraits/men/1.jpg',
      'pickup': 'Connaught Place, Delhi',
      'drop': 'Indira Gandhi Airport, Delhi',
      'distance': '18.5 km',
      'fare': '₹450',
      'status': 'completed',
      'statusText': 'Completed',
      'dateTime': DateTime.now().subtract(Duration(hours: 2)),
      'vehicleType': 'Sedan',
      'paymentMode': 'Online',
      'rating': 4.5,
    },
    {
      'id': 'RIDE002',
      'userName': 'Priya Sharma',
      'userMobile': '+91 87654 32109',
      'profileImage': 'https://randomuser.me/api/portraits/women/2.jpg',
      'pickup': 'Hauz Khas, Delhi',
      'drop': 'Gurugram Cyber City',
      'distance': '25.3 km',
      'fare': '₹620',
      'status': 'cancelled_by_driver',
      'statusText': 'Cancelled by Driver',
      'dateTime': DateTime.now().subtract(Duration(hours: 5)),
      'vehicleType': 'SUV',
      'paymentMode': 'Cash',
      'rating': null,
    },
    {
      'id': 'RIDE003',
      'userName': 'Amit Patel',
      'userMobile': '+91 76543 21098',
      'profileImage': 'https://randomuser.me/api/portraits/men/3.jpg',
      'pickup': 'Dwarka Sector 21',
      'drop': 'Rohini Sector 18',
      'distance': '32.7 km',
      'fare': '₹780',
      'status': 'cancelled_by_user',
      'statusText': 'Cancelled by User',
      'dateTime': DateTime.now().subtract(Duration(hours: 1)),
      'vehicleType': 'Sedan',
      'paymentMode': 'Online',
      'rating': null,
    },
    {
      'id': 'RIDE004',
      'userName': 'Sneha Singh',
      'userMobile': '+91 65432 10987',
      'profileImage': 'https://randomuser.me/api/portraits/women/4.jpg',
      'pickup': 'Noida Sector 62',
      'drop': 'Delhi Railway Station',
      'distance': '22.1 km',
      'fare': '₹540',
      'status': 'completed',
      'statusText': 'Completed',
      'dateTime': DateTime.now().subtract(Duration(minutes: 30)),
      'vehicleType': 'Hatchback',
      'paymentMode': 'Online',
      'rating': 5.0,
    },
  ];

  // Sample data for "Later" rides (scheduled for future)
  final List<Map<String, dynamic>> laterRides = [
    {
      'id': 'RIDE101',
      'userName': 'Vikram Mehta',
      'userMobile': '+91 98765 12345',
      'profileImage': 'https://randomuser.me/api/portraits/men/5.jpg',
      'pickup': 'Rajouri Garden, Delhi',
      'drop': 'Chandigarh Bus Stand',
      'distance': '250 km',
      'fare': '₹4500',
      'status': 'scheduled',
      'statusText': 'Scheduled',
      'dateTime': DateTime.now().add(Duration(days: 2)),
      'vehicleType': 'SUV',
      'paymentMode': 'Advance Paid',
      'pickupTime': '08:00 AM',
      'notes': 'Airport drop, 2 luggage',
    },
    {
      'id': 'RIDE102',
      'userName': 'Anjali Reddy',
      'userMobile': '+91 87654 23456',
      'profileImage': 'https://randomuser.me/api/portraits/women/6.jpg',
      'pickup': 'Bengaluru Airport',
      'drop': 'Electronic City, Bengaluru',
      'distance': '38 km',
      'fare': '₹950',
      'status': 'confirmed',
      'statusText': 'Confirmed',
      'dateTime': DateTime.now().add(Duration(days: 1)),
      'vehicleType': 'Sedan',
      'paymentMode': 'Online',
      'pickupTime': '10:30 PM',
      'notes': 'Flight arrival at 10:15 PM',
    },
    {
      'id': 'RIDE103',
      'userName': 'Rahul Verma',
      'userMobile': '+91 76543 34567',
      'profileImage': 'https://randomuser.me/api/portraits/men/7.jpg',
      'pickup': 'Mumbai Central',
      'drop': 'Nav Mumbai Airport',
      'distance': '42.5 km',
      'fare': '₹1200',
      'status': 'pending',
      'statusText': 'Pending Confirmation',
      'dateTime': DateTime.now().add(Duration(days: 3)),
      'vehicleType': 'Luxury',
      'paymentMode': 'To be decided',
      'pickupTime': '06:00 AM',
      'notes': 'Early morning ride',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 0.5,
          title: Text(
            'Ride History',
            style: TextStyle(
              color: textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: _buildTabBar(),
          ),
        ),
        body: Column(
          children: [
            // Ride Count
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTab == 0
                        ? '${nowRides.length} Rides'
                        : '${laterRides.length} Scheduled Rides',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColor.royalBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _selectedTab == 0 ? 'Today' : 'Upcoming',
                      style: TextStyle(
                        color: AppColor.royalBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Ride List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: _selectedTab == 0 ? nowRides.length : laterRides.length,
                itemBuilder: (context, index) {
                  final ride = _selectedTab == 0 ? nowRides[index] : laterRides[index];
                  return _buildRideCard(ride, _selectedTab == 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton('Now', 0),
          ),
          SizedBox(width: 16),
          Expanded(
            child: _buildTabButton('Later', 1),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColor.royalBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColor.royalBlue : Color(0xFFE5E5EA),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRideCard(Map<String, dynamic> ride, bool isNowTab) {
    Color statusColor = _getStatusColor(ride['status']);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Profile Image with border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.royalBlue.withOpacity(0.2), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(ride['profileImage']),
                    backgroundColor: Color(0xFFF2F2F7),
                  ),
                ),
                SizedBox(width: 12),

                // User Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextConst(title:
                        ride['userName'],
                        size: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                      SizedBox(height: 2),
                      TextConst(
                        title:
                        ride['userMobile'],
                        size: 13,
                        color: textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),

                // Ride ID
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F2F7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextConst(
                    title:
                    ride['id'],
                    size: 11,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Divider
            Divider(height: 1, color: Color(0xFFE5E5EA)),
            SizedBox(height: 16),

            // Location Details
            _buildLocationRow(
              Icons.my_location,
              'Pickup',
              ride['pickup'],
              secondaryColor,
            ),
            SizedBox(height: 12),
            _buildLocationRow(
              Icons.location_on,
              'Drop',
              ride['drop'],
              Color(0xFFFF3B30), // Red
            ),

            SizedBox(height: 16),

            // Stats Row
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Distance', ride['distance'], Icons.rocket),
                  _buildStatItem('Fare', ride['fare'], Icons.currency_rupee),
                  _buildStatItem('Vehicle', ride['vehicleType'], Icons.directions_car),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Footer Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status Chip
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(ride['status']),
                        size: 14,
                        color: statusColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        ride['statusText'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Date Time
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColor.royalBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isNowTab
                        ? DateFormat('hh:mm a').format(ride['dateTime'])
                        : DateFormat('MMM dd, yyyy').format(ride['dateTime']),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColor.royalBlue,
                    ),
                  ),
                ),
              ],
            ),

            // Additional info for "Later" tab
            if (!isNowTab) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time_filled_rounded, size: 16, color: accentColor),
                        SizedBox(width: 8),
                        Text(
                          'Pickup Time: ${ride['pickupTime']}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    if (ride['notes'] != null && ride['notes'].isNotEmpty) ...[
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.note_rounded, size: 14, color: textSecondary),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${ride['notes']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Rating for completed rides in "Now" tab
            if (isNowTab && ride['rating'] != null && ride['status'] == 'completed') ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: Color(0xFFFFCC00), size: 18),
                  SizedBox(width: 6),
                  Text(
                    '${ride['rating']}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Rating',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationRow(IconData icon, String label, String address, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, size: 16, color: color),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  color: textTertiary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                address,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColor.royalBlue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, size: 18, color: AppColor.royalBlue),
          ),
        ),
        SizedBox(height: 6),
        TextConst(
          title:
          value,
          size: 15,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        SizedBox(height: 2),
        TextConst(
          title:
          title,
          size: 11,
          color: textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return secondaryColor; // Green
      case 'cancelled_by_driver':
        return Color(0xFFFF3B30); // Red
      case 'cancelled_by_user':
        return Color(0xFFFF9500); // Orange
      case 'scheduled':
        return Color(0xFF007AFF); // Blue
      case 'confirmed':
        return Color(0xFF5856D6); // Purple
      case 'pending':
        return accentColor; // Orange
      default:
        return textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check_circle_rounded;
      case 'cancelled_by_driver':
        return Icons.cancel_rounded;
      case 'cancelled_by_user':
        return Icons.person_remove_rounded;
      case 'scheduled':
        return Icons.schedule_rounded;
      case 'confirmed':
        return Icons.verified_rounded;
      case 'pending':
        return Icons.pending_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}