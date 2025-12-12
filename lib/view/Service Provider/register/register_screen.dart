import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_register_view_model.dart';

class RegisterScreen extends StatefulWidget {
  final String mobileNumber;
  const RegisterScreen({super.key, required this.mobileNumber});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? profileImage;
  File? experienceCertificate;
  File? aadhaarFront;
  File? aadhaarBack;

  final ImagePicker picker = ImagePicker();

  // CATEGORY LIST
  final List<String> categoryList = [
    "AC Maintenance",
    "Cooking & Gardening",
    "Salon",
    "Plumber"
  ];

  String? selectedCategory;
  String? gender;

  // CONTROLLERS
  final TextEditingController firstController = TextEditingController();
  final TextEditingController lastController = TextEditingController();
  final TextEditingController userController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  bool noSkill = false;

  // PICK IMAGE OR PDF — BOTTOM SHEET
  Future<void> pickFileBottomSheet(Function(File) onSelected) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:
      const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (context) {
        return SizedBox(
          height: 250,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                height: 4,
                width: 40,
                decoration:
                BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 14),
              const Text("Upload File",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text("Camera"),
                onTap: () async {
                  final XFile? img =
                  await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
                  if (img != null) onSelected(File(img.path));
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo, color: Colors.green),
                title: const Text("Gallery"),
                onTap: () async {
                  final XFile? img =
                  await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
                  if (img != null) onSelected(File(img.path));
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: const Text("Upload PDF"),
                onTap: () async {
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  if (result != null && result.files.single.path != null) {
                    onSelected(File(result.files.single.path!));
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // PICK PROFILE IMAGE ONLY (IMAGE)
  Future<void> pickProfileImage() async {
    final XFile? img =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (img != null) setState(() => profileImage = File(img.path));
  }

  @override
  Widget build(BuildContext context) {
    final serviceRegisterVm = Provider.of<ServicemanRegisterViewModel>(context);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(

          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child:  Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.arrow_back, size: 28),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // PROFILE IMAGE
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 58,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage:
                          profileImage != null ? FileImage(profileImage!) : null,
                          child: profileImage == null
                              ? const Icon(Icons.person, size: 70, color: Colors.white)
                              : null,
                        ),
                        Positioned(
                          bottom: 3,
                          right: 4,
                          child: GestureDetector(
                            onTap: pickProfileImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColor.royalBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const TextConst(
                      title: "Create Your Account",
                      size: 26,
                      fontWeight: FontWeight.w700,
                    ),

                    const SizedBox(height: 10),
                    greyText("Fill your details below"),

                    const SizedBox(height: 30),

                    // INPUT FIELDS
                    cardField("First Name", firstController),
                    cardField("Last Name", lastController),
                    cardField("User Name", userController),
                    cardField("Email Address", emailController),
                    cardField("Full Address", addressController),

                    // CATEGORY DROPDOWN
                    pickerCard(
                      title: selectedCategory ?? "Select Category",
                      onTap: showCategoryBottomSheet,
                    ),

                    // GENDER SELECTION
                    genderSelector(),

                    const SizedBox(height: 15),

                    // Experience
                    Row(
                      children: [
                        Checkbox(
                            value: noSkill,
                            onChanged: (v) {
                              setState(() {
                                noSkill = v!;
                                if (noSkill) experienceCertificate = null;
                              });
                            }),
                        greyText("Don't have any skill?")
                      ],
                    ),

                    if (!noSkill)
                      uploadBox(
                        title: experienceCertificate == null
                            ? "Upload Experience Certificate (Image/PDF)"
                            : experienceCertificate!.path.split('/').last,
                        onTap: () {
                          pickFileBottomSheet((file) {
                            setState(() => experienceCertificate = file);
                          });
                        },
                      ),

                    uploadBox(
                      title: aadhaarFront == null
                          ? "Upload Aadhaar Front"
                          : aadhaarFront!.path.split('/').last,
                      onTap: () {
                        pickFileBottomSheet((file) {
                          setState(() => aadhaarFront = file);
                        });
                      },
                    ),

                    uploadBox(
                      title: aadhaarBack == null
                          ? "Upload Aadhaar Back"
                          : aadhaarBack!.path.split('/').last,
                      onTap: () {
                        pickFileBottomSheet((file) {
                          setState(() => aadhaarBack = file);
                        });
                      },
                    ),

                    const SizedBox(height: 35),

                    CustomButton(
                      bgColor: AppColor.royalBlue,
                      textColor: Colors.white,
                      title: "Submit",
                      onTap: submitForm,
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            if (serviceRegisterVm.loading)
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

  // GENDER SELECTOR UI
  Widget genderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        greyText("Select Gender"),
        const SizedBox(height: 8),
        Row(
          children: [
            genderChip("Male"),
            const SizedBox(width: 10),
            genderChip("Female"),
            const SizedBox(width: 10),
            genderChip("Other"),
          ],
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget genderChip(String g) {
    final bool selected = gender == g;
    return GestureDetector(
      onTap: () {
        setState(() => gender = g);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColor.royalBlue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          g,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // CARD FIELD
  Widget cardField(String hint, TextEditingController c) {
    return Container(
      height: 58,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  // MOBILE
  // Widget mobileField() {
  //   return Container(
  //     height: 58,
  //     margin: const EdgeInsets.only(bottom: 18),
  //     padding: const EdgeInsets.symmetric(horizontal: 18),
  //     decoration: BoxDecoration(
  //       color: Colors.grey.shade100,
  //       borderRadius: BorderRadius.circular(14),
  //     ),
  //     child: TextField(
  //       controller: mobileController,
  //       maxLength: 10,
  //       keyboardType: TextInputType.number,
  //       decoration: const InputDecoration(
  //         border: InputBorder.none,
  //         counterText: "",
  //         hintText: ,
  //       ),
  //     ),
  //   );
  // }

  // BOX
  Widget uploadBox({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            const Icon(Icons.upload_rounded, color: Colors.blueGrey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    color: title.contains("Upload") ? Colors.grey : Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget greyText(String text) {
    return Text(text, style: TextStyle(color: Colors.grey.shade600, fontSize: 14));
  }

  // CATEGORY BOTTOM SHEET
  void showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (context) {
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(height: 4, width: 40, color: Colors.grey),

              const SizedBox(height: 12),
              const Text("Select Category",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const Divider(),

              Expanded(
                child: ListView(
                  children: categoryList
                      .map((cat) => ListTile(
                    title: Text(cat),
                    onTap: () {
                      setState(() => selectedCategory = cat);
                      Navigator.pop(context);
                    },
                  ))
                      .toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // SUBMIT
  void submitForm() {
    final serviceRegisterVm = Provider.of<ServicemanRegisterViewModel>(context, listen: false);

    // if (mobileController.text.length != 10) {
    //   Utils.showErrorMessage(context, "Enter valid mobile number");
    //   return;
    // }

    if (gender == null) {
      Utils.showErrorMessage(context, "Select gender");
      return;
    }

    if (selectedCategory == null) {
      Utils.showErrorMessage(context, "Select a category");
      return;
    }

    // ✔ Experience certificate only required when noSkill = false
    if (!noSkill && experienceCertificate == null) {
      Utils.showErrorMessage(context, "Upload Experience Certificate");
      return;
    }

    if (aadhaarFront == null || aadhaarBack == null) {
      Utils.showErrorMessage(context, "Upload Aadhaar front & back");
      return;
    }

    if (profileImage == null) {
      Utils.showErrorMessage(context, "Upload Profile Photo");
      return;
    }

    // ⭐ correct skill status
    String skillStatusValue = noSkill ? "1" : "0";

    serviceRegisterVm.servicemanRegisterApi(
      firstName: firstController.text,
      lastName: lastController.text,
      email: emailController.text,
      mobile: widget.mobileNumber,
      address: addressController.text,
      serviceCategory: "1",
      deviceId: "device_123",
      fcmToken: "fcm_123",
      skillStatus: skillStatusValue,
      currentLatitude: "26.90",
      currentLongitude: "80.94",
      aadhaarFront: aadhaarFront!,
      aadhaarBack: aadhaarBack!,
      profilePhoto: profileImage!,
      experienceCertificate: experienceCertificate, // ⭐ FIXED (no !)
      context: context,
      gender: gender!,
    );
  }


  //
  // void error(String msg) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  // }
  Widget pickerCard({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              offset: const Offset(0, 1),
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: title.contains("Select") ? Colors.grey : Colors.black,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

}
