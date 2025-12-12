import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart' show Sizes;
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/service_man/add_bank_detail_view_model.dart';

class ServiceAddBank extends StatefulWidget {
  const ServiceAddBank({super.key});

  @override
  State<ServiceAddBank> createState() => _ServiceAddBankState();
}

class _ServiceAddBankState extends State<ServiceAddBank> {
  final TextEditingController bankName = TextEditingController();
  final TextEditingController accountNumber = TextEditingController();
  final TextEditingController reAccountNumber = TextEditingController();
  final TextEditingController holderName = TextEditingController();
  final TextEditingController ifscCode = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final serviceAddBankVm = Provider.of<AddBankDetailViewModel>(context);
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
                title: "Add Bank",
                color: Colors.white,
                size: 20,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),

        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _fieldTitle("Bank Name"),
                    _inputBox(
                      controller: bankName,
                      hint: "State Bank of India",
                      validator: (v) =>
                      v!.isEmpty ? "Please enter bank name" : null,
                    ),

                    _fieldTitle("Account Number"),
                    _inputBox(
                      controller: accountNumber,
                      hint: "Enter Account Number",
                      keyboard: TextInputType.number,
                      validator: (v) =>
                      v!.isEmpty ? "Please enter account number" : null,
                    ),

                    _fieldTitle("Re-enter Account Number"),
                    _inputBox(
                      controller: reAccountNumber,
                      hint: "Re-enter account number",
                      keyboard: TextInputType.number,
                      validator: (v) {
                        if (v!.isEmpty) return "Please re-enter account number";
                        if (v != accountNumber.text) {
                          return "Account numbers do not match";
                        }
                        return null;
                      },
                    ),

                    _fieldTitle("Account Holder Name"),
                    _inputBox(
                      controller: holderName,
                      hint: "Enter AccountHolder Name",
                      validator: (v) =>
                      v!.isEmpty ? "Please enter account holder name" : null,
                    ),

                    _fieldTitle("IFSC Code"),
                    _inputBox(
                      controller: ifscCode,
                      hint: "Enter IFSC Code",
                      textCap: TextCapitalization.characters,
                      validator: (v) =>
                      v!.isEmpty ? "Please enter IFSC code" : null,
                    ),

                    const SizedBox(height: 35),

                    CustomButton(
                      bgColor: AppColor.royalBlue,
                      textColor: Colors.white,
                      title: "Submit",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          serviceAddBankVm.addBankDetailApi(
                              1,
                              bankName.text,
                              accountNumber.text,
                              reAccountNumber.text,
                              holderName.text,
                              ifscCode.text, context);
                          // API READY DATA
                          // final bankData = {
                          //   "bank_name": bankName.text,
                          //   "account_number": accountNumber.text,
                          //   "re_account_number": reAccountNumber.text,
                          //   "account_holder_name": holderName.text,
                          //   "ifsc_code": ifscCode.text,
                          // };


                          // TODO: call API here
                        }
                      },
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            if (serviceAddBankVm.loading)
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
      ),
    );
  }

  // ---------------- FIELD TITLE ----------------
  Widget _fieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: TextConst(
        title: title,
        size: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  // ---------------- INPUT BOX ----------------
  Widget _inputBox({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
    TextCapitalization textCap = TextCapitalization.none,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        textCapitalization: textCap,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400,fontFamily: AppFonts.kanitReg),
        ),
      ),
    );
  }
}
