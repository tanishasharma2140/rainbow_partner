import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_loader.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/map_utils.dart';
import 'package:rainbow_partner/res/no_data_found.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/call_utils.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/service/ringtone_service.dart';
import 'package:rainbow_partner/view_model/service_man/change_order_status_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/complete_booking_view_model.dart';
import 'package:rainbow_partner/res/slide_to_button.dart';

class AcceptedBooking extends StatefulWidget {
  const AcceptedBooking({super.key});

  @override
  State<AcceptedBooking> createState() => _AcceptedBookingState();
}

class _AcceptedBookingState extends State<AcceptedBooking> {
  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompleteBookingViewModel>(
        context,
        listen: false,
      ).completeBookingApi([1, 2, 3], context);
    });
  }

  final Map<int, bool> _expandedMap = {};

  Future<void> _refreshBookings() async {
    await Provider.of<CompleteBookingViewModel>(
      context,
      listen: false,
    ).completeBookingApi([1, 2, 3], context);
  }

  // ---------------- REJECT DIALOG ----------------
  void showRejectDialog(int orderId, ChangeOrderStatusViewModel vm) {
    final TextEditingController reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextConst(
                title: "Reject Booking",
                size: 16,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 8),
              const TextConst(
                title: "Please mention rejection reason",
                size: 13,
                color: Colors.black54,
              ),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: reasonCtrl,
                  textInputAction: TextInputAction.done,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Enter reason...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (reasonCtrl.text.trim().isEmpty) {
                          Utils.showErrorMessage(
                            context,
                            "Please enter reason",
                          );
                          return;
                        }
                        Navigator.pop(context);
                        vm.changeOrderStatusApi(
                          orderId,
                          6,
                          "",
                          reasonCtrl.text.trim(),
                          context,
                        );
                      },
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Reject",
                          style: TextStyle(color: Colors.white),
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
  }

  Widget _detail(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value?.toString() ?? "-",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void showCollectCashDialog({
    required int orderId,
    required int amount,
    required ChangeOrderStatusViewModel vm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 💰 Icon
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.payments,
                  color: Colors.green,
                  size: 32,
                ),
              ),

              const SizedBox(height: 14),

              // Title
              const Text(
                "Collect Cash",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 8),

              // Amount
              Text(
                "Please collect ₹$amount from customer",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  // ❌ Cancel
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // ✅ Cash Collected
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        RingtoneService().playNotification();
                        Navigator.pop(context);

                        vm.changeOrderStatusApi(
                          orderId,
                          3, // Payment Done
                          "",
                          "",
                          context,
                        );
                      },
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Cash Collected",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
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
  }

  @override
  Widget build(BuildContext context) {
    final bookingVm = Provider.of<CompleteBookingViewModel>(context);
    final changeVm = Provider.of<ChangeOrderStatusViewModel>(context);

    if (bookingVm.completeBookingModel?.data == null) {
      return Scaffold(
        body: Container(
          color: Colors.grey[50],
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
      );
    }

    return Scaffold(
      backgroundColor: AppColor.whiteDark,
      appBar: AppBar(
        backgroundColor: AppColor.royalBlue,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: AppColor.white),
        ),
        title: const TextConst(
          title: "Accept Booking",
          color: Colors.white,
          size: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: RefreshIndicator(
        color: AppColor.royalBlue,
        onRefresh: _refreshBookings,
        child: bookingVm.completeBookingModel!.data!.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  _noDataFound(),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: bookingVm.completeBookingModel!.data!.length,
                itemBuilder: (_, index) {
                  final booking = bookingVm.completeBookingModel!.data![index];
                  final int status =
                      int.tryParse(booking.serviceStatus.toString()) ?? 0;
                  final int orderId = booking.id;
                  final int payMode =
                      int.tryParse(booking.payMode.toString()) ?? 0;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 8),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ---------- TOP ROW ----------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                booking.serviceImage ?? "",
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextConst(
                                        title: "#${booking.id}",
                                        size: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(
                                            0.15,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          border: Border.all(
                                            color: Colors.orange,
                                          ),
                                        ),
                                        child: const Text(
                                          "Pending",
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    height: 20,
                                    child: Marquee(
                                      text: booking.serviceName ?? "N/A",
                                      blankSpace: 40,
                                      velocity: 25,
                                      style: const TextStyle(
                                        fontFamily: AppFonts.kanitReg,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextConst(
                                    title: "₹ ${booking.amount ?? 0}",
                                    size: 18,
                                    color: AppColor.royalBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        infoRow(
                          "Address:",
                          booking.serviceAddress ?? "",
                          showMapIcon: true,
                          onMapTap: () {
                            MapUtils.openGoogleMapDirections(
                              destLat: double.parse(booking.serviceLatitude),
                              destLng: double.parse(booking.serviceLongitude),
                            );
                          },
                        ),

                        infoRow("Date:", booking.serviceDatetime ?? ""),
                        infoRow("Customer:", booking.userName ?? ""),
                        infoRow(
                          "Payment:",
                          getPaymentModeText(booking.payMode),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _expandedMap[booking.id] =
                                  !(_expandedMap[booking.id] ?? false);
                            });
                          },
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              (_expandedMap[booking.id] ?? false)
                                  ? "Hide Details"
                                  : "View Order Detail",
                              style: const TextStyle(
                                color: AppColor.royalBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        if (_expandedMap[booking.id] ?? false) ...[
                          const SizedBox(height: 12),

                          Container(
                            width: Sizes.screenWidth,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _detailRow("Customer Name :", booking.userName),
                                _detailRow(
                                  "Customer Mobile :",
                                  booking.userMobile,
                                ),
                                _detailRow("Address :", booking.serviceAddress),
                                _detailRow("Amount :", "₹${booking.amount}"),
                                _detailRow("GST :", "₹${booking.gstCharges}"),
                                _detailRow(
                                  "Final Amount :",
                                  "₹${booking.finalAmount}",
                                ),
                                _detailRow(
                                  "Payment Mode",
                                  getPaymentModeText(booking.payMode),
                                ),
                                _detailRow(
                                  "Service Date",
                                  booking.serviceDatetime,
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // 👤 User Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booking.userName ?? "N/A",
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          booking.userMobile ?? "",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 📞 CALL BUTTON
                                  InkWell(
                                    onTap: () {
                                      CallUtils.makePhoneCall(
                                        booking.userMobile ?? "",
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColor.royalBlue.withOpacity(
                                          0.1,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.call,
                                        color: AppColor.royalBlue,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),
                            ],
                          ),
                        ),

                        // 👇 VIEW MORE
                        const SizedBox(height: 14),

                        /// ---------- STATUS BASED UI ----------
                        if (status == 1) ...[
                          const Text(
                            "Enter OTP",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          otpField(),
                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () =>
                                      showRejectDialog(orderId, changeVm),
                                  child: Container(
                                    height: 46,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.red),
                                    ),
                                    child: const TextConst(
                                      title: "Reject",
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: actionButton(
                                  title: "Verify & Start",
                                  loading: changeVm.isLoading(orderId),
                                  onTap: () {
                                    changeVm.changeOrderStatusApi(
                                      orderId,
                                      2,
                                      otpController.text,
                                      "",
                                      context,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],

                        if (status == 2) ...[
                          serviceStartedMessage(),

                          if (payMode == 2)
                            actionButton(
                              title: "Work Completed Collect Cash",
                              loading: false,
                              onTap: () {
                                showCollectCashDialog(
                                  orderId: orderId,
                                  amount: booking.amount ?? 0,
                                  vm: changeVm,
                                );
                              },
                            )
                          /// 🔵 ONLINE / WALLET → COMPLETE SERVICE
                          else
                            SlideToButton(
                              title: "Update Complete Status",
                              onAccepted: () {
                                changeVm.changeOrderStatusApi(
                                  orderId,
                                  3,
                                  "",
                                  "",
                                  context,
                                );
                              },
                            ),
                        ],

                        if (status == 3)
                          actionButton(
                            title: "Waiting for User Payment",
                            loading: false,
                            onTap: () {},
                          ),

                        if (status == 4)
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const TextConst(
                              title: "Service Completed • Payment Done",
                              color: Colors.green,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _noDataFound() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [NoDataFound()],
      ),
    );
  }

  Widget otpField() => Container(
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextField(
      controller: otpController,
      maxLength: 4,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: "• • • •",
        counterText: "",
        border: InputBorder.none,
      ),
    ),
  );

  Widget actionButton({
    required String title,
    required bool loading,
    required VoidCallback onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.royalBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.royalBlue),
      ),
      child: loading
          ? CustomLoader(color: AppColor.royalBlue)
          : TextConst(
              title: title,
              color: AppColor.royalBlue,
              fontWeight: FontWeight.w600,
            ),
    ),
  );

  Widget infoRow(
      String label,
      String value, {
        bool marquee = false,
        bool showMapIcon = false,
        VoidCallback? onMapTap,
      }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: AppFonts.kanitReg,
                  color: Colors.black54,
                ),
              ),
            ),

            /// TEXT
            Expanded(
              child: marquee
                  ? SizedBox(
                height: 20,
                child: Marquee(
                  text: value,
                  blankSpace: 40,
                  velocity: 25,
                ),
              )
                  : Text(
                value,
                style: const TextStyle(
                  fontFamily: AppFonts.kanitReg,
                ),
              ),
            ),

            /// 📍 MAP ICON (ONLY FOR ADDRESS)
            if (showMapIcon) ...[
              const SizedBox(width: 8),
              InkWell(
                onTap: onMapTap,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.royalBlue.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    size: 18,
                    color: AppColor.royalBlue,
                  ),
                ),
              ),
            ],
          ],
        ),
      );

  String getPaymentModeText(dynamic payMode) {
    switch (int.tryParse(payMode?.toString() ?? "") ?? 0) {
      case 1:
        return "Pay Online";
      case 2:
        return "Pay Offline";
      case 3:
        return "Wallet";
      default:
        return "N/A";
    }
  }

  Widget serviceStartedMessage() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: const Text(
        "Service has started successfully. Please complete the job and update the status once done.",
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _detailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextConst(title: title, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 15),
          Expanded(
            child: TextConst(
              title: value?.toString() ?? "-",
              size: 15,
              fontWeight: FontWeight.w600,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
