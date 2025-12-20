import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_register_five_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/vehicle_colors_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/vehicle_model_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/vehicle_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/vehicle_brand_view_model.dart';

class VehicleInformation extends StatefulWidget {
  const VehicleInformation({super.key});

  @override
  State<VehicleInformation> createState() => _VehicleInformationState();
}

class _VehicleInformationState extends State<VehicleInformation> {
  File? vehiclePhoto;

  String? selectedBrand;
  int? selectedBrandId;
  String? selectedModel;
  int? selectedModelId;
  String? selectedColor;

  TextEditingController plateController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectedVehicleId = context
          .read<VehicleViewModel>()
          .selectedVehicleId;

      if (selectedVehicleId != null) {
        context.read<VehicleBrandViewModel>().vehicleBrandApi(
          selectedVehicleId,
          context,
        );
      } else {
        if (kDebugMode) {
          print("❌ Vehicle ID not selected yet");
        }
      }
      final vehicleColorVm = Provider.of<VehicleColorsViewModel>(
        context,
        listen: false,
      );
      vehicleColorVm.vehicleColorsApi(context);
    });
  }

  Future<void> pickImage(bool fromCamera) async {
    final file = await picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
    );

    if (file != null) {
      vehiclePhoto = File(file.path);
      setState(() {});
    }
  }

  // VEHICLE BRAND SELECTOR
  void pickBrand() {
    final vehicleBrandVm = Provider.of<VehicleBrandViewModel>(
      context,
      listen: false,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              // ---------------- TOP BAR ----------------
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 30),
                    const TextConst(
                      title: "Vehicle Brand",
                      size: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              // ---------------- SEARCH BAR (UI ONLY) ----------------
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text("Start typing", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ---------------- BRAND LIST ----------------
              Expanded(
                child: vehicleBrandVm.loading
                    ? const Center(child: CircularProgressIndicator())
                    : vehicleBrandVm.vehicleBrandModel?.data == null ||
                          vehicleBrandVm.vehicleBrandModel!.data!.isEmpty
                    ? const Center(child: Text("No brands found"))
                    : ListView.builder(
                        itemCount:
                            vehicleBrandVm.vehicleBrandModel!.data!.length,
                        itemBuilder: (_, i) {
                          final brand =
                              vehicleBrandVm.vehicleBrandModel!.data![i];

                          return ListTile(
                            title: TextConst(title: brand.name ?? ""),
                            trailing: selectedBrandId == brand.id
                                ? const Icon(
                                    Icons.check,
                                    color: AppColor.royalBlue,
                                  )
                                : null,
                            onTap: () {
                              setState(() {
                                selectedBrand = brand.name;
                                selectedBrandId = brand.id;
                                selectedModel = null;
                              });

                              context
                                  .read<VehicleModelViewModel>()
                                  .vehicleModelApi(brand.id!, context);

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
  }

  void pickModel() {
    final vehicleModelVm = Provider.of<VehicleModelViewModel>(
      context,
      listen: false,
    );
    if (selectedBrand == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select vehicle brand first!")),
      );
      return;
    }

    // List<String> models = modelMap[selectedBrand] ?? [];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const TextConst(
                title: "Vehicle model",
                size: 20,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: vehicleModelVm.vehicleSameModel?.data?.length ?? 0,
                  itemBuilder: (_, i) {
                    final model = vehicleModelVm.vehicleSameModel!.data![i];

                    return ListTile(
                      title: TextConst(title: model.name ?? ""),
                      trailing: selectedModel == model.name
                          ? const Icon(Icons.check, color: AppColor.royalBlue)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedModel = model.name;
                          selectedModelId = model.id; // 🔥 IMPORTANT
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
  }

  // VEHICLE COLOR SELECTOR
  void pickColor() {
    final vehicleColorVm = Provider.of<VehicleColorsViewModel>(
      context,
      listen: false,
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.72,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextConst(
                title: "Vehicle color",
                size: 20,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount:
                      vehicleColorVm.vehicleColorsModel?.data?.length ?? 0,
                  itemBuilder: (_, i) {
                    final colorItem =
                        vehicleColorVm.vehicleColorsModel!.data![i];

                    return ListTile(
                      title: TextConst(title: colorItem.name ?? ""),
                      trailing: selectedColor == colorItem.name
                          ? const Icon(Icons.check, color: AppColor.royalBlue)
                          : null,
                      onTap: () {
                        setState(() {
                          selectedColor = colorItem.name;
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
  }

  // INPUT FIELD CONTAINER
  Widget dropdownField({
    required String hint,
    required VoidCallback onTap,
    required String? value,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        margin: const EdgeInsets.only(top: 18),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.centerLeft,
        child: TextConst(
          title: value ?? hint,
          color: value == null ? Colors.grey : Colors.black,
          fontFamily: AppFonts.kanitReg,
          size: 17,
        ),
      ),
    );
  }

  // bottom sheet for selecting image
  void showPicker() {
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
                leading: Icon(Icons.photo, color: AppColor.royalBlue),
                title: const Text("Select from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(false);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColor.royalBlue),
                title: const Text("Take Photo"),
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
    final driverRegisterFiveVm = Provider.of<DriverRegisterFiveViewModel>(
      context,
    );
    return Stack(
      children: [
        SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            backgroundColor: AppColor.white,

            appBar: ConstantAppbar(
              onBack: () => Navigator.pop(context),
              onClose: () => Navigator.pop(context),
            ),

            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: topPadding),

                  TextConst(
                    title: "Vehicle information",
                    size: 25,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(height: 25),

                  // VEHICLE IMAGE
                  GestureDetector(
                    onTap: showPicker,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.grey.shade100,
                            image: vehiclePhoto != null
                                ? DecorationImage(
                                    image: FileImage(vehiclePhoto!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: vehiclePhoto == null
                              ? const Icon(Icons.add, size: 35)
                              : null,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Photo of your\nvehicle",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // DROPDOWN FIELDS
                  dropdownField(
                    hint: "Vehicle brand",
                    onTap: pickBrand,
                    value: selectedBrand,
                  ),
                  dropdownField(
                    hint: "Vehicle model",
                    onTap: pickModel,
                    value: selectedModel,
                  ),
                  dropdownField(
                    hint: "Vehicle color",
                    onTap: pickColor,
                    value: selectedColor,
                  ),

                  inputField(
                    hint: "Plate number",
                    controller: plateController,
                  ),

                  inputField(
                    hint: "Vehicle production year",
                    controller: yearController,
                  ),


                  SizedBox(height: Sizes.screenHeight * 0.03),

                  /// FOOTER
                  Row(
                    children: [
                      TextConst(
                        title: "5 of 6",
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
                                width: 94,
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
                            driverRegisterFiveVm.driverRegisterFiveApi(
                              vehiclePhoto: vehiclePhoto!,
                              vehicleInfoStatus: "1",
                              brandId: selectedBrandId,
                              brandName: selectedBrand,
                              modelId: selectedModelId,
                              modelName: selectedModel,
                              vehicleColor: selectedColor,
                              vehiclePlateNumber: plateController.text,
                              vehicleProductionYear: yearController.text,
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
        if (driverRegisterFiveVm.loading)
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
    );
  }

  Widget inputField({
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      margin: const EdgeInsets.only(top: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 17,
            fontFamily: AppFonts.kanitReg,
            color: Colors.grey,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

}
