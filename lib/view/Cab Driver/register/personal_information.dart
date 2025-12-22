import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_register_one_view_model.dart';

class PersonalInformation extends StatefulWidget {
  final String vehicleId;
  final String vehicleName;
  final String mobileNumber;
  final int profileId;
  const PersonalInformation({
    super.key,
    required this.vehicleId,
    required this.vehicleName,
    required this.mobileNumber,
    required this.profileId,
  });

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  File? selectedImage; // ⭐ Picked image file

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(bool fromCamera) async {
    final XFile? file = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
    );

    if (file != null) {
      setState(() {
        selectedImage = File(file.path);
      });
    }
  }

  void showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo, color: AppColor.royalBlue),
                title: Text("Select from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(false);
                },
              ),

              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColor.royalBlue),
                title: Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(true);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final driverRegOneVm = Provider.of<DriverRegisterOneViewModel>(context);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,

        appBar: ConstantAppbar(
          onBack: () => Navigator.pop(context),
          onClose: () => Navigator.pop(context),
        ),

        body: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: topPadding),

                            TextConst(
                              title: "Personal information",
                              size: 25,
                              fontWeight: FontWeight.w700,
                            ),

                            SizedBox(height: 25),

                            /// IMAGE PICKER (your code)
                            /// IMAGE PICKER (with remove option)
                            GestureDetector(
                              onTap: selectedImage == null
                                  ? showImagePickerOptions
                                  : null,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 110,
                                        width: 110,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(20),
                                          image: selectedImage != null
                                              ? DecorationImage(
                                                  image: FileImage(selectedImage!),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: selectedImage == null
                                            ? const Center(
                                                child: Icon(Icons.add, size: 35),
                                              )
                                            : null,
                                      ),

                                      /// ❌ REMOVE ICON (only show when image selected)
                                      if (selectedImage != null)
                                        Positioned(
                                          right: 6,
                                          top: 6,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedImage = null;
                                              });
                                            },
                                            child: Container(
                                              height: 26,
                                              width: 26,
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
                                  const TextConst(
                                    title: "Personal picture",
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 35),

                            _textFieldContainer(
                              child: TextField(
                                controller: nameController,
                                maxLength: 20,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(
                                      r'[a-zA-Z ]',
                                    ), // ← only letters and space
                                  ),
                                ],
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  counterText: "",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                            SizedBox(height: 18),

                            _textFieldContainer(
                              child: TextField(
                                controller: surnameController,
                                maxLength: 20,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(
                                      r'[a-zA-Z ]',
                                    ), // ← only letters and space
                                  ),
                                ],
                                decoration: InputDecoration(
                                  hintText: "Surname",
                                  counterText: "",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 18),

                            _textFieldContainer(
                              child: TextField(
                                controller: mobileController,
                                keyboardType: TextInputType.number,
                                readOnly: true,
                                maxLength: 10,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // ← only numbers allowed
                                ],
                                decoration: InputDecoration(
                                  hintText: widget.mobileNumber,
                                  counterText: "",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),

                            SizedBox(height: 18),

                            _textFieldContainer(
                              child: TextField(
                                controller: dobController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: "Date of birth",
                                  border: InputBorder.none,
                                ),
                                onTap: () => _selectDate(context),
                              ),
                            ),

                            Spacer(), // 🔥 NOW Spacer Works PERFECT!
                            /// ---------------- FOOTER -----------------
                            Row(
                              children: [
                                TextConst(
                                  title: "1 of 6",
                                  size: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(width: 12),

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
                                          width: 25,
                                          decoration: BoxDecoration(
                                            color: AppColor.royalBlue,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(width: 16),

                                SizedBox(
                                  height: 50,
                                  width: 110,
                                  child: CustomButton(
                                    bgColor: AppColor.royalBlue,
                                    textColor: AppColor.white,
                                    title: "Next",
                                    onTap: () {
                                      if (selectedImage == null) {
                                       Utils.showErrorMessage(context, "Please select personal picture");
                                        return;
                                      }

                                      if (nameController.text.trim().isEmpty) {
                                        Utils.showErrorMessage(context, "Please enter name");
                                        return;
                                      }

                                      if (surnameController.text.trim().isEmpty) {
                                        Utils.showErrorMessage(context, "Please enter surname");
                                        return;
                                      }

                                      if (dobController.text.trim().isEmpty) {
                                        Utils.showErrorMessage(context, "Please select date of birth");
                                        return;
                                      }
                                      driverRegOneVm.driverRegisterOneApi(
                                          profilePhoto: selectedImage!,
                                          personalInfoStatus: "1",
                                          mobile: widget.mobileNumber,
                                          firstName: nameController.text,
                                          platformType: widget.profileId.toString(),
                                          vehicleType: widget.vehicleId,
                                          vehicleName: widget.vehicleName,
                                          lastName: surnameController.text,
                                          dob: dobController.text,
                                          deviceId: "",
                                          fcm: "",
                                          context: context
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (driverRegOneVm.loading)
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

  Widget _textFieldContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime(2000),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColor.royalBlue),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final String formattedDate =
          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

      dobController.text = formattedDate;
      setState(() {});
    }
  }

}
