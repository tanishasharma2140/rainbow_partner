import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Man/home/service_booking_detail.dart';

class ServiceTotalBooking extends StatefulWidget {
  const ServiceTotalBooking({super.key});

  @override
  State<ServiceTotalBooking> createState() => _ServiceTotalBookingState();
}

class _ServiceTotalBookingState extends State<ServiceTotalBooking> {
  // ---------------- BOOKING LISTS ----------------
  List<Map<String, dynamic>> pending = [
    {
      "id": "#12",
      "status": "Pending",
      "title": "AC Repair",
      "price": "₹250.00",
      "image": "assets/ac_maintenance.png",
      "address": "Sector 21, Noida, Uttar Pradesh",
      "datetime": "05 March, 2024 at 11:00 AM",
      "customer": "Rahul Verma",
      "payment": "Pending",
    },
  ];

  List<Map<String, dynamic>> completed = [
    {
      "id": "#27",
      "status": "Completed",
      "title": "Filter Replacement",
      "price": "₹80.00",
      "image": "assets/custom_cake_creation.png",
      "address": "001 Thornridge Cir. Shiloh, Hawaii 81063",
      "datetime": "02 February, 2022 at 8:30 AM",
      "customer": "Ped Norris",
      "payment": "Paid by Cash",
    },
    {
      "id": "#27",
      "status": "Completed",
      "title": "Filter Replacement",
      "price": "₹80.00",
      "image": "assets/facial.png",
      "address": "001 Thornridge Cir. Shiloh, Hawaii 81063",
      "datetime": "02 February, 2022 at 8:30 AM",
      "customer": "Ped Norris",
      "payment": "Paid by Cash",
    },
  ];

  List<Map<String, dynamic>> rejected = [
    {
      "id": "#07",
      "status": "Rejected",
      "title": "Water Leakage Repair",
      "price": "₹120.00",
      "image": "assets/plumbing.png",
      "address": "Near DLF Phase 3, Gurugram",
      "datetime": "14 Jan, 2024 at 4:00 PM",
      "customer": "Ankit Sharma",
      "payment": "Not Paid",
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                title: "Total Booking's",
                color: Colors.white,
                size: 20,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),

        // ---------------- BODY ----------------
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle("Pending Bookings"),
              bookingList(pending),

              const SizedBox(height: 20),

              sectionTitle("Completed Bookings"),
              bookingList(completed),

              const SizedBox(height: 20),

              sectionTitle("Rejected Bookings"),
              bookingList(rejected),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- SECTION TITLE ----------------
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 10),
      child: TextConst(
        title: title,
        size: 19,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ---------------- BOOKING LIST ----------------
  Widget bookingList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return const Text(
        "No bookings available!",
        style: TextStyle(color: Colors.grey, fontSize: 15),
      );
    }

    return Column(
      children: List.generate(list.length, (index) {
        return bookingCard(list[index]);
      }),
    );
  }

  // ---------------- BOOKING CARD ----------------
  Widget bookingCard(Map<String, dynamic> b) {
    Color statusColor = Colors.orange;
    if (b["status"] == "Completed") statusColor = Colors.green;
    if (b["status"] == "Rejected") statusColor = Colors.red;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => ServiceBookingDetail(data: b),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    b["image"],
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                // DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextConst(
                            title: b["id"],
                            size: 15,
                            fontWeight: FontWeight.w600,
                          ),

                          // STATUS BADGE
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: statusColor),
                            ),
                            child: Text(
                              b["status"],
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // TITLE WITH MARQUEE
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 20,
                        child: Marquee(
                          text: b["title"],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.kanitReg,
                            color: Colors.black,
                          ),
                          blankSpace: 50,
                          velocity: 30,
                          pauseAfterRound: Duration(seconds: 1),
                        ),
                      ),

                      const SizedBox(height: 2),

                      TextConst(
                        title: b["price"],
                        size: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.royalBlue,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            infoRow("Address:", b["address"], marquee: true),
            const SizedBox(height: 8),

            infoRow("Date:", b["datetime"]),
            const SizedBox(height: 8),

            infoRow("Customer:", b["customer"]),
            const SizedBox(height: 8),

            infoRow("Payment:", b["payment"]),
          ],
        ),
      ),
    );
  }

  // ---------------- INFO ROW ----------------
  Widget infoRow(String title, String value, {bool marquee = false}) {
    return Row(
      children: [
        SizedBox(
          width: 95,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
              fontFamily: AppFonts.kanitReg,
            ),
          ),
        ),

        Expanded(
          child: marquee
              ? SizedBox(
            height: 20,
            child: Marquee(
              text: value,
              style: const TextStyle(
                  fontFamily: AppFonts.kanitReg, color: Colors.black),
              blankSpace: 40,
              velocity: 25,
              pauseAfterRound: Duration(seconds: 1),
            ),
          )
              : Text(
            value,
            style: const TextStyle(
                fontFamily: AppFonts.kanitReg, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
