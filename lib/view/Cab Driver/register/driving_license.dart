import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/aadhaar_info.dart';

class DrivingLicense extends StatefulWidget {
  const DrivingLicense({super.key});

  @override
  State<DrivingLicense> createState() => _DrivingLicenseState();
}

class _DrivingLicenseState extends State<DrivingLicense> {

  File? licenseFront;
  File? licenseBack;

  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController validityDateController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  /// IMAGE PICK
  Future<void> pickImage(Function(File) onSelected, bool fromCamera) async {
    final XFile? file = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
    );

    if (file != null) {
      onSelected(File(file.path));
      setState(() {});
    }
  }

  /// BOTTOM SHEET
  void showPicker(Function(File) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo, color: AppColor.royalBlue),
                title: Text("Select from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(onSelected, false);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColor.royalBlue),
                title: Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(onSelected, true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// UPLOAD BOX
  Widget _imageBox({required File? image, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              image: image != null
                  ? DecorationImage(image: FileImage(image), fit: BoxFit.cover)
                  : null,
            ),
            child: image == null
                ? const Center(child: Icon(Icons.add, size: 32))
                : null,
          ),
          const SizedBox(height: 8),
          TextConst(
            title:
            label,
            size: 13,
            fontFamily: AppFonts.poppinsReg,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _textField({required String hint, required TextEditingController controller}) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      margin: const EdgeInsets.only(top: 18),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        readOnly: hint == "Validity date",
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(fontFamily: AppFonts.kanitReg)
        ),
        onTap: hint == "Validity date"
            ? () async {
          DateTime? picked = await showDatePicker(
            context: context,
            firstDate: DateTime(1950),
            lastDate: DateTime.now().add(const Duration(days: 3650)),
            initialDate: DateTime.now(),
          );
          if (picked != null) {
            controller.text = "${picked.day}/${picked.month}/${picked.year}";
          }
        }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: ConstantAppbar(
          onBack: () => Navigator.pop(context),
          onClose: () => Navigator.pop(context),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: topPadding),

              TextConst(
                title: "Driver license",
                size: 25,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 25),

              /// 2 IMAGE PICKERS ONLY
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _imageBox(
                    image: licenseFront,
                    label: "Driver license\n(front)",
                    onTap: () => showPicker((file) => licenseFront = file),
                  ),

                  const SizedBox(width: 35),

                  _imageBox(
                    image: licenseBack,
                    label: "Driver license\n(back side)",
                    onTap: () => showPicker((file) => licenseBack = file),
                  ),
                ],
              ),

              /// Text Fields
              _textField(
                hint: "Driver license number",
                controller: licenseNumberController,
              ),

              _textField(
                hint: "Validity date",
                controller: validityDateController,
              ),

              const Spacer(),

              /// FOOTER — same as INDrive
              Row(
                children: [
                  TextConst(
                    title: "2 of 5",
                    size: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            decoration: BoxDecoration(
                              color: AppColor.royalBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  SizedBox(
                    height: 50,
                    width: 110,
                    child: CustomButton(
                      bgColor: AppColor.royalBlue,
                      textColor: AppColor.white,
                      title: "Next",
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context)=>AadhaarInfo()));
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
