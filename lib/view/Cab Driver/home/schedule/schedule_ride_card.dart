import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';

enum RideStatus {
  pending,
  accepted,
  ignored,
  scheduled,
  ready,
  started,
  completed,
  cancelledByUser,
  cancelledByDriver,
}

class ScheduledRideCard extends StatelessWidget {
  final String userName;
  final String userMobile;
  final String pickup;
  final String drop;
  final double distance;
  final double fare;
  final DateTime scheduledTime;
  final RideStatus status;

  final VoidCallback? onAccept;
  final VoidCallback? onIgnore;
  final VoidCallback? onStart;
  final VoidCallback? onNavigate;
  final VoidCallback? onComplete;
  final VoidCallback? onViewProfile;

  const ScheduledRideCard({
    super.key,
    required this.userName,
    required this.userMobile,
    required this.pickup,
    required this.drop,
    required this.distance,
    required this.fare,
    required this.scheduledTime,
    required this.status,
    this.onAccept,
    this.onIgnore,
    this.onStart,
    this.onNavigate,
    this.onComplete,
    this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    final map = _statusMap(status);

    return Scaffold(
      backgroundColor: AppColor.whiteDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.royalBlue,
        foregroundColor: AppColor.black,
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back,color: AppColor.white,)),
        title: TextConst(
          title: "Scheduled Ride",
          size: 17,
          color: AppColor.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [

            /// ================= USER CARD =================
            _card(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onViewProfile,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor:
                      AppColor.royalBlue.withOpacity(0.15),
                      child: Icon(
                        Icons.person,
                        color: AppColor.royalBlue,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextConst(
                          title: userName,
                          size: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 4),
                        TextConst(
                          title: userMobile,
                          size: 13,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      color: Colors.black26),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// ================= STATUS CARD =================
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      _statusChip(map),
                      TextConst(
                        title:
                        DateFormat('dd MMM • hh:mm a').format(
                            scheduledTime),
                        size: 12,
                        color: Colors.black54,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _locationRow(
                    Icons.my_location,
                    "Pickup",
                    pickup,
                    Colors.green,
                  ),
                  const SizedBox(height: 10),
                  _locationRow(
                    Icons.location_on,
                    "Drop",
                    drop,
                    Colors.red,
                  ),

                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      _miniInfo("Distance", "$distance km"),
                      _miniInfo("Fare", "₹$fare"),
                      _miniInfo(
                        "Date",
                        DateFormat('dd MMM').format(scheduledTime),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                      AppColor.royalBlue.withOpacity(0.08),
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(map.icon,
                            size: 18,
                            color: AppColor.royalBlue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextConst(
                            title: map.message,
                            size: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// ================= ACTIONS =================
            if (status == RideStatus.pending)
              Row(
                children: [
                  Expanded(
                    child: _actionBtn(
                      "Accept",
                      Icons.check_circle,
                      AppColor.royalBlue,
                      onAccept,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _outlineBtn(
                      "Ignore",
                      Icons.close,
                      onIgnore,
                    ),
                  ),
                ],
              ),

            if (status == RideStatus.ready)
              _actionBtn(
                "Start Ride",
                Icons.play_circle_fill,
                Colors.green,
                onStart,
              ),

            if (status == RideStatus.started)
              Row(
                children: [
                  Expanded(
                    child: _actionBtn(
                      "Navigate",
                      Icons.navigation,
                      AppColor.royalBlue,
                      onNavigate,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _actionBtn(
                      "Complete",
                      Icons.done_all,
                      Colors.green,
                      onComplete,
                    ),
                  ),
                ],
              ),

            if (status == RideStatus.completed ||
                status == RideStatus.cancelledByUser ||
                status == RideStatus.cancelledByDriver ||
                status == RideStatus.ignored)
              _disabledBtn(map.label),
          ],
        ),
      ),
    );
  }

  // ================= COMMON UI =================

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _statusChip(_RideStatusMap map) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.royalBlue.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextConst(
        title: map.label,
        size: 12,
        fontWeight: FontWeight.w700,
        color: AppColor.royalBlue,
      ),
    );
  }

  Widget _locationRow(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: TextConst(
            title: "$label: $value",
            size: 13,
          ),
        ),
      ],
    );
  }

  Widget _miniInfo(String title, String value) {
    return Column(
      children: [
        TextConst(
          title: value,
          size: 14,
          fontWeight: FontWeight.w700,
        ),
        TextConst(
          title: title,
          size: 11,
          color: Colors.black54,
        ),
      ],
    );
  }

  Widget _actionBtn(String title, IconData icon, Color color,
      VoidCallback? onTap) {
    return SizedBox(
      height: 46,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, size: 18),
        label: TextConst(
          title: title,
          size: 14,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _outlineBtn(
      String title, IconData icon, VoidCallback? onTap) {
    return SizedBox(
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: TextConst(
          title: title,
          size: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _disabledBtn(String title) {
    return SizedBox(
      height: 46,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade300,
        ),
        child: TextConst(
          title: title,
          size: 14,
          color: Colors.black45,
        ),
      ),
    );
  }

  // ================= STATUS MAP =================

  _RideStatusMap _statusMap(RideStatus status) {
    switch (status) {
      case RideStatus.pending:
        return _RideStatusMap(
            "PENDING", Icons.access_time, "Awaiting response");
      case RideStatus.accepted:
        return _RideStatusMap(
            "ACCEPTED", Icons.check_circle, "Ride accepted");
      case RideStatus.ignored:
        return _RideStatusMap(
            "IGNORED", Icons.cancel, "Ride ignored");
      case RideStatus.scheduled:
        return _RideStatusMap(
            "SCHEDULED", Icons.schedule, "Ride scheduled");
      case RideStatus.ready:
        return _RideStatusMap(
            "READY", Icons.play_circle, "You can start now");
      case RideStatus.started:
        return _RideStatusMap(
            "ONGOING", Icons.navigation, "Ride in progress");
      case RideStatus.completed:
        return _RideStatusMap(
            "COMPLETED", Icons.done_all, "Ride completed");
      case RideStatus.cancelledByUser:
        return _RideStatusMap(
            "CANCELLED", Icons.person_off, "Cancelled by user");
      case RideStatus.cancelledByDriver:
        return _RideStatusMap(
            "CANCELLED", Icons.cancel, "Cancelled by driver");
    }
  }
}

// ================= MODEL =================
class _RideStatusMap {
  final String label;
  final IconData icon;
  final String message;

  _RideStatusMap(this.label, this.icon, this.message);
}
