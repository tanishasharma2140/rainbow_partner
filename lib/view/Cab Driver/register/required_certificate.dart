import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';

import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/vehicle_information.dart';

class RequiredCertificates extends StatefulWidget {
  const RequiredCertificates({super.key});

  @override
  State<RequiredCertificates> createState() => _RequiredCertificatesState();
}

class _RequiredCertificatesState extends State<RequiredCertificates> {
  final picker = ImagePicker();

  /// Store certificate images / PDF files
  Map<String, File?> certificateFiles = {
    "Fitness\nCertificate": null,
    "Pollution (PUC)\nCertificate": null,
    "Insurance\nCertificate": null,
    "Police Verification\nCertificate": null,
  };

  Future<void> pickImage(String key, ImageSource source) async {
    final XFile? file = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (file != null) {
      certificateFiles[key] = File(file.path);
      setState(() {});
    }
  }

  Future<void> pickDocument(String key) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        certificateFiles[key] = File(result.files.single.path!);
        setState(() {});
      }
    } catch (e) {
      print("File Picker Error: $e");
    }
  }

  // ---------------------------
  // OPEN PDF / FILE VIEWER
  // ---------------------------
  void openFile(File file) {
    OpenFilex.open(file.path);
  }

  // ---------------------------
  // BOTTOM SHEET
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
                leading: const Icon(Icons.picture_as_pdf, color: AppColor.royalBlue),
                title: const Text("Upload PDF Document"),
                onTap: () {
                  Navigator.pop(context);
                  pickDocument(key);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColor.royalBlue),
                title: const Text("Choose Image From Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(key, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColor.royalBlue),
                title: const Text("Take Photo"),
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

  Widget uploadBox(String title) {
    File? file = certificateFiles[title];
    bool isPDF = file != null && file.path.toLowerCase().endsWith(".pdf");

    return GestureDetector(
      onTap: () {
        if (file == null) {
          showPicker(title);
        } else {
          openFile(file); // Open the uploaded file
        }
      },
      child: SizedBox(
        width: 130,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    image: file != null && !isPDF
                        ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
                        : null,
                  ),

                  child: file == null
                      ? const Center(child: Icon(Icons.add, size: 35))
                      : isPDF
                      ? const Center(
                    child: Icon(
                      Icons.picture_as_pdf,
                      size: 50,
                      color: Colors.red,
                    ),
                  )
                      : null,
                ),

                /// REMOVE (X) BUTTON
                if (file != null)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: GestureDetector(
                      onTap: () {
                        certificateFiles[title] = null;
                        setState(() {});
                      },
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 18),
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
  // BUILD
  // ---------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: ConstantAppbar(
          onBack: () => Navigator.pop(context),
          onClose: () => Navigator.pop(context),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              const TextConst(
                title: "Upload Required Certificates",
                size: 25,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 25),

              Wrap(
                spacing: 20,
                runSpacing: 25,
                children: certificateFiles.keys
                    .map((e) => uploadBox(e))
                    .toList(),
              ),

              const Spacer(),

              Row(
                children: [
                  const TextConst(
                    title: "4 of 6",
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
                            width: 80,
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
                      title: "Next",
                      bgColor: AppColor.royalBlue,
                      textColor: Colors.white,
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const VehicleInformation(),
                          ),
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
    );
  }
}
