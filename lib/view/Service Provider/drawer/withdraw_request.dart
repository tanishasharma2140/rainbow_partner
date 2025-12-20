import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';

class WithdrawRequest extends StatefulWidget {
  const WithdrawRequest({super.key});

  @override
  State<WithdrawRequest> createState() => _WithdrawRequestState();
}

class _WithdrawRequestState extends State<WithdrawRequest> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,

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
                  "Withdraw Request",
                  color: Colors.white, size: 20, fontWeight: FontWeight.w600
              ),
            ],
          ),
        ),

        // ---------------- BODY ----------------
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- BALANCE ROW ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  TextConst(
                    title:
                    "Available Balance",
                    size: 16,
                    color: Colors.grey,
                  ),
                  TextConst(
                    title:
                    "₹0.00",
                      size: 18,
                      color: AppColor.royalBlue,
                      fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              const SizedBox(height: 30),
               TextConst(
                title:
                "Enter Amount",
                size: 17,
                fontWeight: FontWeight.w600,
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColor.whiteDark,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'eg "3000"',
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ---------------- WITHDRAW BUTTON ----------------
             CustomButton(
                 textColor: AppColor.white,
                 bgColor: AppColor.royalBlue,
                 title: "Withdraw", onTap: (){}),
            ],
          ),
        ),
      ),
    );
  }
}
