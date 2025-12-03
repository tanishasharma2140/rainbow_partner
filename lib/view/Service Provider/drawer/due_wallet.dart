import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';

class DueWallet extends StatefulWidget {
  const DueWallet({super.key});

  @override
  State<DueWallet> createState() => _DueWalletState();
}

class _DueWalletState extends State<DueWallet> {
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
                title: "Due Wallet",
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.royalBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColor.royalBlue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColor.royalBlue.withOpacity(0.15),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: AppColor.royalBlue,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        TextConst(
                          title: "Total Due Amount",
                          color: Colors.black54,
                          size: 14,
                        ),
                        SizedBox(height: 5),
                        TextConst(
                          title: "₹ 469",
                          color: AppColor.royalBlue,
                          size: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 25),

              // ---------------- PAY NOW BUTTON ----------------
              CustomButton(
                title: "Pay Now",
                bgColor: AppColor.royalBlue,
                textColor: Colors.white,
                onTap: () {},
              ),

              const SizedBox(height: 30),

              const TextConst(
                title: "Due History",
                size: 18,
                fontWeight: FontWeight.w600,
              ),

              const SizedBox(height: 14),

              // ---------------- BEAUTIFUL HISTORY CARDS ----------------
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
                                color: Colors.red.withOpacity(0.1),
                              ),
                              child: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
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
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ],
                        ),

                        TextConst(
                          title: item["amount"],
                          size: 17,
                          color: Colors.red,
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
