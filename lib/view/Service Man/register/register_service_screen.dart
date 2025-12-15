import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart' show Utils;
import 'package:rainbow_partner/view/Service%20Man/home/handyman_dashboard.dart';
import 'package:rainbow_partner/view_model/service_man/city_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/job_request_view_model.dart';

class RegisterServiceScreen extends StatefulWidget {
  final int profileId;
  const RegisterServiceScreen({super.key, required this.profileId});

  @override
  State<RegisterServiceScreen> createState() => _RegisterServiceScreenState();
}

class _RegisterServiceScreenState extends State<RegisterServiceScreen> {
  File? profileImage;
  final ImagePicker _picker = ImagePicker();
  String selectedCity = "Select City";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cityVm = Provider.of<CitiesViewModel>(context, listen: false);
      cityVm.cityApi();
    });
  }



  // controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  // certificates
  File? policeVerificationFile; // single
  List<File> designationFiles = []; // multiple (certificates or affidavits)

  bool doesntKnowSkill = false; // "partner koi kam nh janata" option

  // -----------------------
  // Helpers — pick image or pdf
  // -----------------------
  Future<void> pickProfileImage() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (file != null) {
      setState(() => profileImage = File(file.path));
    }
  }

  Future<void> getCurrentAddress(
    TextEditingController addressController,
  ) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks.first;

    String address =
        "${place.street}, ${place.subLocality}, ${place.locality}, "
        "${place.administrativeArea}, ${place.postalCode}";

    addressController.text = address;
  }

  Future<void> _pickImageOrPdfForPolice() async {
    // show option bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColor.royalBlue,
                ),
                title: const Text("Choose Image from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? file = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 70,
                  );
                  if (file != null)
                    setState(() => policeVerificationFile = File(file.path));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: AppColor.royalBlue,
                ),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? file = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 70,
                  );
                  if (file != null)
                    setState(() => policeVerificationFile = File(file.path));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.picture_as_pdf,
                  color: AppColor.royalBlue,
                ),
                title: const Text("Upload PDF Document"),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    FilePickerResult? res = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (res != null && res.files.single.path != null) {
                      setState(
                        () => policeVerificationFile = File(
                          res.files.single.path!,
                        ),
                      );
                    }
                  } catch (e) {
                    // ignore or show snackbar
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDesignationDoc() async {
    // allow multiple — either image or pdf
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColor.royalBlue,
                ),
                title: const Text("Choose Image from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? file = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 70,
                  );
                  if (file != null)
                    setState(() => designationFiles.add(File(file.path)));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: AppColor.royalBlue,
                ),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? file = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 70,
                  );
                  if (file != null)
                    setState(() => designationFiles.add(File(file.path)));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.picture_as_pdf,
                  color: AppColor.royalBlue,
                ),
                title: const Text("Upload PDF Document (Affidavit allowed)"),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    FilePickerResult? res = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (res != null && res.files.single.path != null) {
                      setState(
                        () =>
                            designationFiles.add(File(res.files.single.path!)),
                      );
                    }
                  } catch (e) {
                    // ignore
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // -----------------------
  // UI helpers
  // -----------------------
  Widget _textField({
    required String hint,
    required TextEditingController controller,
    Widget? trailing,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _designationList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextConst(
          title: "Designation Certificates / Affidavits",
          size: 15,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            // existing uploads
            ...designationFiles.asMap().entries.map((e) {
              final idx = e.key;
              final file = e.value;
              final isPdf = file.path.toLowerCase().endsWith('.pdf');
              return Container(
                width: 110,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: !isPdf
                            ? DecorationImage(
                                image: FileImage(file),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: Colors.grey.shade100,
                      ),
                      child: isPdf
                          ? Center(
                              child: Icon(
                                Icons.picture_as_pdf,
                                size: 36,
                                color: AppColor.royalBlue,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Doc ${idx + 1}",
                            style: const TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              setState(() => designationFiles.removeAt(idx)),
                          child: const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            // add new
            GestureDetector(
              onTap: _pickDesignationDoc,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add, size: 28, color: Colors.grey),
                    SizedBox(height: 6),
                    Text("Add", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const TextConst(
          title:
              "If you don't have a designation certificate, upload an affidavit (PDF) as alternate.",
          size: 12,
          color: Colors.black54,
        ),
      ],
    );
  }

  void showCityBottomSheet() {
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  const Text(
                    "Select City",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: AppColor.whiteDarkII,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // SEARCH BAR
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xffF1F2F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: "Search city...",
                          border: InputBorder.none,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // CITY LIST
              Expanded(
                child: Consumer<CitiesViewModel>(
                  builder: (context, vm, _) {
                    final allCities = vm.cityModel?.data ?? [];

                    final filtered = allCities.where((city) {
                      final query = searchController.text.trim().toLowerCase();
                      return city.name!.toLowerCase().contains(query);
                    }).toList();

                    return ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, index) {
                        final city = filtered[index];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCity = city.name!;
                              cityController.text = selectedCity;
                            });
                            Navigator.pop(context);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                city.name!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "Uttar Pradesh, India",
                                style:
                                TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final jobRequestVm = Provider.of<JobRequestViewModel>(context);

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: topPadding),
                  // back
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(CupertinoIcons.back, size: 28),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 56,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : null,
                        child: profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 64,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () => pickProfileImage(),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColor.royalBlue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const TextConst(
                    title: "Hello User !",
                    size: 25,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 6),
                  TextConst(
                    title: "Create Your Account for Better\nExperience",
                    textAlign: TextAlign.center,
                    size: 15,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 24),

                  // fields
                  _textField(hint: "First Name", controller: firstNameController),
                  _textField(hint: "Last Name", controller: lastNameController),
                  GestureDetector(
                    onTap: () {
                      showCityBottomSheet();
                    },
                    child: Container(
                      height: 55,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedCity,
                            style: TextStyle(
                              color: selectedCity == "Select City" ? Colors.grey : Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, size: 26, color: Colors.grey)
                        ],
                      ),
                    ),
                  ),
                  _textField(
                    hint: "Email Address",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _textField(
                    hint: "Designation (e.g. Plumber)",
                    controller: designationController,
                  ),

                  // mobile number (digits only)
                  _textField(
                    hint: "Mobile Number",
                    controller: mobileController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 10,
                  ),

                  const SizedBox(height: 8),

                  // police verification upload
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextConst(
                        title: "Police Verification Certificate",
                        size: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      GestureDetector(
                        onTap: _pickImageOrPdfForPolice,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.royalBlue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            "Upload",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (policeVerificationFile != null)
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            policeVerificationFile!.path.split('/').last,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              setState(() => policeVerificationFile = null),
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ],
                    ),

                  // const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text(
                        "Don't know any skill",
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      Checkbox(
                        value: doesntKnowSkill,
                        onChanged: (v) => setState(() {
                          doesntKnowSkill = v ?? false;
                          if (doesntKnowSkill) designationFiles.clear();
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // designation upload area (disabled when doesntKnowSkill true)
                  Opacity(
                    opacity: doesntKnowSkill ? 0.5 : 1,
                    child: IgnorePointer(
                      ignoring: doesntKnowSkill,
                      child: _designationList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // submit
                  CustomButton(
                      title: "Submit",
                      bgColor: AppColor.royalBlue,
                      textColor: Colors.white,
                      onTap: () {
                        if (firstNameController.text.trim().isEmpty) {
                          Utils.showErrorMessage(context, "Please Enter First Name");
                          return;
                        }
                        if (mobileController.text.trim().length != 10) {
                          Utils.showErrorMessage(context, "Please Enter 10 digit number");
                          return;
                        }
                        String skillType = doesntKnowSkill ? "1" : "0";
                        File? singleDesignationFile;
                        if (skillType == "0") {
                          if (designationFiles.isNotEmpty) {
                            singleDesignationFile = designationFiles.first;
                          } else {
                            Utils.showErrorMessage(context, "Please upload at least 1 designation certificate");
                            return;
                          }
                        }
                        jobRequestVm.jobRequestApi(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          mobile: mobileController.text,
                          designation: designationController.text,
                          skillType: skillType,
                          city: selectedCity,
                          policeVerificationFile: policeVerificationFile!,
                          profilePhoto: profileImage!,
                          designationFiles: designationFiles,  // <-- Correct
                          context: context,
                        );

                      }

                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
            if (jobRequestVm.loading)
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
}
