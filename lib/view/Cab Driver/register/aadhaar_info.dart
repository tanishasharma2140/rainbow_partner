import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/utils/utils.dart';
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

  bool _validateFields() {
    final loc = AppLocalizations.of(context)!;
    if (aadhaarFront == null) {
      _showError(loc.please_upload_aadhaar_front_side);
      return false;
    }

    if (aadhaarBack == null) {
      _showError(loc.please_upload_aadhaar_back_side);
      return false;
    }

    if (aadhaarNumberController.text.trim().isEmpty) {
      _showError(loc.please_enter_aadhaar_number);
      return false;
    }

    if (panFront == null) {
      _showError(loc.please_upload_pan_card_front_side);
      return false;
    }
    if (panNumberController.text.trim().isEmpty) {
      _showError(loc.please_enter_pan_number);
      return false;
    }

    return true;
  }

  void _showError(String message) {
    Utils.showErrorMessage(context, message);
  }

  // BOTTOM SHEET
  void showPicker(Function(File) onSelected) {
    final loc = AppLocalizations.of(context)!;
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
                title: Text(loc.select_from_gallery),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(onSelected, false);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColor.royalBlue),
                title: Text(loc.take_photo),
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
    final loc = AppLocalizations.of(context)!;
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
                      ? DecorationImage(
                          image: FileImage(image),
                          fit: BoxFit.cover,
                        )
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
                      if (label == loc.aadhaar_front_side) {
                        aadhaarFront = null;
                      } else if (label == loc.aadhaar_back_side) {
                        aadhaarBack = null;
                      } else if (label == loc.pan_card_front_side) {
                        panFront = null;

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
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
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
    required int maxLength,
  }) {
    final loc = AppLocalizations.of(context)!;
    final bool isAadhaar = hint == loc.aadhaar_number;
    final bool isPan = hint == loc.pan_number;

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

        /// ⌨️ KEYBOARD TYPE
        keyboardType: isAadhaar ? TextInputType.number : TextInputType.text,

        /// 🔤 CAPITALIZATION FOR PAN
        textCapitalization: isPan
            ? TextCapitalization.characters
            : TextCapitalization.none,

        /// 🚫 INPUT FORMATTERS
        inputFormatters: isAadhaar
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(12),
              ]
            : isPan
            ? [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                LengthLimitingTextInputFormatter(10),
                UpperCaseTextFormatter(), // 👈 CUSTOM FORMATTER
              ]
            : null,

        /// 🧮 MAX LENGTH
        maxLength: isAadhaar ? 12 : maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,

        decoration: InputDecoration(
          hintText: hint,
          counterText: "",
          hintStyle: const TextStyle(fontFamily: AppFonts.kanitReg),
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final driverRegisterThreeVm = Provider.of<DriverRegisterThreeViewModel>(
      context,
    );
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: true,
            child: Scaffold(
              backgroundColor: AppColor.white,

              appBar: ConstantAppbar(
                onBack: () => Navigator.pop(context),
                onClose: () =>  SystemNavigator.pop(),
              ),

              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: ListView(
                  children: [
                    SizedBox(height: topPadding),

                    /// ------------------ AADHAAR SECTION ------------------
                    TextConst(
                      title: loc.aadhaar_card,
                      size: 25,
                      fontWeight: FontWeight.w700,
                    ),

                    const SizedBox(height: 26),

                    Row(
                      children: [
                        _imageBox(
                          image: aadhaarFront,
                          label: loc.aadhaar_front_side,
                          onTap: () => showPicker((file) => aadhaarFront = file),
                        ),
                        const SizedBox(width: 35),
                        _imageBox(
                          image: aadhaarBack,
                          label: loc.aadhaar_back_side,
                          onTap: () => showPicker((file) => aadhaarBack = file),
                        ),
                      ],
                    ),

                    _inputField(
                      hint: loc.aadhaar_number,
                      controller: aadhaarNumberController,
                      maxLength: 12,
                    ),

                    const SizedBox(height: 20),

                    TextConst(
                      title: loc.pan_card,
                      size: 25,
                      fontWeight: FontWeight.w700,
                    ),

                    const SizedBox(height: 26),

                    Row(
                      children: [
                        _imageBox(
                          image: panFront,
                          label: loc.pan_card_front_side,
                          onTap: () => showPicker((file) => panFront = file),
                        ),
                      ],
                    ),

                    _inputField(
                      hint: loc.pan_number,
                      controller: panNumberController,
                      maxLength: 10,
                    ),

                    SizedBox(height: Sizes.screenHeight * 0.025),

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
                            title: loc.next,
                            onTap: () {
                              if (!_validateFields()) return;

                              driverRegisterThreeVm.driverRegisterThreeApi(
                                aadhaarFront: aadhaarFront!,
                                aadhaarBack: aadhaarBack!,
                                panCardFront: panFront!,
                                aadhaarPanStatus: "1",
                                aadhaarNumber: aadhaarNumberController.text
                                    .trim(),
                                panCardNumber: panNumberController.text.trim(),
                                context: context,
                              );
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
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
