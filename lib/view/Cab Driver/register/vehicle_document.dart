import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/popper_screen.dart';

class VehicleDocument extends StatefulWidget {
  const VehicleDocument({super.key});

  @override
  State<VehicleDocument> createState() => _VehicleDocumentState();
}

class _VehicleDocumentState extends State<VehicleDocument> {
  final picker = ImagePicker();

  /// Store images for each document
  Map<String, File?> documentImages = {
    "Vehicle permit -\npart A": null,
    "Vehicle permit -\npart B": null,
    "Vehicle registration...": null,
    "Back side of\nregistration...": null,
  };

  // ---------------------------
  // PICK IMAGE FUNCTION
  // ---------------------------
  Future<void> pickImage(String key, ImageSource source) async {
    final file = await picker.pickImage(source: source, imageQuality: 70);

    if (file != null) {
      documentImages[key] = File(file.path);
      setState(() {});
    }
  }

  // ---------------------------
  // BOTTOM SHEET OPTIONS
  // ---------------------------
  void showPicker(String key) {
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
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text("Choose From Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(key, ImageSource.gallery);
                },
              ),

              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(key, ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------
  // UPLOAD BOX WIDGET
  // ---------------------------
  Widget uploadBox(String title, {bool optional = false}) {
    File? picked = documentImages[title];

    return GestureDetector(
      onTap: () => showPicker(title),
      child: SizedBox(
        width: 130,
        child: Column(
          children: [
            Stack(
              children: [
                /// Upload container
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    image: picked != null
                        ? DecorationImage(
                            image: FileImage(picked),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),

                  child: picked == null
                      ? const Center(child: Icon(Icons.add, size: 35))
                      : null,
                ),

                /// OPTIONAL TAG
                if (optional)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: TextConst(
                        title: "Optional",
                        size: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            TextConst(
              title: title,
              textAlign: TextAlign.center,
              size: 14,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------
  // BUILD METHOD
  // ---------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: ConstantAppbar(
          onBack: () => Navigator.pop(context),
          onClose: () => Navigator.pop(context),
        ),

        backgroundColor: Colors.white,

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              TextConst(
                title: "Vehicle documents",
                size: 25,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 25),

              /// UPLOAD GRID
              Wrap(
                spacing: 20,
                runSpacing: 25,
                children: [
                  uploadBox("Vehicle permit -\npart A"),
                  uploadBox("Vehicle permit -\npart B"),
                  uploadBox("Vehicle registration..."),
                  uploadBox("Back side of\nregistration...", optional: true),
                ],
              ),

              const Spacer(),

              /// BOTTOM BAR
              Row(
                children: [
                  TextConst(
                    title: "5 of 5",
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
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.royalBlue,
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                      title: "Next",
                      bgColor: AppColor.royalBlue,
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context)=> PopperScreen()));
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
