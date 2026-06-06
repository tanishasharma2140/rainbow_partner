import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_loader.dart';
import 'package:rainbow_partner/res/map_utils.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/call_utils.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view/service/ringtone_service.dart';
import 'package:rainbow_partner/view_model/service_man/change_order_status_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/change_service_pay_mode_vm.dart';
import 'package:rainbow_partner/view_model/service_man/complete_booking_view_model.dart';
import 'package:rainbow_partner/res/slide_to_button.dart';
import 'package:rainbow_partner/view_model/service_man/payment_view_model.dart';

class AcceptedBooking extends StatefulWidget {
  const AcceptedBooking({super.key});

  @override
  State<AcceptedBooking> createState() => _AcceptedBookingState();
}

class _AcceptedBookingState extends State<AcceptedBooking> {
  final Map<int, TextEditingController> otpControllers = {};

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
  void showRejectDialog(
    int orderId,
    ChangeOrderStatusViewModel vm,
    AppLocalizations l10n,
  ) {
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
              TextConst(
                title: l10n.reject_booking,
                size: 16,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 8),
              TextConst(
                title: l10n.please_mention_rejection_reason,
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
                  decoration: InputDecoration(
                    hintText: l10n.enter_reason,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(14),
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
                        child: Text(l10n.cancel),
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
                            l10n.please_enter_reason,
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
                        child: Text(
                          l10n.reject,
                          style: const TextStyle(color: Colors.white),
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

  void _showPayModeDialog(
    BuildContext context,
    int orderId,
    AppLocalizations l10n,
  ) {
    final changePayModeVm = Provider.of<ChangeServicePayModeVm>(
      context,
      listen: false,
    );
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextConst(
                  title: l10n.change_payment_mode,
                  size: 18,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 8),
                TextConst(
                  title: l10n.please_select_your_preferred_payment_mode,
                  size: 13,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),

                // ---------- PAY ONLINE ----------
                InkWell(
                  onTap: () {
                    changePayModeVm.changePayModeApi(orderId, 1, context).then((
                      value,
                    ) {
                      _refreshBookings();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColor.royalBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColor.royalBlue),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.payment, color: AppColor.royalBlue),
                        const SizedBox(width: 12),
                        Text(
                          l10n.pay_online,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ---------- PAY OFFLINE ----------
                InkWell(
                  onTap: () {
                    changePayModeVm.changePayModeApi(orderId, 2, context).then((
                      value,
                    ) {
                      _refreshBookings();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.money, color: Colors.orange),
                        const SizedBox(width: 12),
                        Text(
                          l10n.pay_offline,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColor.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showCollectCashDialog({
    required int orderId,
    required int amount,
    required ChangeOrderStatusViewModel vm,
    required AppLocalizations l10n,
  }) {
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
            children: [
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
              Text(
                l10n.collect_cash,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.please_collect_amount_from_customer.replaceAll(
                  "₹amount",
                  "₹$amount",
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 22),
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
                        child: Text(l10n.cancel),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        RingtoneService().playNotification();
                        Navigator.pop(context);
                        vm.changeOrderStatusApi(orderId, 3, "", "", context);
                      },
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          l10n.cash_collected,
                          style: const TextStyle(
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

  String formatDistance(dynamic distance, AppLocalizations l10n) {
    if (distance == null) return "--";
    double value = double.tryParse(distance.toString()) ?? 0;
    int kmValue = value.floor();
    int meterValue = ((value - kmValue) * 1000).round();
    if (kmValue == 0) return "$meterValue ${l10n.meter}";
    if (meterValue == 0) return "$kmValue ${l10n.km}";
    return "$kmValue ${l10n.km} $meterValue ${l10n.meter}";
  }

  String formatDateTime(dynamic value) {
    if (value == null || value.toString().isEmpty) return "--";
    try {
      DateTime dateTime = DateTime.parse(value.toString()).toLocal();
      String day = dateTime.day.toString().padLeft(2, '0');
      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      String month = months[dateTime.month - 1];
      String year = dateTime.year.toString();
      int hour = dateTime.hour;
      int minute = dateTime.minute;
      String amPm = hour >= 12 ? "PM" : "AM";
      hour = hour % 12;
      if (hour == 0) hour = 12;
      String minStr = minute.toString().padLeft(2, '0');
      return "$day $month $year, $hour:$minStr $amPm";
    } catch (e) {
      return value.toString();
    }
  }

  String formatPayMode(dynamic payMode, AppLocalizations l10n) {
    switch (int.tryParse(payMode?.toString() ?? "") ?? 0) {
      case 1:
        return l10n.pay_online;
      case 2:
        return l10n.pay_offline;
      case 3:
        return l10n.wallet;
      default:
        return l10n.na;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingVm = Provider.of<CompleteBookingViewModel>(context);
    final changeVm = Provider.of<ChangeOrderStatusViewModel>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColor.whiteDark,
      appBar: AppBar(
        backgroundColor: AppColor.royalBlue,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColor.white),
        ),
        title: TextConst(
          title: l10n.accept_booking,
          color: Colors.white,
          size: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: RefreshIndicator(
        color: AppColor.royalBlue,
        onRefresh: _refreshBookings,
        child: bookingVm.loading
            ? const Center(child: CustomLoader(color: AppColor.royalBlue))
            : bookingVm.completeBookingModel == null ||
                  bookingVm.completeBookingModel!.data == null ||
                  bookingVm.completeBookingModel!.data!.isEmpty
            ? _noDataFound(l10n)
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
                  final int userId = booking.userId ?? 0;
                  final int amount = booking.amount ?? 0;
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
                                        child: Text(
                                          l10n.pending,
                                          style: const TextStyle(
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
                                    title: "₹ ${booking.finalAmount ?? 0}",
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
                          "${l10n.address}:",
                          booking.serviceAddress ?? "",
                          showMapIcon: true,
                          onMapTap: () {
                            MapUtils.openGoogleMapDirections(
                              destLat: double.parse(booking.serviceLatitude),
                              destLng: double.parse(booking.serviceLongitude),
                            );
                          },
                        ),
                        infoRow(
                          "${l10n.date}:",
                          formatDateTime(booking.serviceDatetime),
                        ),
                        infoRow("${l10n.customer}:", booking.userName ?? ""),
                        infoRow(
                          "${l10n.distance}:",
                          formatDistance(booking.distance, l10n),
                        ),
                        infoRow(
                          "${l10n.quantity}:",
                          booking.quantity.toString(),
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
                                  ? l10n.hide_details
                                  : l10n.view_order_detail,
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
                                _detailRow(
                                  "${l10n.customer_name} :",
                                  booking.userName,
                                ),
                                _detailRow(
                                  "${l10n.customer_mobile} :",
                                  booking.userMobile,
                                ),
                                _detailRow(
                                  "${l10n.address} :",
                                  booking.serviceAddress,
                                ),
                                _detailRow(
                                  "${l10n.amount} :",
                                  "₹${booking.amount}",
                                ),
                                _detailRow(
                                  "${l10n.final_amount} :",
                                  "₹${booking.finalAmount}",
                                ),
                                _detailRow(
                                  l10n.payment_mode,
                                  formatPayMode(booking.payMode, l10n),
                                ),
                                _detailRow(
                                  l10n.service_date,
                                  formatDateTime(booking.serviceDatetime),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 10),

                        // CHANGE PAY MODE SECTION
                        if (status == 1 || status == 2)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              onTap: () =>
                                  _showPayModeDialog(context, booking.id, l10n),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColor.royalBlue.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColor.royalBlue.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextConst(
                                            title: l10n.current_pay_mode,
                                            size: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                          const SizedBox(height: 2),
                                          TextConst(
                                            title: formatPayMode(
                                              booking.payMode,
                                              l10n,
                                            ),
                                            size: 14,
                                            fontWeight: FontWeight.w700,
                                            color: AppColor.royalBlue,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    TextConst(
                                      title: l10n.change,
                                      size: 13,
                                      color: AppColor.royalBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        else
                          _detailRow(
                            l10n.payment_mode,
                            formatPayMode(booking.payMode, l10n),
                          ),

                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              InkWell(
                                onTap: () => CallUtils.makePhoneCall(
                                  booking.userMobile ?? "",
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColor.royalBlue.withOpacity(0.1),
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
                        ),

                        const SizedBox(height: 14),

                        /// ---------- STATUS BASED UI ----------
                        if (status == 1) ...[
                          Text(
                            l10n.enter_otp,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          otpField(orderId),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () =>
                                      showRejectDialog(orderId, changeVm, l10n),
                                  child: Container(
                                    height: 46,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.red),
                                    ),
                                    child: TextConst(
                                      title: l10n.reject,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: actionButton(
                                  title: l10n.verify_start,
                                  loading: changeVm.isLoading(orderId),
                                  onTap: () {
                                    changeVm.changeOrderStatusApi(
                                      orderId,
                                      2,
                                      otpControllers[orderId]?.text ?? "",
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
                          serviceStartedMessage(l10n),

                          if (payMode == 2) ...[
                            Consumer<PaymentViewModel>(
                              builder: (context, payment, child) {
                                return GestureDetector(
                                  onTap: payment.loading
                                      ? null
                                      : () {
                                          print(
                                            "DEBUG: Calling Generate QR with userid: $userId",
                                          );

                                          payment.paymentApi(
                                            userId,
                                            amount,
                                            1,
                                            1,
                                            orderId,
                                            context,
                                          );
                                        },
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 14),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.07),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.green.withOpacity(0.3),
                                        width: 1.8,
                                      ),
                                    ),
                                    child: payment.loading
                                        ? SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Colors.green.shade700,
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.qr_code_2_rounded,
                                                color: Colors.green.shade700,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 10),
                                              TextConst(
                                                title: "Generate QR",
                                                size: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green.shade800,
                                              ),
                                            ],
                                          ),
                                  ),
                                );
                              },
                            ),

                            actionButton(
                              title: l10n.work_completed_collect_cash,
                              loading: false,
                              onTap: () {
                                showCollectCashDialog(
                                  orderId: orderId,
                                  amount: booking.amount ?? 0,
                                  vm: changeVm,
                                  l10n: l10n,
                                );
                              },
                            ),
                          ] else
                            SlideToButton(
                              title: l10n.update_complete_status,
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
                            title: l10n.waiting_for_user_payment,
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
                            child: TextConst(
                              title: l10n.service_completed_payment_done,
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

  Widget _noDataFound(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_rounded, size: 60, color: Colors.grey),
          const SizedBox(height: 12),
          TextConst(
            title: l10n.no_data_found,
            size: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget otpField(int orderId) => Container(
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextField(
      controller: otpControllers.putIfAbsent(
        orderId,
        () => TextEditingController(),
      ),
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
          ? const CustomLoader(color: AppColor.royalBlue)
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
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: AppFonts.kanitReg,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: marquee
              ? SizedBox(
                  height: 20,
                  child: Marquee(text: value, blankSpace: 40, velocity: 25),
                )
              : Text(
                  value,
                  style: const TextStyle(fontFamily: AppFonts.kanitReg),
                ),
        ),
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

  Widget serviceStartedMessage(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: Text(
        l10n.service_started_successfully_message,
        style: const TextStyle(
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
