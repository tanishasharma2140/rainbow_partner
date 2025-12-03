import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';

class TotalRevenueEarning extends StatefulWidget {
  const TotalRevenueEarning({super.key});

  @override
  State<TotalRevenueEarning> createState() => _TotalRevenueEarningState();
}

class _TotalRevenueEarningState extends State<TotalRevenueEarning> {

  List<Map<String, dynamic>> earningList = [
    {
      "title": "Home Cleaning",
      "amount": "+ ₹450",
      "date": "12 Jan, 2025 • 02:40 PM",
    },
    {
      "title": "Electrician Service",
      "amount": "+ ₹299",
      "date": "11 Jan, 2025 • 06:22 PM",
    },
    {
      "title": "AC Repair",
      "amount": "+ ₹799",
      "date": "10 Jan, 2025 • 09:55 AM",
    },
    {
      "title": "Plumbing Work",
      "amount": "+ ₹199",
      "date": "09 Jan, 2025 • 11:10 AM",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

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
                title: "Earning List",
                color: Colors.white,
                size: 20,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ---------------- TOTAL EARNING CARD ----------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColor.royalBlue,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.royalBlue.withOpacity(0.4),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    TextConst(
                      title: "Total Revenue",
                      size: 16,
                      color: Colors.white70,
                    ),
                    SizedBox(height: 8),
                    TextConst(
                      title: "₹ 2,890",
                      size: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              /// ---------------- SUMMARY CARDS ----------------
              Row(
                children: [
                  _summaryCard("Today", "₹ 450"),
                  const SizedBox(width: 12),
                  _summaryCard("This Week", "₹ 1,499"),
                  const SizedBox(width: 12),
                  _summaryCard("This Month", "₹ 2,890"),
                ],
              ),

              const SizedBox(height: 25),

              const TextConst(
                title: "Earning History",
                size: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),

              const SizedBox(height: 14),

              /// ---------------- EARNING LIST ----------------
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: earningList.length,
                itemBuilder: (context, index) {
                  final item = earningList[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        /// LEFT
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.royalBlue.withOpacity(0.15),
                              ),
                              child: const Icon(
                                Icons.currency_rupee,
                                color: AppColor.royalBlue,
                                size: 22,
                              ),
                            ),

                            const SizedBox(width: 14),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextConst(
                                  title: item["title"],
                                  size: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                const SizedBox(height: 3),
                                TextConst(
                                  title: item["date"],
                                  size: 12,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                          ],
                        ),

                        /// RIGHT AMOUNT
                        TextConst(
                          title: item["amount"],
                          size: 17,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- SUMMARY CARD WIDGET ----------------
  Widget _summaryCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColor.royalBlue.withOpacity(0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [
            TextConst(
              title: title,
              size: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 6),
            TextConst(
              title: value,
              size: 16,
              color: AppColor.royalBlue,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
