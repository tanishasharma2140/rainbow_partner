import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Service%20Provider/home/provider_dashboard.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? profileImage;
  final ImagePicker picker = ImagePicker();

  // PICK IMAGE FUNC
  Future<void> pickProfileImage() async {
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (file != null) {
      setState(() {
        profileImage = File(file.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(height: 10),

                  // BACK BUTTON
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, size: 28),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // USER IMAGE + CAMERA ICON
                  Stack(
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage:
                        profileImage != null ? FileImage(profileImage!) : null,
                        child: profileImage == null
                            ? const Icon(Icons.person,
                            size: 70, color: Colors.white)
                            : null,
                      ),

                      // CAMERA ICON BADGE
                      Positioned(
                        bottom: 3,
                        right: 4,
                        child: GestureDetector(
                          onTap: pickProfileImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // TITLE
                   TextConst(title:
                    "Hello User !",
                     size: 25,
                     fontWeight: FontWeight.w700,
                  ),

                  const SizedBox(height: 6),
                  TextConst(
                    title:
                    "Create Your Account for Better\nExperience",
                    textAlign: TextAlign.center,
                    size: 15,
                    color: Colors.grey.shade600,
                  ),

                  const SizedBox(height: 35),

                  // INPUT FIELDS
                  inputField("First Name", Icons.person_outline),
                  inputField("Last Name", Icons.person_outline),
                  inputField("User Name", Icons.person_outline),
                  inputField("Email Address", Icons.email_outlined),
                  inputField("Designation", Icons.person_outline),

                  const SizedBox(height: 40),

                  // SUBMIT BUTTON
                  CustomButton(
                    bgColor: AppColor.royalBlue,
                    textColor: AppColor.white,
                    title: "Submit",
                    onTap: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> ProviderDashboard()));
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------
  // INPUT FIELD WIDGET
  // ---------------------------
  Widget inputField(String hint, IconData icon) {
    return Container(
      height: 55,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          Icon(icon, color: Colors.grey),
        ],
      ),
    );
  }
}
