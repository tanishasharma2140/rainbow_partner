import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_loader.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart';
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
      Provider.of<CompleteBookingViewModel>(context, listen: false)
          .completeBookingApi([1, 2, 3, 4], context);
    });
  }

  // ---------------- REJECT DIALOG ----------------
  void showRejectDialog(int orderId, ChangeOrderStatusViewModel vm) {
    final TextEditingController reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
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
                              context, "Please enter reason");
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

  @override
  Widget build(BuildContext context) {
    final bookingVm = Provider.of<CompleteBookingViewModel>(context);
    final changeVm = Provider.of<ChangeOrderStatusViewModel>(context);

    if (bookingVm.completeBookingModel?.data == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.whiteDark,
      appBar: AppBar(
        backgroundColor: AppColor.royalBlue,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: AppColor.white,)),
        title: const TextConst(
          title: "Live Booking",
          color: Colors.white,
          size: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: bookingVm.completeBookingModel!.data!.length,
        itemBuilder: (_, index) {
          final booking = bookingVm.completeBookingModel!.data![index];
          final int status =
              int.tryParse(booking.serviceStatus.toString()) ?? 0;
          final int orderId = booking.id;

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 8,
                ),
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
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(18),
                                  border:
                                  Border.all(color: Colors.orange),
                                ),
                                child: const Text(
                                  "Pending",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12),
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
                infoRow("Address:", booking.serviceAddress ?? "", marquee: true),
                infoRow("Date:", booking.serviceDatetime ?? ""),
                infoRow("Customer:", booking.userName ?? ""),
                infoRow("Payment:", getPaymentModeText(booking.payMode)),
                const SizedBox(height: 14),

                /// ---------- STATUS BASED UI ----------
                if (status == 1) ...[
                  const Text("Enter OTP",
                      style: TextStyle(fontWeight: FontWeight.w600)),
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
                    padding:
                    const EdgeInsets.symmetric(vertical: 14),
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
  }) =>
      GestureDetector(
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

  Widget infoRow(String label, String value, {bool marquee = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
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
            Expanded(
              child: marquee
                  ? SizedBox(
                height: 20,
                child: Marquee(
                    text: value, blankSpace: 40, velocity: 25),
              )
                  : Text(
                value,
                style: const TextStyle(
                    fontFamily: AppFonts.kanitReg),
              ),
            ),
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

}
