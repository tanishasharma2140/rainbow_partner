import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';

class ServiceDueWallet extends StatefulWidget {
  const ServiceDueWallet({super.key});

  @override
  State<ServiceDueWallet> createState() => _ServiceDueWalletState();
}

class _ServiceDueWalletState extends State<ServiceDueWallet> {
  List<Map<String, dynamic>> dueHistory = [
    {
      "title": "Service Charge",
      "amount": "- ₹120",
      "date": "12 Jan, 2025",
    },
    {
      "title": "Penalty Applied",
      "amount": "- ₹50",
      "date": "10 Jan, 2025",
    },
    {
      "title": "Subscription Due",
      "amount": "- ₹299",
      "date": "05 Jan, 2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColor.royalBlue,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const TextConst(
                title: "Service Due Wallet",
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

              /// ---------------- UNIQUE TOP CARD ----------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColor.royalBlue.withOpacity(0.3),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.royalBlue.withOpacity(0.15),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.royalBlue.withOpacity(0.12),
                      ),
                      child: const Icon(
                        Icons.handyman,
                        color: AppColor.royalBlue,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        TextConst(
                          title: "Total Due (Service Man)",
                          color: Colors.black54,
                          size: 14,
                        ),
                        SizedBox(height: 6),
                        TextConst(
                          title: "₹ 469",
                          color: AppColor.royalBlue,
                          size: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ---------------- PAY NOW BUTTON ----------------
              CustomButton(
                title: "Clear Due",
                bgColor: AppColor.royalBlue,
                textColor: Colors.white,
                onTap: () {},
              ),

              const SizedBox(height: 32),

              /// ---------------- HISTORY TITLE ----------------
              const TextConst(
                title: "Service Due History",
                size: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),

              const SizedBox(height: 14),

              /// ---------------- HISTORY LIST ----------------
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dueHistory.length,
                itemBuilder: (context, index) {
                  final item = dueHistory[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColor.royalBlue.withOpacity(0.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        )
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
                                color: AppColor.royalBlue.withOpacity(0.15),
                              ),
                              child: const Icon(
                                Icons.build_circle_outlined,
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

                                const SizedBox(height: 4),

                                TextConst(
                                  title: item["date"],
                                  size: 12,
                                  color: Colors.black45,
                                ),
                              ],
                            ),
                          ],
                        ),

                        TextConst(
                          title: item["amount"],
                          size: 17,
                          color: AppColor.royalBlue,
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
}
