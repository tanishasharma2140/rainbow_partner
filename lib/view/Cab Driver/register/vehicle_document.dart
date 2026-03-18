import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_register_six_view_model.dart';

class VehicleDocument extends StatefulWidget {
  const VehicleDocument({super.key});

  @override
  State<VehicleDocument> createState() => _VehicleDocumentState();
}

class _VehicleDocumentState extends State<VehicleDocument> {
  final picker = ImagePicker();

  int? vehicleCategory;

  // ✅ Flags
  bool get showPermits => vehicleCategory == 3 || vehicleCategory == 4;
  bool get showRegistration =>
      vehicleCategory == 2 || vehicleCategory == 3 || vehicleCategory == 4;

  // ✅ Backing file fields
  File? _permitAFile;
  File? _permitBFile;
  File? _registrationFrontFile;
  File? _registrationBackFile;

  // ✅ Dynamic document map (getter)
  Map<String, File?> get documentFiles {
    final Map<String, File?> map = {};

    if (showPermits) {
      map["Vehicle permit -\npart A"] = _permitAFile;
      map["Vehicle permit -\npart B"] = _permitBFile;
    }

    if (showRegistration) {
      map["Vehicle registration certificate"] = _registrationFrontFile;
      map["Back side of\nregistration certificate"] = _registrationBackFile;
    }

    return map;
  }

  // ✅ Getters for API
  File? get vehiclePermitA => _permitAFile;
  File? get vehiclePermitB => _permitBFile;
  File? get vehicleRegistrationFront => _registrationFrontFile;
  File? get vehicleRegistrationBack => _registrationBackFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileVm =
      Provider.of<DriverProfileViewModel>(context, listen: false);
      final category = profileVm.driverProfileModel?.data?.vehicleCategory;
      setState(() {
        vehicleCategory = category;
      });
    });
  }

  // ✅ Central setter
  void _setFile(String key, File? file) {
    setState(() {
      if (key.contains("part A")) {
        _permitAFile = file;
      } else if (key.contains("part B")) {
        _permitBFile = file;
      } else if (key.contains("Back side")) {
        _registrationBackFile = file;
      } else if (key.contains("registration")) {
        _registrationFrontFile = file;
      }
    });
  }

  Future<void> pickImage(String key, ImageSource source) async {
    final picked = await picker.pickImage(source: source, imageQuality: 70);
    if (picked != null) {
      _setFile(key, File(picked.path));
    }
  }

  Future<void> pickDocument(String key) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        _setFile(key, File(result.files.single.path!));
      }
    } catch (e) {
      print("Document pick error => $e");
    }
  }

  void openFile(File file) {
    OpenFilex.open(file.path);
  }

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
                leading: const Icon(Icons.picture_as_pdf,
                    color: AppColor.royalBlue),
                title: const Text("Upload PDF Document"),
                onTap: () {
                  Navigator.pop(context);
                  pickDocument(key);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library,
                    color: AppColor.royalBlue),
                title: const Text("Choose From Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(key, ImageSource.gallery);
                },
              ),
              ListTile(
                leading:
                const Icon(Icons.camera_alt, color: AppColor.royalBlue),
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

  Widget uploadBox(String title, {bool optional = false}) {
    File? file = documentFiles[title];
    bool isPDF = file != null && file.path.toLowerCase().endsWith(".pdf");

    return GestureDetector(
      onTap: () {
        if (file == null) {
          showPicker(title);
        } else {
          openFile(file);
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
                        ? DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: file == null
                      ? const Center(child: Icon(Icons.add, size: 35))
                      : isPDF
                      ? const Center(
                    child: Icon(Icons.picture_as_pdf,
                        size: 50, color: Colors.red),
                  )
                      : null,
                ),

                // ✅ Optional tag
                if (optional)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: const Text("Optional",
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),

                // ✅ Remove button
                if (file != null)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: GestureDetector(
                      onTap: () => _setFile(title, null),
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close,
                            color: Colors.white, size: 18),
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

  @override
  Widget build(BuildContext context) {
    final driverRegisterSixVm =
    Provider.of<DriverRegisterSixViewModel>(context);

    return Stack(
      children: [
        SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: ConstantAppbar(
              onBack: () => Navigator.pop(context),
              onClose: () => SystemNavigator.pop(),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const TextConst(
                    title: "Vehicle documents",
                    size: 25,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 25),

                  Wrap(
                    spacing: 20,
                    runSpacing: 25,
                    children: [
                      // ✅ Permit A & B — sirf category 3, 4
                      if (showPermits) ...[
                        uploadBox("Vehicle permit -\npart A"),
                        uploadBox("Vehicle permit -\npart B"),
                      ],

                      // ✅ Registration — category 2, 3, 4
                      if (showRegistration) ...[
                        uploadBox("Vehicle registration certificate"),
                        uploadBox(
                          "Back side of\nregistration certificate",
                          optional: true,
                        ),
                      ],
                    ],
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      const TextConst(
                        title: "6 of 6",
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
                            // ✅ Validation
                            if ((showPermits &&
                                (vehiclePermitA == null ||
                                    vehiclePermitB == null)) ||
                                (showRegistration &&
                                    vehicleRegistrationFront == null)) {
                              Utils.showErrorMessage(
                                context,
                                "Please upload all required vehicle documents",
                              );
                              return;
                            }

                            driverRegisterSixVm.driverRegisterSixApi(
                              vehiclePermitA: showPermits ? vehiclePermitA : null,
                              vehiclePermitB: showPermits ? vehiclePermitB : null,
                              vehicleRegistrationFront: showRegistration ? vehicleRegistrationFront : null,
                              vehicleRegistrationBack: vehicleRegistrationBack,
                              vehicleInfoStatus: "1",
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
        if (driverRegisterSixVm.loading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Container(
                height: Sizes.screenHeight * 0.13,
                width: Sizes.screenWidth * 0.28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
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