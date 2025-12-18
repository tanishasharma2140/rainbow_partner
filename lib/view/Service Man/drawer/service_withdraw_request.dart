import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_profile_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/withdraw_request_view_model.dart';

class ServiceWithdrawRequest extends StatefulWidget {
  const ServiceWithdrawRequest({super.key});

  @override
  State<ServiceWithdrawRequest> createState() => _ServiceWithdrawRequestState();
}

class _ServiceWithdrawRequestState extends State<ServiceWithdrawRequest> {
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ServicemanProfileViewModel>(context);
    final withdrawRequest = Provider.of<WithdrawRequestViewModel>(context);
    return SafeArea(
      top: false,
      bottom: true,
      child: Stack(
        children: [
          Scaffold(
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
                    children:  [
                      TextConst(
                        title:
                        "Available Balance",
                        size: 16,
                        color: Colors.grey,
                      ),
                      TextConst(
                        title:
                        "₹${profile.servicemanProfileModel?.data?.wallet??"0"}",
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
                    child:  TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter Amount',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),

                  CustomButton(
                      textColor: AppColor.white,
                      bgColor: AppColor.royalBlue,
                      title: "Withdraw", onTap: (){
                        withdrawRequest.withdrawRequestApi(amountController.text, context);
                  }),
                ],
              ),
            ),
          ),
          if (withdrawRequest.loading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  height: Sizes.screenHeight * 0.13,
                  width: Sizes.screenWidth * 0.28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: GradientCirPro(
                      strokeWidth: 6,
                      size: 70,
                      gradient: AppColor.circularIndicator,
                    ),
                  ),
                ),
              ),
            ),

        ],
      ),
    );
  }
}
