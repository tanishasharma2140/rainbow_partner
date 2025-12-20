import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/view/Cab Driver/register/vehicle_information.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/required_certificate.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_register_three_view_model.dart';

class AadhaarInfo extends StatefulWidget {
  const AadhaarInfo({super.key});

  @override
  State<AadhaarInfo> createState() => _AadhaarInfoState();
}

class _AadhaarInfoState extends State<AadhaarInfo> {
  File? aadhaarFront;
  File? aadhaarBack;

  File? panFront;
  File? panBack;

  TextEditingController aadhaarNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();

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
      shape: const RoundedRectangleBorder(
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
      onTap: () {
        if (image == null) onTap(); // Only open picker if image not selected
      },
      child: Column(
        children: [
          Stack(
            children: [
              /// IMAGE BOX
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

              /// REMOVE BUTTON
              if (image != null)
                Positioned(
                  right: 6,
                  top: 6,
                  child: GestureDetector(
                    onTap: () {
                      /// Remove image
                      if (label.contains("Aadhaar") && label.contains("Front")) {
                        aadhaarFront = null;
                      } else if (label.contains("Aadhaar") && label.contains("Back")) {
                        aadhaarBack = null;
                      } else if (label.contains("PAN") && label.contains("Front")) {
                        panFront = null;
                      } else if (label.contains("PAN") && label.contains("Back")) {
                        panBack = null;
                      }
                      setState(() {});
                    },
                    child: Container(
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          /// LABEL
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
  Widget _inputField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontFamily: AppFonts.kanitReg),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final driverRegisterThreeVm = Provider.of<DriverRegisterThreeViewModel>(context);
    return Stack(
      children: [
        SafeArea(
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
              child: ListView(
                children: [
                  SizedBox(height: topPadding),

                  /// ------------------ AADHAAR SECTION ------------------
                  const TextConst(
                    title: "Aadhaar card",
                    size: 25,
                    fontWeight: FontWeight.w700,
                  ),

                  const SizedBox(height: 26),

                  Row(
                    children: [
                      _imageBox(
                        image: aadhaarFront,
                        label: "Aadhaar\nFront Side",
                        onTap: () => showPicker((file) => aadhaarFront = file),
                      ),
                      const SizedBox(width: 35),
                      _imageBox(
                        image: aadhaarBack,
                        label: "Aadhaar\nBack Side",
                        onTap: () => showPicker((file) => aadhaarBack = file),
                      ),
                    ],
                  ),

                  _inputField(
                    hint: "Aadhaar Number",
                    controller: aadhaarNumberController,
                  ),

                  const SizedBox(height: 20),

                  const TextConst(
                    title: "PAN Card",
                    size: 25,
                    fontWeight: FontWeight.w700,
                  ),

                  const SizedBox(height: 26),

                  Row(
                    children: [
                      _imageBox(
                        image: panFront,
                        label: "PAN Card\nFront Side",
                        onTap: () => showPicker((file) => panFront = file),
                      ),
                      const SizedBox(width: 35),
                      _imageBox(
                        image: panBack,
                        label: "PAN Card\nBack Side",
                        onTap: () => showPicker((file) => panBack = file),
                      ),
                    ],
                  ),

                  _inputField(
                    hint: "PAN Number",
                    controller: panNumberController,
                  ),

                   SizedBox(
                     height: Sizes.screenHeight*0.025,
                   ),

                  /// ------------------ FOOTER ------------------
                  Row(
                    children: [
                      const TextConst(
                        title: "3 of 6",
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
                                width: 55,
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
                            driverRegisterThreeVm.driverRegisterThreeApi(
                                aadhaarFront: aadhaarFront!,
                                aadhaarBack: aadhaarBack!,
                                panCardFront: panFront!,
                                panCardBack: panBack!,
                                aadhaarPanStatus: "1",
                                aadhaarNumber: aadhaarNumberController.text,
                                panCardNumber: panNumberController.text,
                                context: context);
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
        ),
        if (driverRegisterThreeVm.loading)
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
    );
  }
}
