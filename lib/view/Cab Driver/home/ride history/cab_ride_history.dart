import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_history_view_model.dart';

import '../../../../model/cab_history_model.dart' show Data;

class CabRideHistory extends StatefulWidget {
  const CabRideHistory({super.key});

  @override
  State<CabRideHistory> createState() => _CabRideHistoryState();
}

class _CabRideHistoryState extends State<CabRideHistory> {
  int _selectedTab = 0; // 0 for Now, 1 for Later

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load Now rides (order_type = 1)
      Provider.of<CabHistoryViewModel>(
        context,
        listen: false,
      ).cabHistoryApi(1, context);
    });
  }

  // Color scheme
  final Color secondaryColor = Color(0xFF34C759); // Green
  final Color accentColor = Color(0xFFFF9500); // Orange
  final Color backgroundColor = Color(0xFFF8F9FA); // Light Grey
  final Color cardColor = Colors.white;
  final Color textPrimary = Color(0xFF1C1C1E);
  final Color textSecondary = Color(0xFF8E8E93);
  final Color textTertiary = Color(0xFFC7C7CC);

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
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: textPrimary, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: _buildTabBar(),
          ),
        ),
        body: Consumer<CabHistoryViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColor.royalBlue,
                ),
              );
            }

            final rides = _selectedTab == 0
                ? (viewModel.cabHistoryModel?.data ?? [])
                : (viewModel.cabHistoryModel?.data ?? []);

            if (rides.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 64,
                      color: textTertiary,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No rides found',
                      style: TextStyle(
                        fontSize: 16,
                        color: textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Ride Count
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTab == 0
                            ? '${rides.length} Rides'
                            : '${rides.length} Scheduled Rides',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    itemCount: rides.length,
                    itemBuilder: (context, index) {
                      return _buildRideCard(rides[index], _selectedTab == 0);
                    },
                  ),
                ),
              ],
            );
          },
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
        // Load appropriate data based on tab
        Provider.of<CabHistoryViewModel>(context, listen: false)
            .cabHistoryApi(index == 0 ? 1 : 2, context);
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

  Widget _buildRideCard(Data ride, bool isNowTab) {
    Color statusColor = _getStatusColor(ride.orderStatus);
    String statusText = _getStatusText(ride.orderStatus);
    String payModeText = _getPayModeText(ride.payMode);

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
                    border: Border.all(
                        color: AppColor.royalBlue.withOpacity(0.2), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: ride.profilePhoto != null &&
                        ride.profilePhoto.toString().isNotEmpty
                        ? NetworkImage(ride.profilePhoto.toString())
                        : null,
                    backgroundColor: Color(0xFFF2F2F7),
                    child: ride.profilePhoto == null ||
                        ride.profilePhoto.toString().isEmpty
                        ? Icon(Icons.person, color: textSecondary)
                        : null,
                  ),
                ),
                SizedBox(width: 12),
                // User Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextConst(
                        title: ride.userName?.toString() ?? 'Unknown User',
                        size: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                      SizedBox(height: 2),
                      TextConst(
                        title: ride.userMobile?.toString() ?? 'N/A',
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
                    title: '#${ride.id?.toString() ?? 'N/A'}',
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

            // Vehicle Info
            // Pickup Location
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.green),
                SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextConst(
                        title: "Pickup",
                        size: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      SizedBox(height: 2),
                      Text(
                        ride.pickupLocation ?? "N/A",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.black54,fontFamily: AppFonts.kanitReg),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.red),
                SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextConst(
                        title: "Drop",
                        size: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      SizedBox(height: 2),
                      Text(
                        ride.dropLocation ?? "N/A",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 13, color: Colors.black54,fontFamily: AppFonts.kanitReg),
                      ),
                    ],
                  ),
                )
              ],
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
                  _buildStatItem(
                    'Distance',
                    '${ride.distanceKm ?? '0'} km',
                    Icons.rocket,
                  ),
                  _buildAmountStatItem(ride),
                  _buildStatItem(
                    'Payment',
                    payModeText,
                    Icons.payment,
                  ),
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
                        _getStatusIcon(ride.orderStatus),
                        size: 14,
                        color: statusColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        statusText,
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
                if (ride.scheduleTime != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColor.royalBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ride.scheduleTime.toString(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColor.royalBlue,
                      ),
                    ),
                  ),
              ],
            ),

            // Cancel Reason (if applicable)
            if ((ride.orderStatus == 6 || ride.orderStatus == 7) &&
                ride.cancelReason != null &&
                ride.cancelReason.toString().isNotEmpty) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFF3B30).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border:
                  Border.all(color: Color(0xFFFF3B30).withOpacity(0.1)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        size: 16, color: Color(0xFFFF3B30)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cancellation Reason',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF3B30),
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            ride.cancelReason.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Additional info for "Later" tab
            if (!isNowTab && ride.scheduleTime != null) ...[
              SizedBox(height: 12),
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
                        Icon(Icons.access_time_filled_rounded,
                            size: 16, color: accentColor),
                        SizedBox(width: 8),
                        Text(
                          'Scheduled Time: ${ride.scheduleTime}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    if (ride.userComment != null &&
                        ride.userComment.toString().isNotEmpty) ...[
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.note_rounded,
                              size: 14, color: textSecondary),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              ride.userComment.toString(),
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

            // Rating for completed rides
            if (ride.orderStatus == 5 &&
                ride.rating != null &&
                ride.rating.toString() != '0') ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: Color(0xFFFFCC00), size: 18),
                  SizedBox(width: 6),
                  Text(
                    ride.rating.toString(),
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

  Widget _buildAmountStatItem(Data ride) {
    // wallet_apply 1 aur payMode 1 = dono amount dikhega
    bool showBothAmounts = ride.walletApply == 1 && ride.payMode == 1;

    if (showBothAmounts) {
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
              child: Icon(Icons.account_balance_wallet,
                  size: 18, color: AppColor.royalBlue),
            ),
          ),
          SizedBox(height: 6),
          Column(
            children: [
              Text(
                '₹${ride.amountAfterWallet ?? '0'}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textSecondary,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: textSecondary,
                ),
              ),
              Text(
                '₹${ride.finalAmount ?? '0'}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          Text(
            'Fare',
            style: TextStyle(
              fontSize: 11,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else {
      // Baaki sab cases me sirf final_amount
      return _buildStatItem(
        'Fare',
        '₹${ride.finalAmount ?? '0'}',
        Icons.currency_rupee,
      );
    }
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
          title: value,
          size: 15,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        SizedBox(height: 2),
        TextConst(
          title: title,
          size: 11,
          color: textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  String _getPayModeText(dynamic payMode) {
    switch (payMode?.toString()) {
      case '1':
        return 'Online';
      case '2':
        return 'Offline';
      case '3':
        return 'Wallet';
      default:
        return 'N/A';
    }
  }

  String _getStatusText(dynamic status) {
    switch (status?.toString()) {
      case '5':
        return 'Completed';
      case '6':
        return 'Cancelled by User';
      case '7':
        return 'Cancelled by Me';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(dynamic status) {
    switch (status?.toString()) {
      case '5':
        return secondaryColor; // Green - Completed
      case '6':
        return accentColor; // Orange - Cancelled by User
      case '7':
        return Color(0xFFFF3B30); // Red - Cancelled by Driver
      default:
        return textSecondary;
    }
  }

  IconData _getStatusIcon(dynamic status) {
    switch (status?.toString()) {
      case '5':
        return Icons.check_circle_rounded;
      case '6':
        return Icons.person_remove_rounded;
      case '7':
        return Icons.cancel_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}