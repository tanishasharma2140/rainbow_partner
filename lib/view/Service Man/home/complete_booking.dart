import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/service_man/complete_booking_view_model.dart';

class CompleteBooking extends StatefulWidget {
  const CompleteBooking({super.key});

  @override
  State<CompleteBooking> createState() => _CompleteBookingState();
}

class _CompleteBookingState extends State<CompleteBooking> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompleteBookingViewModel>(context, listen: false)
          .completeBookingApi([4, 5, 6], context);
    });
  }

  // ---------------- DATE FORMAT ----------------
  String formatDateTime(dynamic value) {
    if (value == null) return "--";
    try {
      DateTime dateTime = DateTime.parse(value.toString());
      int hour = dateTime.hour;
      int minute = dateTime.minute;
      String amPm = hour >= 12 ? "PM" : "AM";
      hour = hour % 12 == 0 ? 12 : hour % 12;
      String min = minute < 10 ? "0$minute" : minute.toString();

      return "${dateTime.day.toString().padLeft(2, '0')}-"
          "${dateTime.month.toString().padLeft(2, '0')}-"
          "${dateTime.year}  $hour:$min $amPm";
    } catch (e) {
      return value.toString();
    }
  }

  // ---------------- STATUS TEXT ----------------
  String getServiceStatusText(dynamic status, AppLocalizations loc) {
    switch (status?.toString()) {
      case "4":
        return loc.completed;
      case "5":
        return loc.cancelled_by_user;
      case "6":
        return loc.rejected_by_me;
      default:
        return loc.completed;
    }
  }

  Color getServiceStatusColor(dynamic status) {
    switch (status?.toString()) {
      case "5":
      case "6":
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CompleteBookingViewModel>(context);
    final loc = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.whiteDark,
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              TextConst(
                title: loc.booking_history,
                color: Colors.white,
                size: 20,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),

        // ---------------- BODY ----------------
        body: Builder(
          builder: (context) {
            // 1️⃣ Loader
            if (vm.loading) {
              return  Container(
                // color: Colors.grey[50],
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
              );
            }

            // 2️⃣ No Data Found
            if (vm.completeBookingModel == null ||
                vm.completeBookingModel!.data == null ||
                vm.completeBookingModel!.data!.isEmpty) {
              return _noDataFound(loc);
            }

            // 3️⃣ Data Available
            return ListView.builder(
              padding: const EdgeInsets.only(top: 15),
              itemCount: vm.completeBookingModel!.data!.length,
              itemBuilder: (context, index) {
                final completeVm = vm.completeBookingModel!.data![index];
                final status = completeVm.serviceStatus;

                return Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE + DETAILS
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              completeVm.serviceImage ?? "",
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 90,
                                width: 90,
                                color: Colors.grey.shade300,
                                child:
                                const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        border: Border.all(
                                            color:
                                            Colors.grey.shade400),
                                      ),
                                      child: TextConst(
                                        title:
                                        "#${completeVm.id ?? ""}",
                                        size: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: getServiceStatusColor(
                                            status)
                                            .withOpacity(0.2),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        border: Border.all(
                                            color:
                                            getServiceStatusColor(
                                                status)),
                                      ),
                                      child: TextConst(
                                        title:
                                        getServiceStatusText(status, loc),
                                        size: 12,
                                        color:
                                        getServiceStatusColor(status),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 22,
                                  child: Marquee(
                                    text: completeVm.serviceName ?? "N/A",
                                    blankSpace: 40,
                                    velocity: 25,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppFonts.kanitReg,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextConst(
                                  title:
                                  "₹${completeVm.finalAmount ?? 0}",
                                  size: 18,
                                  color: AppColor.royalBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      infoRow(
                        "${loc.address}:",
                        marquee: true,
                        value: completeVm.serviceAddress ??
                            loc.address_not_available,
                      ),
                      infoRow(
                        "${loc.date_time}:",
                        value: formatDateTime(
                            completeVm.serviceDatetime),
                      ),
                      infoRow(
                        "${loc.customer}:",
                        value:
                        completeVm.servicemanName ?? "N/A",
                      ),

                      if (status == 5 || status == 6)
                        infoRow(
                          "${loc.reason}:",
                          value: completeVm.cancelReason ??
                              loc.reason_not_available,
                        )
                      else
                        infoRow(
                          "${loc.payment_status}:",
                          value:
                          getPaymentStatusText(completeVm.payMode, loc),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String getPaymentStatusText(dynamic payMode, AppLocalizations loc) {
    switch (int.tryParse(payMode?.toString() ?? "") ?? 0) {
      case 1:
        return loc.online_payment;
      case 2:
        return loc.offline_payment;
      case 3:
        return loc.by_wallet;
      default:
        return "N/A";
    }
  }

  // ---------------- NO DATA ----------------
  Widget _noDataFound(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_rounded, size: 60, color: Colors.grey),
          SizedBox(height: 12),
          TextConst(
            title: loc.no_data_found,
            size: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  // ---------------- COMMON ROW ----------------
  Widget infoRow(String label,
      {required String value, bool marquee = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.kanitReg,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: marquee
                ? SizedBox(
              height: 22,
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
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
