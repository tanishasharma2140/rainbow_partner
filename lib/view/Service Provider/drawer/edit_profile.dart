import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Controllers
  final TextEditingController firstName = TextEditingController(text: "John");
  final TextEditingController lastName = TextEditingController(text: "Doe");
  final TextEditingController username = TextEditingController(text: "john_24");
  final TextEditingController email = TextEditingController(text: "john@gmail.com");
  final TextEditingController designation = TextEditingController(text: "Service Expert");

  File? profileImage;

  final ImagePicker picker = ImagePicker();

  /// PICK IMAGE
  Future pickImage(bool fromCamera) async {
    final XFile? file = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
    );

    if (file != null) {
      setState(() {
        profileImage = File(file.path);
      });
    }
  }

  void showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const TextConst(
              title: "Choose Option",
              size: 17,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColor.royalBlue),
              title: const Text("Take a Photo"),
              onTap: () {
                Navigator.pop(context);
                pickImage(true);
              },
            ),

            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColor.royalBlue),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                pickImage(false);
              },
            ),

            const SizedBox(height: 15),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: AppColor.royalBlue,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            const TextConst(
              title: "Edit Profile",
              color: Colors.white,
              size: 20,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ---------------- PROFILE PICTURE ----------------
            Center(
              child: Stack(
                children: [
                  Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade300,
                      image: DecorationImage(
                        image: profileImage != null
                            ? FileImage(profileImage!)
                            : const AssetImage("assets/profile.png") as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  /// Edit Icon
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: showImagePicker,
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.royalBlue,
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ---------------- TEXT FIELDS ----------------
            fieldTitle("First Name"),
            profileField(firstName),

            fieldTitle("Last Name"),
            profileField(lastName),

            fieldTitle("Username"),
            profileField(username),

            fieldTitle("Email"),
            profileField(email),

            fieldTitle("Designation"),
            profileField(designation),

            const SizedBox(height: 30),

            /// SAVE BUTTON
            CustomButton(
              title: "Save Changes",
              bgColor: AppColor.royalBlue,
              textColor: Colors.white,
              onTap: () {},
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// FIELD TITLE
  Widget fieldTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 8),
      child: TextConst(
        title: text,
        size: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  /// INPUT FIELD
  Widget profileField(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
