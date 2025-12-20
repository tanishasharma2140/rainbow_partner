import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/service_man/service_get_bank_detail_view_model.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ServiceGetBankDetailViewModel>(
        context,
        listen: false,
      ).serviceBankDetailApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ServicemanProfileViewModel>(context);
    final withdrawVm = Provider.of<WithdrawRequestViewModel>(context);
    final bankVm = Provider.of<ServiceGetBankDetailViewModel>(context);

    final bankData = bankVm.serviceBankDetailModel?.bankDetails;

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
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const TextConst(
                    title: "Withdraw Request",
                    color: Colors.white,
                    size: 20,
                    fontWeight: FontWeight.w600,
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
                  // ---------------- BALANCE ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextConst(
                        title: "Available Balance",
                        size: 16,
                        color: Colors.grey,
                      ),
                      TextConst(
                        title:
                        "₹${profile.servicemanProfileModel?.data?.wallet ?? "0"}",
                        size: 18,
                        color: AppColor.royalBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // ---------------- BANK DETAIL ----------------
                  if (bankData != null) ...[
                    Container(
                      width: Sizes.screenWidth,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColor.whiteDark,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColor.royalBlue.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TextConst(
                            title: "Bank Details",
                            fontWeight: FontWeight.w600,
                            size: 16,
                          ),
                          const SizedBox(height: 10),
                          TextConst(
                            title:
                            "Account Holder: ${bankData.accountHolderName ?? "--"}",
                          ),
                          TextConst(
                            title:
                            "Account Number: ${bankData.accountNumber ?? "--"}",
                          ),
                          TextConst(
                            title: "IFSC Code: ${bankData.ifscCode ?? "--"}",
                          ),
                          TextConst(
                            title:
                            "Bank Name: ${bankData.bankName ?? "--"}",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextConst(
                              title:
                              "Please add bank details before withdrawing",
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (bankData != null) ...[
                    const TextConst(
                      title: "Enter Amount",
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
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter Amount',
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ---------------- WITHDRAW BUTTON ----------------
                    CustomButton(
                      textColor: AppColor.white,
                      bgColor: AppColor.royalBlue,
                      title: "Withdraw",
                      onTap: () {
                        withdrawVm.withdrawRequestApi(
                          amountController.text,
                          context,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ---------------- LOADER ----------------
          if (withdrawVm.loading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Container(
                  height: Sizes.screenHeight * 0.13,
                  width: Sizes.screenWidth * 0.28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: const [
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
