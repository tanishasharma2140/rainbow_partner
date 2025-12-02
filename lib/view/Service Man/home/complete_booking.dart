import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';

class CompleteBooking extends StatefulWidget {
  const CompleteBooking({super.key});

  @override
  State<CompleteBooking> createState() => _CompleteBookingState();
}

class _CompleteBookingState extends State<CompleteBooking> {
  List<Map<String, dynamic>> bookings = [
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
                  title:
                  "Booking's",
                  color: Colors.white, size: 20, fontWeight: FontWeight.w600
              ),
            ],
          ),
        ),

        // ------------------- BODY -------------------
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),

              // ---------------- BOOKINGS LIST ----------------
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final b = bookings[index];
                  return bookingCard(b);
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------- BOOKING CARD -------------------
  Widget bookingCard(Map<String, dynamic> b) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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

          // -------- TOP ROW (IMAGE + STATUS) --------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  b["image"],
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // ID
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: TextConst(
                            title: b["id"],
                            size: 13,
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Status
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green),
                          ),
                          child: TextConst(
                            title: b["status"],
                            size: 13,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    TextConst(
                      title: b["title"],
                      size: 17,
                      fontWeight: FontWeight.w600,
                    ),

                    const SizedBox(height: 5),

                    TextConst(
                      title: b["price"],
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

          // -------- ADDRESS (MARQUEE) --------
// -------- ADDRESS (MARQUEE) --------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 95, // FIXED LABEL WIDTH
                child: const Text(
                  "Address:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.kanitReg,
                    color: Colors.black54,
                  ),
                ),
              ),

              Expanded(
                child: SizedBox(
                  height: 22,
                  child: Marquee(
                    text: b["address"],
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: AppFonts.kanitReg,
                    ),
                    scrollAxis: Axis.horizontal,
                    blankSpace: 40,
                    velocity: 25,
                    pauseAfterRound: Duration(seconds: 1),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

// -------- DATE & TIME --------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 95,
                child: Text(
                  "Date & Time:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.kanitReg,
                    color: Colors.black54,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  b["datetime"],
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: AppFonts.kanitReg,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

// -------- CUSTOMER --------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 95,
                child: Text(
                  "Customer:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.kanitReg,
                    color: Colors.black54,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  b["customer"],
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: AppFonts.kanitReg,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

// -------- PAYMENT STATUS --------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 95,
                child: Text(
                  "Payment Status:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.kanitReg,
                    color: Colors.black54,
                  ),
                ),
              ),

              Expanded(
                child: Text(
                  b["payment"],
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: AppFonts.kanitReg,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

}
