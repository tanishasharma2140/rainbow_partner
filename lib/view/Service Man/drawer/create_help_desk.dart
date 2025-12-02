import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';

class CreateHelpDesk extends StatefulWidget {
  const CreateHelpDesk({super.key});

  @override
  State<CreateHelpDesk> createState() => _CreateHelpDeskState();
}

class _CreateHelpDeskState extends State<CreateHelpDesk> {

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? selectedImage;

  final ImagePicker picker = ImagePicker();

  void showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Select Image",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // CAMERA
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? img =
                      await picker.pickImage(source: ImageSource.camera);

                      if (img != null) {
                        setState(() {
                          selectedImage = File(img.path);
                        });
                      }
                    },
                    child: Column(
                      children: const [
                        Icon(Icons.camera_alt,
                            size: 40, color: AppColor.royalBlue),
                        SizedBox(height: 8),
                        Text("Camera"),
                      ],
                    ),
                  ),

                  // GALLERY
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      final XFile? img =
                      await picker.pickImage(source: ImageSource.gallery);

                      if (img != null) {
                        setState(() {
                          selectedImage = File(img.path);
                        });
                      }
                    },
                    child: Column(
                      children: const [
                        Icon(Icons.photo,
                            size: 40, color: AppColor.royalBlue),
                        SizedBox(height: 8),
                        Text("Gallery"),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
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
      child: Scaffold(
        backgroundColor: Colors.white,

        // ---------------- APPBAR ----------------
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
                title: "Help Desk",
                color: Colors.white,
                size: 20,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),

        // ---------------- BODY ----------------
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------------- SUBJECT ----------------
              TextConst(
                title: "Subject",
                size: 17,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColor.whiteDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "e.g. Damaged furniture",
                    hintStyle: TextStyle(color: Colors.black54),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ---------------- DESCRIPTION ----------------
              TextConst(
                title: "Description",
                size: 17,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.whiteDark,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText:
                    "e.g. During the service, the furniture was accidentally damaged.",
                    hintStyle: TextStyle(color: Colors.black54),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ---------------- IMAGE PICKER ----------------
              GestureDetector(
                onTap: showImagePicker,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: selectedImage == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image_not_supported,
                          size: 48, color: Colors.grey),
                      SizedBox(height: 10),
                      TextConst(
                        title: "Choose Image",
                        size: 15,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      )
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      selectedImage!,
                      width: double.infinity,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Center(
                child: Text(
                  "Note: You can upload image with 'jpg', 'png', 'jpeg'\nextensions & you can select only one image",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 40),

              CustomButton(
                bgColor: AppColor.royalBlue,
                title: "Submit",
                onTap: () {},
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
