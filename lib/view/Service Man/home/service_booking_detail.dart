import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';

class ServiceBookingDetail extends StatefulWidget {
  final Map<String, dynamic> data;

  const ServiceBookingDetail({super.key, required this.data});

  @override
  State<ServiceBookingDetail> createState() => _ServiceBookingDetailState();
}

class _ServiceBookingDetailState extends State<ServiceBookingDetail> {

  void showBookingHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.52,
          minChildSize: 0.52,
          maxChildSize: 0.52,
          builder: (context, controller) {
            return Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 25,
                    spreadRadius: 3,
                    offset: const Offset(0, -5),
                  )
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- DRAG HANDLE ----
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ---- HEADER ----
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      TextConst(
                        title:
                        "Booking History",
                        size: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      TextConst(
                        title:
                        "ID : #123",
                        size: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1.1,
                    height: 1,
                  ),

                  const SizedBox(height: 15),

                  // ---- TIMELINE LIST ----
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: [
                        timelineTile(
                          time: "1:17 PM",
                          date: "6 Feb",
                          title: "New Booking",
                          subtitle: "New Booking Added By Customer",
                          color: Colors.redAccent,
                        ),
                        timelineTile(
                          time: "1:21 PM",
                          date: "6 Feb",
                          title: "Accept Booking",
                          subtitle: "Status Changed From Pending To Accept",
                          color: Colors.green,
                        ),
                        timelineTile(
                          time: "1:22 PM",
                          date: "6 Feb",
                          title: "Assigned Booking",
                          subtitle: "Booking Assigned To Naomie Hackett",
                          color: Colors.orange,
                        ),
                        timelineTile(
                          time: "1:22 PM",
                          date: "6 Feb",
                          title: "Assigned Booking",
                          subtitle: "Booking Assigned To Naomie Hackett",
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final b = widget.data;

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.white,
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
                title: "Booking Detail",
                color: Colors.white,
                size: 18,
                fontWeight: FontWeight.w600,
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    showBookingHistory(context);
                  },
                  child: TextConst(title: "Check Status",color: AppColor.white,)),
              SizedBox(width: 10,)
            ],
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  TextConst(
                      title: "Booking ID",
                      size: 17,
                      color: Colors.black87
                  ),
                  const Spacer(),
                  const TextConst(title: "#987")
                ],
              ),
              Divider(color: Colors.grey[350], thickness: 1),
              const SizedBox(height: 12),

              // ---------------- Title + Image ----------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextConst(
                          title: b["title"],
                          size: 18,
                          color: AppColor.royalBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        const SizedBox(height: 5),
                        infoText("Date :", b["datetime"].split(" at ")[0]),
                        const SizedBox(height: 3),
                        infoText("Time :", b["datetime"].split(" at ")[1]),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      b["image"],
                      height: 88,
                      width: 88,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // ---------------- Duration ----------------
              TextConst(
                title: "Duration :",
                size: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    TextConst(title: "Service taken Time :", color: Colors.black87),
                    TextConst(
                        title: "35 Min",
                        size: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- About Houseman ----------------
              TextConst(
                title: "About Houseman",
                size: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColor.whiteDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 38,
                          backgroundImage: AssetImage("assets/prooo.jpg"),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextConst(
                              title: "Ashutosh Pandey",
                              size: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            const SizedBox(height: 3),
                            const TextConst(
                                title: "Cleaning Expert",
                                size: 13,
                                color: Colors.black54),
                            const SizedBox(height: 3),
                            ratingStars(4.5),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: AppColor.royalBlue.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.call,
                              color: AppColor.royalBlue, size: 18),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    const TextConst(
                      title: "Rate Houseman",
                      color: Colors.green,
                      size: 15,
                      fontWeight: FontWeight.w500,
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- CANCEL BOOKING BUTTON ----------------
              CustomButton(
                  bgColor: AppColor.royalBlue,
                  textColor: AppColor.white,
                  title: "Cancel Booking",
                  onTap: () {}),
              const SizedBox(height: 25),

              // ================= PRICE DETAIL =================
              TextConst(
                title: "Price Detail",
                size: 18,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColor.whiteDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    priceRow("Price", b["price"]),
                    const SizedBox(height: 10),

                    priceRow("Sub Total", "₹120 * 2 = ₹240"),
                    const SizedBox(height: 10),

                    priceRow("Discount (5% off)", "- ₹15.12", col: Colors.green),
                    const SizedBox(height: 10),

                    priceRow("Tax", "₹15.12", col: Colors.red),
                    const SizedBox(height: 10),

                    Divider(color: Colors.grey[400]),
                    const SizedBox(height: 10),

                    priceRow("Total Amount", "₹255.12", bold: true),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              TextConst(
                title: "Reviews",
                size: 18,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 15),

              Column(
                children: List.generate(3, (i) => reviewTile()),
              ),

              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- STAR WIDGET ----------------
  Widget ratingStars(double rating) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating.floor()
                ? Icons.star
                : (index < rating ? Icons.star_half : Icons.star_border),
            color: Colors.amber,
            size: 18,
          );
        }),
        const SizedBox(width: 4),
        TextConst(
          title: rating.toString(),
          size: 14,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  // ---------------- INFO TEXT ----------------
  Widget infoText(String label, String value) {
    return Row(
      children: [
        TextConst(
          title: label,
          size: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        const SizedBox(width: 6),
        TextConst(title: value, size: 13, color: Colors.black87),
      ],
    );
  }

  // ---------------- PRICE ROW ----------------
  Widget priceRow(String title, String value,
      {Color col = Colors.black, bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextConst(title: title,
            size: 14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500),
        TextConst(title: value,
            size: 15,
            color: col,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500),
      ],
    );
  }
  Widget reviewTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundImage: AssetImage("assets/prooo.jpg"),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    TextConst(
                      title: "Leslie Alexander",
                      size: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    Text("02 Dec",
                        style:
                        TextStyle(color: Colors.black54, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 5),
                ratingStars(4.9),
                const SizedBox(height: 5),
                const Text(
                  "Amet minim mollit non deserunt ullamco est sit",
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget timelineTile({
    required String time,
    required String date,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      // margin: const EdgeInsets.only(bottom: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextConst(
                title:
                time,
                size: 14,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
              const SizedBox(height: 3),
              TextConst(
                title:
                date,
                size: 12,
                color: Colors.black54,
              ),
            ],
          ),

          const SizedBox(width: 20),
          Column(
            children: [
              Container(
                height: 13,
                width: 13,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.45),
                      blurRadius: 8,
                      spreadRadius: 1.2,
                    ),
                  ],
                ),
              ),
              Container(
                height: 55,
                width: 2,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),

          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextConst(
                  title:
                  title,
                  size: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                const SizedBox(height: 2),
                TextConst(
                  title:
                  subtitle,
                  size: 13,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



}
