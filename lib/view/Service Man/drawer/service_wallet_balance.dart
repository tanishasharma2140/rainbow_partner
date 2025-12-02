import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_withdraw_request.dart';
import 'package:rainbow_partner/view/Service%20Provider/drawer/withdraw_request.dart';

class ServiceWalletBalance extends StatefulWidget {
  const ServiceWalletBalance({super.key});

  @override
  State<ServiceWalletBalance> createState() => _ServiceWalletBalanceState();
}

class _ServiceWalletBalanceState extends State<ServiceWalletBalance> {
  // Dummy wallet history data
  List<Map<String, dynamic>> history = [
    {
      "title": "Top-up Successful",
      "amount": "+₹50.00",
      "date": "Dec 01, 2025 • 10:15 AM",
      "isCredit": true
    },
    {
      "title": "Withdrawal Request",
      "amount": "-₹20.00",
      "date": "Nov 21, 2025 • 04:30 PM",
      "isCredit": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),

        // ---------------- APP BAR ----------------
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
                  "Wallet History",
                  color: Colors.white, size: 20, fontWeight: FontWeight.w600
              ),
            ],
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- BALANCE CARD ----------------
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.royalBlue,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 18),
                      Container(
                        height: 140,
                        width: 420,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            TextConst(
                                title:
                                "Available Balance",
                                size: 15, color: Colors.grey
                            ),
                            // SizedBox(height: ),
                            TextConst(
                              title:
                              "₹0.00",
                              size: 28,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.poppinsReg,
                              color: AppColor.royalBlue,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Withdraw Button Row
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context)=>ServiceWithdrawRequest()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            TextConst(
                              title:
                              "Withdraw",
                              color: Colors.white,
                              size: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.add_box_rounded,
                                size: 20, color: Colors.white),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ---------------- TITLE ----------------
                TextConst(
                  title:
                  "Wallet History",
                  size: 18,
                  fontWeight: FontWeight.w600,
                ),

                const SizedBox(height: 25),

                // ---------------- CHECK FOR EMPTY ----------------
                history.isEmpty
                    ? buildEmptyHistory()
                    : buildHistoryList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // EMPTY HISTORY UI
  // ---------------------------------------------------------
  Widget buildEmptyHistory() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            "assets/no_history.png",
            height: 120,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          TextConst(
              title:
              "No Wallet History Found",
              size: 18, fontWeight: FontWeight.w600
          ),
          const SizedBox(height: 6),
          TextConst(
              title:
              "You didn’t top-up yet. Top-up your wallet to see here",
              textAlign: TextAlign.center,
              size: 14, color: Colors.grey.shade600
          ),
        ],
      ),
    );
  }

  Widget buildHistoryList() {
    return ListView.separated(
      itemCount: history.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),

      itemBuilder: (context, index) {
        final item = history[index];

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LEFT SIDE
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextConst(
                      title:
                      item["title"],
                      size: 14, fontWeight: FontWeight.w600
                  ),
                  const SizedBox(height: 4),
                  TextConst(
                      title:
                      item["date"],
                      fontFamily: AppFonts.poppinsReg,
                      size: 11, color: Colors.grey.shade600
                  ),
                ],
              ),

              // AMOUNT (Credit / Debit)
              TextConst(
                title:
                item["amount"],
                size: 14,
                fontWeight: FontWeight.bold,
                color: item["isCredit"] ? Colors.green : Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }
}
