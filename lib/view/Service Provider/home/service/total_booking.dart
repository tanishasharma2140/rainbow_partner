import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';

class TotalBooking extends StatefulWidget {
  const TotalBooking({super.key});

  @override
  State<TotalBooking> createState() => _TotalBookingState();
}

class _TotalBookingState extends State<TotalBooking> {
  List<Map<String, dynamic>> bookings = [
    {
      "img": "assets/custom_cake_creation.png",
      "bookingNo": "#1",
      "status": "Pending",
      "title": "Custom Cake Creations",
      "price": "\₹39.28",
      "oldPrice": "\₹35.00/hr",
      "discount": "(4% Off)",
      "address": "Bubu, 112 Street, City Name, Country Name",
      "date": "December 1, 2025 at 12:16 PM",
      "customer": "Pedro Norris",
      "payment": "",
    },
    {
      "img": "assets/home_sanitizing.png",
      "bookingNo": "#2",
      "status": "Waiting",
      "title": "Family & Couple's Portraits",
      "price": "\₹54.40",
      "oldPrice": "",
      "discount": "(4% Off)",
      "address": "Nkk, 128 Street Long Address Example",
      "date": "December 19, 2025 at 12:18 PM",
      "customer": "Pedro Norris",
      "payment": "",
    },
    {
      "img": "assets/home_sanitizing.png",
      "bookingNo": "#6",
      "status": "Completed",
      "title": "Kitchen & Bathroom Deep Cleaning",
      "price": "\₹42.30",
      "oldPrice": "",
      "discount": "(4% Off)",
      "address": "268 Rue CE0002NKO, Yaoundé, Région du Centre",
      "date": "December 1, 2025 at 9:03 AM",
      "customer": "Pedro Norris",
      "payment": "Paid by Cash",
      "workerName": "Felix Harris",
      "workerRole": "Handyman",
      "workerImg": "assets/dummy.jpg",
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
                  "Total Booking",
                  color: Colors.white, size: 20, fontWeight: FontWeight.w600
              ),
            ],
          ),
        ),

        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemCount: bookings.length,
          itemBuilder: (_, index) {
            final b = bookings[index];
            return bookingCard(b);
          },
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // 🔥 BOOKING CARD UI (Automatic based on Pending / Waiting / Completed)
  // ------------------------------------------------------------------
  Widget bookingCard(Map<String, dynamic> b) {
    Color statusColor =
    b["status"] == "Pending" ? Colors.red :
    b["status"] == "Completed" ? Colors.green :
    Colors.blue;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TOP ROW ----------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  b["img"],
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TAGS ROW
                    Row(
                      children: [
                        tag(b["bookingNo"], Colors.blue),
                        const SizedBox(width: 8),
                        tag(b["status"], statusColor),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // TITLE (Marquee)
                    SizedBox(
                      height: 20,
                      child: Marquee(
                        text: b["title"],
                        velocity: 30,
                        blankSpace: 40,
                        style: const TextStyle(
                          fontFamily: AppFonts.kanitReg,
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // PRICE + DISCOUNT
                    Row(
                      children: [
                        Text(
                          b["price"],
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue),
                        ),
                        if (b["oldPrice"] != "")
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              b["oldPrice"],
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ),
                        const SizedBox(width: 6),
                        Text(b["discount"],
                            style: const TextStyle(color: Colors.green)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xffF9F9F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                detailRow("Address:", b["address"], marquee: true),
                detailRow("Date & Time:", b["date"]),
                detailRow("Customer:", b["customer"]),
                if (b["status"] == "Completed")
                  detailRow("Payment Status:", b["payment"],
                      valueColor: Colors.green),
              ],
            ),
          ),

          // Worker info for completed
          if (b["status"] == "Completed") ...[
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(b["workerImg"]),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextConst(title: b["workerName"],
                        size: 16, fontWeight: FontWeight.w600),
                    TextConst(title: b["workerRole"],
                        color: Colors.grey),
                  ],
                )
              ],
            ),
          ],

          const SizedBox(height: 16),

          // ---------------- BUTTONS ----------------
          if (b["status"] == "Pending") buttonsRow(),
        ],
      ),
    );
  }

  // TAG UI
  Widget tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: TextConst(title: text,
          color: color, size: 12, fontWeight: FontWeight.w600),
    );
  }

  // DETAIL ROW
  Widget detailRow(String label, String value,
      {bool marquee = false, Color valueColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
              width: 110,
              child:
              TextConst(title: label,color: Colors.grey)),
          Expanded(
            child: marquee
                ? SizedBox(
              height: 18,
              child: Marquee(
                text: value,
                velocity: 25,
                style: TextStyle(color: valueColor,fontFamily: AppFonts.kanitReg),
              ),
            )
                : Text(value, style: TextStyle(color: valueColor,fontFamily: AppFonts.kanitReg)),
          ),
        ],
      ),
    );
  }

  // BUTTONS (Only for Pending)
  Widget buttonsRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColor.royalBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
                child: TextConst(title: "Accept",
                    color: Colors.white, size: 16)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(12),
            ),
            child:  Center(
                child: TextConst(title: "Decline",
                    color: AppColor.black, size: 16)),
          ),
        ),
      ],
    );
  }
}
