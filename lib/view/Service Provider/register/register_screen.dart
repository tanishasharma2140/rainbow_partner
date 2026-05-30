import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/device_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/categories_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_register_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/zone_cities_view_model.dart';

class RegisterScreen extends StatefulWidget {
  final int profileId;
  final String mobileNumber;
  const RegisterScreen({super.key, required this.mobileNumber,required this.profileId});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  File? profileImage;
  File? experienceCertificate;
  File? aadhaarFront;
  File? aadhaarBack;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoriesViewModel>(context, listen: false).categoriesApi();
      Provider.of<ZoneCitiesViewModel>(context, listen: false).zoneCitiesApi();
    });
  }


  String? selectedCategory;
  String? selectedCategoryId;
  String? gender;
  Position? _currentPosition;
  String currentLat = "";
  String currentLng = "";
  List<String> selectedCategoryNames = [];
  List<String> selectedCategoryIds = [];
  String? selectedCityId;
  bool isFetchingLocation = false;

  // CONTROLLERS
  final TextEditingController firstController = TextEditingController();
  final TextEditingController lastController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  Future<void> getCurrentAddress(TextEditingController addressController) async {
    final loc = AppLocalizations.of(context)!;
    bool serviceEnabled;
    LocationPermission permission;

    setState(() => isFetchingLocation = true);

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setState(() => isFetchingLocation = false);
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => isFetchingLocation = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Utils.showErrorMessage(context, loc.location_permission_denied_permanently);
        setState(() => isFetchingLocation = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = position;
      currentLat = position.latitude.toString();
      currentLng = position.longitude.toString();

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks.first;

      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}, "
          "${place.administrativeArea}, ${place.postalCode}";

      addressController.text = address;
    } catch (e) {
      Utils.showErrorMessage(context, "${loc.error_fetching_location}: $e");
    } finally {
      setState(() => isFetchingLocation = false);
    }
  }





  bool noSkill = false;

  // PICK IMAGE OR PDF — BOTTOM SHEET
  Future<void> pickFileBottomSheet(Function(File) onSelected) async {
    final loc = AppLocalizations.of(context)!;
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
              Text(loc.upload_file,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: Text(loc.camera),
                onTap: () async {
                  final XFile? img =
                  await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
                  if (img != null) onSelected(File(img.path));
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo, color: Colors.green),
                title: Text(loc.gallery),
                onTap: () async {
                  final XFile? img =
                  await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
                  if (img != null) onSelected(File(img.path));
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(loc.upload_pdf),
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
  Future<void> pickImage(bool fromCamera) async {
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

  void showImagePickerOptions() {
    showModalBottomSheet(
      backgroundColor: AppColor.white,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading:  Icon(Icons.photo_library,color: AppColor.royalBlue,),
                title:  TextConst(title: "Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(false);
                },
              ),
              ListTile(
                leading:  Icon(Icons.camera_alt,color: AppColor.royalBlue,),
                title:  TextConst(title: "Camera"),
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
    final loc = AppLocalizations.of(context)!;
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
                      child:  const Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.arrow_back, size: 28),
                      ),
                    ),

                    const SizedBox(height: 20),

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
                            onTap: showImagePickerOptions,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColor.royalBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    TextConst(
                      title: loc.create_your_account,
                      size: 26,
                      fontWeight: FontWeight.w700,
                    ),

                    const SizedBox(height: 10),
                    greyText(loc.fill_your_details_below),

                    const SizedBox(height: 30),

                    // INPUT FIELDS
                    cardField(loc.first_name, firstController, icon: Icons.person_outline),
                    cardField(loc.last_name, lastController, icon: Icons.person_outline),
                    cardField(
                      loc.city,
                      cityController,
                      isCity: true,
                      icon: Icons.location_city_outlined,
                    ),
                    cardField(loc.email_address_optional, emailController, icon: Icons.email_outlined),
                    cardField(
                      loc.full_address,
                      addressController,
                      isAddress: true,
                      icon: Icons.map_outlined,
                    ),

                    // CATEGORY DROPDOWN
                  pickerCard(
                    title: selectedCategoryNames.isNotEmpty
                        ? selectedCategoryNames.join(", ")
                        : loc.select_category,
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
                            activeColor: AppColor.royalBlue,
                            onChanged: (v) {
                              setState(() {
                                noSkill = v!;
                                if (noSkill) experienceCertificate = null;
                              });
                            }),
                        greyText(loc.dont_have_any_skill)
                      ],
                    ),

                    if (!noSkill)
                      uploadBox(
                        title: experienceCertificate == null
                            ? loc.upload_experience_certificate
                            : experienceCertificate!.path.split('/').last,
                        onTap: () {
                          pickFileBottomSheet((file) {
                            setState(() => experienceCertificate = file);
                          });
                        },
                      ),

                    uploadBox(
                      title: aadhaarFront == null
                          ? loc.upload_aadhaar_front
                          : aadhaarFront!.path.split('/').last,
                      onTap: () {
                        pickFileBottomSheet((file) {
                          setState(() => aadhaarFront = file);
                        });
                      },
                    ),

                    uploadBox(
                      title: aadhaarBack == null
                          ? loc.upload_aadhaar_back
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
                      title: loc.submit,
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


        ),
      ),
    );
  }

  void showCityBottomSheet() async {
    final loc = AppLocalizations.of(context)!;
    final zoneVm = Provider.of<ZoneCitiesViewModel>(context, listen: false);

    await zoneVm.zoneCitiesApi(); 

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Consumer<ZoneCitiesViewModel>(
          builder: (context, vm, child) {
            final cities = vm.zoneCitiesModel?.cities ?? [];

            if (vm.loading) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (cities.isEmpty) {
              return SizedBox(
                height: 200,
                child: Center(child: Text(loc.no_cities_found)),
              );
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    loc.select_city,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(),

                  Expanded(
                    child: ListView.builder(
                      itemCount: cities.length,
                      itemBuilder: (context, index) {
                        final city = cities[index];

                        return ListTile(
                          title: Text(city.name ?? ""),
                          onTap: () {
                            setState(() {
                              cityController.text = city.name ?? "";
                              selectedCityId = city.id.toString();
                            });
                            Navigator.pop(context);
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
      },
    );
  }


  // GENDER SELECTOR UI
  Widget genderSelector() {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        greyText(loc.select_gender),
        const SizedBox(height: 8),
        Row(
          children: [
            genderChip(loc.male, "Male"),
            const SizedBox(width: 10),
            genderChip(loc.female, "Female"),
            const SizedBox(width: 10),
            genderChip(loc.other, "Other"),
          ],
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget genderChip(String display, String value) {
    final bool selected = gender == value;
    return GestureDetector(
      onTap: () {
        setState(() => gender = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColor.royalBlue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          display,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  // CARD FIELD
  Widget cardField(
      String hint,
      TextEditingController c, {
        bool isAddress = false,
        bool isCity = false,
        IconData? icon,
      }) {
    return Container(
      height: 58,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.blackLight.withOpacity(0.3)),
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child:TextField(
        controller: c,
        readOnly: isCity, 
        onTap: () {
          if (isCity) showCityBottomSheet();
        },
        style: const TextStyle(fontFamily: AppFonts.kanitReg),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, size: 20, color: AppColor.royalBlue) : null,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: isAddress
              ? (isFetchingLocation 
                 ? const Padding(padding: EdgeInsets.all(15), child: CupertinoActivityIndicator())
                 : IconButton(
                    icon: const Icon(Icons.my_location, color: AppColor.royalBlue),
                    onPressed: () async {
                      await getCurrentAddress(c);
                    },
                   ))
              : (isCity ? const Icon(Icons.keyboard_arrow_down) : null),
        ),
      ),

    );
  }



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
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            const Icon(Icons.upload_rounded, color: AppColor.royalBlue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    color: (title.contains("Upload") || title.contains("Select")) ? Colors.grey : Colors.black),
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
    final loc = AppLocalizations.of(context)!;
    final categoriesVm =
    Provider.of<CategoriesViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        final categories = categoriesVm.categoriesModel?.data ?? [];

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    loc.select_category,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Divider(),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];

                        final String catName = cat.name ?? "";
                        final String catId = cat.id.toString();

                        final bool isChecked =
                        selectedCategoryIds.contains(catId);

                        return CheckboxListTile(
                          value: isChecked,
                          activeColor: AppColor.royalBlue,
                          title: Text(catName),
                          onChanged: (val) {
                            setModalState(() {
                              if (val == true) {
                                if (selectedCategoryIds.length >= 3) {
                                  Utils.showErrorMessage(context, loc.you_can_select_maximum_3_categories);
                                  return;
                                }
                                selectedCategoryIds.add(catId);
                                selectedCategoryNames.add(catName);
                              } else {
                                selectedCategoryIds.remove(catId);
                                selectedCategoryNames.remove(catName);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CustomButton(
                    bgColor: AppColor.royalBlue,
                      title: loc.done, onTap: (){
                    setState(() {});
                    Navigator.pop(context);
                  }),
                ),

                ],
              ),
            );
          },
        );
      },
    );
  }



  // SUBMIT
  Future<void> submitForm() async {
    final loc = AppLocalizations.of(context)!;
    final serviceRegisterVm = Provider.of<ServicemanRegisterViewModel>(context, listen: false);
    final deviceVm = Provider.of<DeviceViewModel>(context, listen: false);
    await deviceVm.fetchDeviceId();
    final deviceId = deviceVm.deviceId ??"unknown";

    if (firstController.text.trim().isEmpty) {
      Utils.showErrorMessage(context, loc.please_enter_first_name);
      return;
    }

    if (lastController.text.trim().isEmpty) {
      Utils.showErrorMessage(context, loc.please_enter_last_name);
      return;
    }

    if (selectedCityId == null) {
      Utils.showErrorMessage(context, loc.please_select_city);
      return;
    }

    if (addressController.text.trim().isEmpty) {
      Utils.showErrorMessage(context, loc.please_enter_address);
      return;
    }

    if (currentLat.isEmpty || currentLng.isEmpty) {
      Utils.showErrorMessage(context, loc.please_fetch_current_location);
      return;
    }

    if (gender == null) {
      Utils.showErrorMessage(context, loc.select_gender_error);
      return;
    }

    if (selectedCategoryIds.isEmpty) {
      Utils.showErrorMessage(context, loc.select_at_least_one_category);
      return;
    }

    if (!noSkill && experienceCertificate == null) {
      Utils.showErrorMessage(context, loc.upload_experience_certificate_error);
      return;
    }

    if (aadhaarFront == null || aadhaarBack == null) {
      Utils.showErrorMessage(context, loc.upload_aadhaar_front_back);
      return;
    }

    if (profileImage == null) {
      Utils.showErrorMessage(context, loc.upload_profile_photo);
      return;
    }

    String skillStatusValue = noSkill ? "1" : "0";

    serviceRegisterVm.servicemanRegisterApi(
      firstName: firstController.text,
      lastName: lastController.text,
      email: emailController.text,
      city: selectedCityId!,
      mobile: widget.mobileNumber,
      address: addressController.text,
      serviceCategory: selectedCategoryIds.map((e) => int.parse(e)).toList(),
      deviceId: deviceId,
      skillStatus: skillStatusValue,
      currentLatitude: currentLat,
      currentLongitude: currentLng,
      aadhaarFront: aadhaarFront!,
      aadhaarBack: aadhaarBack!,
      profilePhoto: profileImage!,
      experienceCertificate: experienceCertificate,
      context: context,
      gender: gender!,
    );
  }


  Widget pickerCard({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColor.blackLight.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: (title.contains("Select") || title.contains("Select")) ? Colors.grey : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

}
