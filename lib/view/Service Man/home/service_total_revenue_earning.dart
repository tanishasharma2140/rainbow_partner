import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/text_const.dart';

class ServiceTotalRevenueEarning extends StatefulWidget {
  const ServiceTotalRevenueEarning({super.key});

  @override
  State<ServiceTotalRevenueEarning> createState() => _ServiceTotalRevenueEarningState();
}

class _ServiceTotalRevenueEarningState extends State<ServiceTotalRevenueEarning> {

  List<Map<String, dynamic>> earningList = [
    {
      "title": "Plumbing Service",
      "amount": "+ ₹300",
      "date": "12 Jan, 2025 • 04:20 PM",
    },
    {
      "title": "Home Cleaning",
      "amount": "+ ₹650",
      "date": "11 Jan, 2025 • 01:45 PM",
    },
    {
      "title": "Washing Machine Repair",
      "amount": "+ ₹499",
      "date": "10 Jan, 2025 • 10:15 AM",
    },
    {
      "title": "Electrician Work",
      "amount": "+ ₹199",
      "date": "09 Jan, 2025 • 07:40 PM",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

        /// ---------------- APPBAR ----------------
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
              const TextConst(
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColor.royalBlue, // CHANGED
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.royalBlue.withOpacity(0.4), // CHANGED
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    TextConst(
                      title: "Total Earnings",
                      size: 16,
                      color: Colors.white70,
                    ),
                    SizedBox(height: 8),
                    TextConst(
                      title: "₹ 1,648",
                      size: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              /// ---------------- SUMMARY ROW ----------------
              Row(
                children: [
                  _summaryBox("Today", "₹ 300"),
                  const SizedBox(width: 12),
                  _summaryBox("Week", "₹ 1,448"),
                  const SizedBox(width: 12),
                  _summaryBox("Month", "₹ 4,699"),
                ],
              ),

              const SizedBox(height: 25),

              const TextConst(
                title: "Recent Earnings",
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
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColor.royalBlue.withOpacity(0.15), // CHANGED
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.royalBlue.withOpacity(0.2), // CHANGED
                              ),
                              child: Icon(
                                Icons.home_repair_service_rounded,
                                color: AppColor.royalBlue, // CHANGED
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
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ],
                        ),

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

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- SUMMARY BOX ----------------
  Widget _summaryBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColor.royalBlue.withOpacity(0.3), // CHANGED
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: const Offset(0, 3),
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
              color: AppColor.royalBlue, // CHANGED
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
