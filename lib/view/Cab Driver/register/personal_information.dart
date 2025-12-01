import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/driving_license.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
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
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,

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
                title: "Personal information",
                size: 25,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 25),

              /// ⭐ PROFILE IMAGE PICKER
              GestureDetector(
                onTap: showImagePickerOptions,
                child: Column(
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
                        child: Icon(Icons.add, size: 35, color: Colors.black),
                      )
                          : null,
                    ),
                    const SizedBox(height: 8),
                    TextConst(
                      title: "Personal picture",
                      color: Colors.black87,
                      size: 14,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              _textFieldContainer(
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 17,fontFamily: AppFonts.kanitReg),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              _textFieldContainer(
                child: TextField(
                  controller: surnameController,
                  decoration: const InputDecoration(
                    hintText: "Surname",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 17,fontFamily: AppFonts.kanitReg),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              _textFieldContainer(
                child: TextField(
                  controller: dobController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: "Date of birth",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 17,fontFamily: AppFonts.kanitReg),
                    border: InputBorder.none,
                  ),
                  onTap: () => _selectDate(context),
                ),
              ),

              const Spacer(),

              Row(
                children: [
                  TextConst(
                    title: "1 of 5",
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
                            width: 35,
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
                        Navigator.push(context, CupertinoPageRoute(builder: (context)=>DrivingLicense()));
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
      dobController.text =
      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() {});
    }
  }
}
