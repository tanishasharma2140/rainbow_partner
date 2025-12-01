import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';

class AddBank extends StatefulWidget {
  const AddBank({super.key});

  @override
  State<AddBank> createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  String selectedStatus = "Active";
  final List<String> statusList = ["Active", "Inactive"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),

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
                  "Add Bank",
                  color: Colors.white, size: 20, fontWeight: FontWeight.w600
              ),
            ],
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bankInputField("Bank Name", Icons.savings_outlined),
                const SizedBox(height: 16),

                bankInputField("Branch name", Icons.savings_outlined),
                const SizedBox(height: 16),

                bankInputField("Account number", Icons.dialpad),
                const SizedBox(height: 16),

                bankInputField("IFSC code", Icons.person_outline),
                const SizedBox(height: 25),

                // STATUS TITLE
                 TextConst(
                   title:
                  "Status",
                   size: 15, fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 8),

                // ---------------- STATUS DROPDOWN ----------------
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColor.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    items: statusList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedStatus = value);
                      }
                    },
                  ),
                ),

                const SizedBox(height: 40),
                CustomButton(
                    bgColor: AppColor.royalBlue,
                    title: "Save", onTap: (){}),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- REUSABLE INPUT FIELD ----------------
  Widget bankInputField(String hint, IconData icon) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColor.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey,fontFamily: AppFonts.kanitReg),
              ),
            ),
          ),
          Icon(icon, color: Colors.grey, size: 22),
        ],
      ),
    );
  }
}
