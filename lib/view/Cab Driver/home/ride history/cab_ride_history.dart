import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/driver_home_page.dart';
import 'package:rainbow_partner/view_model/cabdriver/cab_history_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/change_cab_order_status_view_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../model/cab_history_model.dart' show Data;

class CabRideHistory extends StatefulWidget {
  const CabRideHistory({super.key});

  @override
  State<CabRideHistory> createState() => _CabRideHistoryState();
}

class _CabRideHistoryState extends State<CabRideHistory> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CabHistoryViewModel>(
        context,
        listen: false,
      ).cabHistoryApi(1, context);
    });
  }

  // Color scheme
  final Color secondaryColor = Color(0xFF34C759);
  final Color accentColor = Color(0xFFFF9500);
  final Color backgroundColor = Color(0xFFF8F9FA);
  final Color cardColor = Colors.white;
  final Color textPrimary = Color(0xFF1C1C1E);
  final Color textSecondary = Color(0xFF8E8E93);
  final Color textTertiary = Color(0xFFC7C7CC);

  final List<int> laterValidStatuses = [1, 2, 4, 5, 6, 7, 8];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 0.5,
          title: TextConst(
            title:
            loc.ride_history,
            color: textPrimary,
            size: 20,
            fontWeight: FontWeight.w700,
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

            final allRides = viewModel.cabHistoryModel?.data ?? [];

            final rides = _selectedTab == 0
                ? allRides
                : allRides
                .where((ride) =>
                laterValidStatuses.contains(ride.orderStatus))
                .toList();

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
                      _selectedTab == 0
                          ? loc.no_rides_found
                          : loc.no_scheduled_rides_found,
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
    final loc = AppLocalizations.of(context)!;
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildTabButton(loc.now, 0)),
          SizedBox(width: 16),
          Expanded(child: _buildTabButton(loc.later, 1)),
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
    final loc = AppLocalizations.of(context)!;
    Color statusColor = isNowTab
        ? _getStatusColor(ride.orderStatus)
        : _getLaterStatusColor(ride.orderStatus);
    String statusText = isNowTab
        ? _getStatusText(ride.orderStatus)
        : _getLaterStatusText(ride.orderStatus);
    String payModeText = _getPayModeText(ride.payMode);
    final String createdAtText = DateFormat('dd MMM yyyy, hh:mm a')
        .format(DateTime.parse(ride.createdAt.toString()).toLocal());

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: AppColor.royalBlue),
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
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColor.royalBlue.withOpacity(0.2), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFF2F2F7),
                    child: Icon(
                      Icons.person,
                      color: textSecondary,
                      size: 28,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextConst(
                        title: ride.userName?.toString() ?? loc.unknown_user,
                        size: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                      SizedBox(height: 2),
                      TextConst(
                        title: ride.userMobile?.toString() ?? loc.na,
                        size: 13,
                        color: textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                // Later tab + status 1 = Call button
                if (!isNowTab && ride.orderStatus == 1)
                  _buildCallButton(ride.userMobile?.toString()),
              ],
            ),

            // // Later tab + status 1: Ride ID + extra user info row
            // if (!isNowTab && ride.orderStatus == 1) ...[
            //   SizedBox(height: 10),
            //   Row(
            //     children: [
            //       Container(
            //         padding:
            //         EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //         decoration: BoxDecoration(
            //           color: Color(0xFFF2F2F7),
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         child: TextConst(
            //           title: '#${ride.id?.toString() ?? 'N/A'}',
            //           size: 11,
            //           fontWeight: FontWeight.w600,
            //           color: textSecondary,
            //         ),
            //       ),
            //     ],
            //   ),
            // ],

            SizedBox(height: 16),
            Divider(height: 1, color: Color(0xFFE5E5EA)),
            SizedBox(height: 16),

            // ── LATER TAB: Schedule Date/Time Banner ──
            if (!isNowTab && ride.scheduleTime != null)
              _buildScheduleBanner(ride.scheduleTime.toString()),

            SizedBox(height: isNowTab ? 0 : 12),


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
                        title: loc.pickup,
                        size: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      SizedBox(height: 2),
                      Text(
                        ride.pickupLocation ?? loc.na,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontFamily: AppFonts.kanitReg),
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
                        title: loc.drop,
                        size: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      SizedBox(height: 2),
                      Text(
                        ride.dropLocation ?? loc.na,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            fontFamily: AppFonts.kanitReg),
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
                    loc.distance,
                    '${ride.distanceKm ?? '0'} km',
                    Icons.rocket,
                  ),
                  _buildAmountStatItem(ride),
                  _buildStatItem(
                    loc.payment,
                    payModeText,
                    Icons.payment,
                  ),
                ],
              ),
            ),

            SizedBox(height: 12),

            if (isNowTab)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColor.royalBlue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColor.royalBlue.withOpacity(0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: AppColor.royalBlue,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        createdAtText,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColor.royalBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 12),
            // Footer Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border:
                    Border.all(color: statusColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isNowTab
                            ? _getStatusIcon(ride.orderStatus)
                            : _getLaterStatusIcon(ride.orderStatus),
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
                if (isNowTab && ride.scheduleTime != null)
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

            // Cancel Reason
            if ((ride.orderStatus == 6 || ride.orderStatus == 7) &&
                ride.cancelReason != null &&
                ride.cancelReason.toString().isNotEmpty) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFFF3B30).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Color(0xFFFF3B30).withOpacity(0.1)),
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
                            loc.cancellation_reason,
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

            // User comment for Later tab
            if (!isNowTab &&
                ride.userComment != null &&
                ride.userComment.toString().isNotEmpty) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border:
                  Border.all(color: accentColor.withOpacity(0.1)),
                ),
                child: Row(
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
              ),
            ],

            // Rating for completed rides (Now & Later dono)
            if (ride.orderStatus == 5 &&
                ride.orderRating != null &&
                ride.orderRating.toString() != '0') ...[

              SizedBox(height: 12),

              Row(
                children: [

                  /// ⭐ Dynamic Stars
                  Row(
                    children: List.generate(
                      int.parse(ride.orderRating.toString()),
                          (index) => const Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFCC00),
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
                        ],

            if (!isNowTab && ride.orderStatus == 1) ...[
              SizedBox(height: 16),
              Row(
                children: [
                  // Navigate to Pickup
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final lat = ride.pickupLatitude;
                        final lng = ride.pickupLongitude;
                        if (lat != null && lng != null) {
                          final uri = Uri.parse(
                              'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving');
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.navigation_rounded, size: 16, color: Colors.green),
                            SizedBox(width: 6),
                            Text(loc.navigate,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  // OTP + Start Ride
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showOtpDialog(ride),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColor.royalBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow_rounded, size: 16, color: Colors.white),
                            SizedBox(width: 6),
                            Text(loc.start_ride,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
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

  void _showOtpDialog(Data ride) {
    final loc = AppLocalizations.of(context)!;
    final otpController = TextEditingController();

    final cabOrderStatusVm =
    Provider.of<ChangeCabOrderStatusViewModel>(
      context,
      listen: false,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // top handle
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 20),

              CircleAvatar(
                radius: 30,
                backgroundColor: AppColor.royalBlue.withOpacity(0.1),
                child: Icon(
                  Icons.lock_outline,
                  color: AppColor.royalBlue,
                  size: 30,
                ),
              ),

              const SizedBox(height: 16),

              TextConst(
                title: loc.verify_ride_otp,
                size: 20,
                fontWeight: FontWeight.bold,
              ),

              const SizedBox(height: 8),

              TextConst(
                title: loc.enter_customer_otp_start_ride,
                textAlign: TextAlign.center,
                size: 14,
                color: Colors.grey.shade600,
              ),

              const SizedBox(height: 20),

              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 12,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "----",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    letterSpacing: 12,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:  TextConst(title: loc.back),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (otpController.text.trim().isEmpty) return;

                        bool success = await cabOrderStatusVm.changeCabOrderApi(
                          ride.id,
                          3,
                          otpController.text.trim(),
                          "",
                          context,
                        );

                        if (success) {
                          Navigator.pop(ctx);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DriverHomePage(),
                            ),
                                (route) => false,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColor.royalBlue,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.royalBlue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            loc.start_ride,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // ── Schedule Date/Time Banner ──
  Widget _buildScheduleBanner(String scheduleTimeRaw) {
    final loc = AppLocalizations.of(context)!;
    String formattedDate = '';
    String formattedTime = '';
    String dayLabel = '';

    try {
      // Try parsing ISO or common formats
      DateTime dt = DateTime.parse(scheduleTimeRaw);
      formattedDate =
          DateFormat('dd MMM yyyy').format(dt); // e.g. 09 May 2026
      formattedTime = DateFormat('hh:mm a').format(dt); // e.g. 03:30 PM

      final today = DateTime.now();
      final tomorrow = today.add(Duration(days: 1));
      if (dt.year == today.year &&
          dt.month == today.month &&
          dt.day == today.day) {
        dayLabel = loc.today;
      } else if (dt.year == tomorrow.year &&
          dt.month == tomorrow.month &&
          dt.day == tomorrow.day) {
        dayLabel = loc.tomorrow;
      } else {
        dayLabel = DateFormat('EEEE').format(dt); // Day name
      }
    } catch (_) {
      // If parsing fails, show raw
      formattedDate = scheduleTimeRaw;
      formattedTime = '';
      dayLabel = '';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.royalBlue.withOpacity(0.9),
            AppColor.royalBlue.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.calendar_today_rounded,
                color: Colors.white, size: 18),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextConst(
                  title: loc.scheduled_ride,
                  color: Colors.white.withOpacity(0.8),
                  size: 11,
                  fontFamily: AppFonts.kanitReg,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    if (dayLabel.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          dayLabel,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                    ],
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (formattedTime.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  loc.time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 2),
                Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    formattedTime,
                    style: TextStyle(
                      color: AppColor.royalBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCallButton(String? mobile) {
    return GestureDetector(
      onTap: () async {
        if (mobile != null && mobile.isNotEmpty) {
          final uri = Uri(scheme: 'tel', path: mobile);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColor.royalBlue,
          shape: BoxShape.circle,
          // borderRadius: BorderRadius.circular(10),
        ),
        child:  Icon(Icons.phone_rounded, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildAmountStatItem(Data ride) {
    final loc = AppLocalizations.of(context)!;
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
            loc.fare,
            style: TextStyle(
              fontSize: 11,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else {
      return _buildStatItem(
        loc.fare,
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
    final loc = AppLocalizations.of(context)!;
    switch (payMode?.toString()) {
      case '1':
        return loc.online;
      case '2':
        return loc.offline;
      case '3':
        return loc.wallet;
      default:
        return loc.na;
    }
  }

  // Now tab statuses
  String _getStatusText(dynamic status) {
    final loc = AppLocalizations.of(context)!;
    switch (status?.toString()) {
      case '5':
        return loc.completed;
      case '6':
        return loc.cancelled_by_user;
      case '7':
        return loc.cancelled_by_me;
      default:
        return loc.unknown;
    }
  }

  Color _getStatusColor(dynamic status) {
    switch (status?.toString()) {
      case '5':
        return secondaryColor;
      case '6':
        return accentColor;
      case '7':
        return Color(0xFFFF3B30);
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

  // Later tab statuses: [1,2,4,5,6,7,8]
  String _getLaterStatusText(dynamic status) {
    final loc = AppLocalizations.of(context)!;
    switch (status?.toString()) {
      case '1':
        return loc.booking_confirmed;
      case '2':
        return loc.driver_on_way;
      case '4':
        return loc.ride_in_progress;
      case '5':
        return loc.completed;
      case '6':
        return loc.cancelled_by_user;
      case '7':
        return loc.cancelled_by_driver;
      case '8':
        return loc.pending_waiting;
      default:
        return loc.unknown;
    }
  }

  Color _getLaterStatusColor(dynamic status) {
    switch (status?.toString()) {
      case '1':
        return Color(0xFF007AFF); // Blue - Confirmed
      case '2':
        return accentColor;       // Orange - On the way
      case '4':
        return Color(0xFF5856D6); // Purple - In progress
      case '5':
        return secondaryColor;    // Green - Completed
      case '6':
        return accentColor;       // Orange - Cancelled by User
      case '7':
        return Color(0xFFFF3B30); // Red - Cancelled by Driver
      case '8':
        return Color(0xFF8E8E93); // Grey - Pending
      default:
        return textSecondary;
    }
  }

  IconData _getLaterStatusIcon(dynamic status) {
    switch (status?.toString()) {
      case '1':
        return Icons.check_circle_rounded;
      case '2':
        return Icons.directions_car_rounded;
      case '4':
        return Icons.play_circle_rounded;
      case '5':
        return Icons.verified_rounded;
      case '6':
        return Icons.person_remove_rounded;
      case '7':
        return Icons.cancel_rounded;
      case '8':
        return Icons.hourglass_empty_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}
