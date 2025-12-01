import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';

class AddHandyman extends StatefulWidget {
  const AddHandyman({super.key});

  @override
  State<AddHandyman> createState() => _AddHandymanState();
}

class _AddHandymanState extends State<AddHandyman> {
  String? selectedCommission;
  String? selectedZone;
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),

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
                  "Add Handyman",
                  color: Colors.white, size: 20, fontWeight: FontWeight.w600
              ),
            ],
          ),
        ),

        // ---------------- BODY ----------------
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              inputField("First Name", Icons.person_outline),
              const SizedBox(height: 15),

              inputField("Last Name", Icons.person_outline),
              const SizedBox(height: 15),

              inputField("User Name", Icons.person_outline),
              const SizedBox(height: 15),

              inputField("Email Address", Icons.mail_outline),
              const SizedBox(height: 15),

              // CONTACT NUMBER ROW
              Row(
                children: [
                  Container(
                    width: 95,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("+91", style: TextStyle(fontSize: 16,fontFamily: AppFonts.kanitReg)),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // CONTACT INPUT
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText: "Contact Number",
                                  hintStyle: TextStyle(fontFamily: AppFonts.kanitReg),
                                  border: InputBorder.none),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Icon(Icons.call_outlined,color: AppColor.grey,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              inputField("Designation", null),
              const SizedBox(height: 15),

              // COMMISSION DROPDOWN
              dropDownField(
                hint: "Select Commission",
                value: selectedCommission,
                onChanged: (v) => setState(() => selectedCommission = v),
              ),

              const SizedBox(height: 15),

              // ZONE DROPDOWN
              dropDownField(
                hint: "Select Service Zone",
                value: selectedZone,
                onChanged: (v) => setState(() => selectedZone = v),
              ),

              const SizedBox(height: 15),

              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Expanded(
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(fontFamily: AppFonts.kanitReg),
                            border: InputBorder.none,
                          ),
                        )),
                    GestureDetector(
                      onTap: () => setState(() => showPassword = !showPassword),
                      child: const Icon(Icons.visibility_off),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

             CustomButton(
                 bgColor: AppColor.royalBlue,
                 textColor: AppColor.white,
                 title: "Save", onTap: (){}),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- CUSTOM INPUT FIELD ----------------
  Widget inputField(String hint, IconData? icon) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration:
              InputDecoration(hintText: hint, border: InputBorder.none,hintStyle: TextStyle(fontFamily: AppFonts.kanitReg)),
            ),
          ),
          if (icon != null) Icon(icon, color: Colors.grey),
        ],
      ),
    );
  }

  // ---------------- DROPDOWN FIELD ----------------
  Widget dropDownField({
    required String hint,
    String? value,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: TextConst(title:hint),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: ["Option 1", "Option 2", "Option 3"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
