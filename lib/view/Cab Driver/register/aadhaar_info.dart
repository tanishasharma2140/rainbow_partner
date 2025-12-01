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
import 'package:rainbow_partner/view/Cab%20Driver/register/vehicle_information.dart';

class AadhaarInfo extends StatefulWidget {
  const AadhaarInfo({super.key});

  @override
  State<AadhaarInfo> createState() => _AadhaarInfoState();
}

class _AadhaarInfoState extends State<AadhaarInfo> {
  File? aadhaarFront;
  File? aadhaarBack;

  TextEditingController aadhaarNumberController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  // IMAGE PICKER
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

  // BOTTOM SHEET
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
                title: const Text("Select from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(onSelected, false);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColor.royalBlue),
                title: const Text("Take Photo"),
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

  // COMMON IMAGE BOX
  Widget _imageBox({
    required File? image,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 105,
            width: 105,
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
          Text(
            label,
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // TEXT FIELD
  Widget _aadhaarField() {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      margin: const EdgeInsets.only(top: 25),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: aadhaarNumberController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: "Aadhaar card number",
          hintStyle: TextStyle(fontFamily: AppFonts.kanitReg),
          border: InputBorder.none,
        ),
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

              /// TITLE
              TextConst(
                title: "Aadhaar card",
                size: 25,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 28),

              /// 2 Aadhaar Upload Boxes
              Row(
                children: [
                  _imageBox(
                    image: aadhaarFront,
                    label: "Aadhaar card\nfront side",
                    onTap: () => showPicker((file) => aadhaarFront = file),
                  ),

                  const SizedBox(width: 35),

                  _imageBox(
                    image: aadhaarBack,
                    label: "Aadhaar card\nback side",
                    onTap: () => showPicker((file) => aadhaarBack = file),
                  ),
                ],
              ),

              /// Aadhaar number field
              _aadhaarField(),

              const Spacer(),

              /// FOOTER — (3 of 5)
              Row(
                children: [
                  TextConst(
                    title: "3 of 5",
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
                            width: 65,
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
                        Navigator.push(context, CupertinoPageRoute(builder: (context)=>VehicleInformation()));
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
