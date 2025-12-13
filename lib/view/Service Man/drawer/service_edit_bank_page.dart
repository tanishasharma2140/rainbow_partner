import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/model/service_bank_detail_model.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/service_man/service_bank_edit_view_model.dart';

class ServiceEditBankPage extends StatefulWidget {
  final BankDetails bankDetails;

  const ServiceEditBankPage({super.key, required this.bankDetails});

  @override
  State<ServiceEditBankPage> createState() => _ServiceEditBankPageState();
}

class _ServiceEditBankPageState extends State<ServiceEditBankPage> {
  late TextEditingController bankNameCtrl;
  late TextEditingController accNoCtrl;
  late TextEditingController reAccNoCtrl;
  late TextEditingController holderNameCtrl;
  late TextEditingController ifscCtrl;

  int accountType = 1;

  @override
  void initState() {
    super.initState();

    bankNameCtrl = TextEditingController(text: widget.bankDetails.bankName);
    accNoCtrl = TextEditingController(text: widget.bankDetails.accountNumber);
    reAccNoCtrl = TextEditingController(text: widget.bankDetails.accountNumber);
    holderNameCtrl = TextEditingController(
      text: widget.bankDetails.accountHolderName,
    );
    ifscCtrl = TextEditingController(text: widget.bankDetails.ifscCode);

    accountType = widget.bankDetails.type;
  }

  @override
  Widget build(BuildContext context) {
    final bankEditVm = Provider.of<ServiceBankEditViewModel>(context);
    return Scaffold(
      backgroundColor: AppColor.whiteDark,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Icon(Icons.arrow_back,color: AppColor.white,),
        backgroundColor: AppColor.royalBlue,
        elevation: 0,
        title: const TextConst(
          title: "Edit Bank Details",
          color: Colors.white,
          size: 18,
          fontWeight: FontWeight.w600,
        ),
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _input("Bank Name", bankNameCtrl),
                _input("Account Holder Name", holderNameCtrl),
                _input("Account Number", accNoCtrl, isNumber: true),
                _input("Re-enter Account Number", reAccNoCtrl, isNumber: true),
                _input("IFSC Code", ifscCtrl),

                const SizedBox(height: 14),

                const SizedBox(height: 30),

                /// SAVE
                CustomButton(
                  bgColor: AppColor.royalBlue,
                  title: "Save Changes",
                  onTap: () {
                    bankEditVm.serviceBankEditApi(
                      bankNameCtrl.text.trim(),
                      accNoCtrl.text.trim(),
                      reAccNoCtrl.text.trim(),
                      holderNameCtrl.text.trim(),
                      ifscCtrl.text.trim(),
                      context,
                    );
                  },
                ),
              ],
            ),
          ),
          if (bankEditVm.loading)
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

  Widget _input(
    String title,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          label: TextConst(title: title, size: 13, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _typeChip(int value, String title) {
    final bool selected = accountType == value;

    return GestureDetector(
      onTap: () => setState(() => accountType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xff4169E1) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextConst(
          title: title,
          size: 13,
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
