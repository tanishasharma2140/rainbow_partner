import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart' show Sizes;
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Man/drawer/service_bank_history.dart';
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
  bool _reAccountObscure = true; // 👈 eye toggle state

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
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const ServiceBankHistory(),
                    ),
                  );
                },
                child: const Icon(Icons.history, color: AppColor.white, size: 27),
              ),
              SizedBox(width: Sizes.screenWidth * 0.04),
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
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                      validator: (v) =>
                      v!.isEmpty ? "Please enter bank name" : null,
                    ),

                    _fieldTitle("Account Number"),
                    _inputBox(
                      controller: accountNumber,
                      hint: "Enter Account Number",
                      keyboard: TextInputType.number,
                      maxLength: 18,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) =>
                      v!.isEmpty ? "Please enter account number" : null,
                    ),

                    _fieldTitle("Re-enter Account Number"),
                    _inputBox(
                      controller: reAccountNumber,
                      hint: "Re-enter account number",
                      maxLength: 18,
                      keyboard: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      obscure: _reAccountObscure, // 👈 toggled by state
                      suffixIcon: IconButton(
                        icon: Icon(
                          _reAccountObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _reAccountObscure = !_reAccountObscure;
                          });
                        },
                      ),
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
                      hint: "Enter Account Holder Name",
                      maxLength: 35,
                      // ✅ Only alphabets and spaces allowed
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
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
                            ifscCode.text,
                            context,
                          );
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
    int? maxLength,
    bool obscure = false,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixIcon, // 👈 added
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
        maxLength: maxLength,
        obscureText: obscure,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          counterText: "",
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintText: hint,
          suffixIcon: suffixIcon, // 👈 added
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontFamily: AppFonts.kanitReg,
          ),
        ),
      ),
    );
  }
}