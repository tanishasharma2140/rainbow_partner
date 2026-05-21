import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/gradient_circle_pro.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_register_five_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/vehicle_colors_view_model.dart';
import 'package:rainbow_partner/view_model/cabdriver/vehicle_fuel_view_model.dart';
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
  String? selectedFuelType;
  int? selectedFuelTypeId;

  TextEditingController plateController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final vehicleVm = Provider.of<VehicleViewModel>(context, listen: false);
    
    await vehicleVm.loadSelectedVehicle();

    if (!mounted) return;

    final selectedVehicleId = vehicleVm.selectedVehicleId;
    final selectedVehicleCategory = vehicleVm.selectedVehicleCategory;

    if (selectedVehicleId != null) {
      context.read<VehicleBrandViewModel>().vehicleBrandApi(
        selectedVehicleId,
        context,
      );
    } else {
      if (kDebugMode) print("❌ Vehicle ID not found after loading");
    }

    if (selectedVehicleCategory != null) {
      final vehicleFuelVm = Provider.of<VehicleFuelViewModel>(context, listen: false);
      vehicleFuelVm.vehicleFuelApi(selectedVehicleCategory.toString());
    }

    final vehicleColorVm = Provider.of<VehicleColorsViewModel>(context, listen: false);
    vehicleColorVm.vehicleColorsApi(context);
  }

  // final RegExp vehicleNumberRegex = RegExp(
  //     r'^([A-Z]{2}\s[0-9]{2}\s[A-Z]{2}\s[0-9]{4})$|^([A-Z]{2}\s[0-9]{2}\s[0-9]{4})$'
  // );
  String? vehicleNumberError;

  bool _validateVehicleInfo() {
    final loc = AppLocalizations.of(context)!;
    if (vehiclePhoto == null) {
      _showError(loc.please_upload_vehicle_photo);
      return false;
    }

    if (selectedBrandId == null) {
      _showError(loc.please_select_vehicle_brand);
      return false;
    }

    if (selectedModelId == null) {
      _showError(loc.please_select_vehicle_model);
      return false;
    }

    if (selectedColor == null || selectedColor!.isEmpty) {
      _showError(loc.please_select_vehicle_color);
      return false;
    }

    if (plateController.text.trim().isEmpty) {
      _showError(loc.please_enter_vehicle_plate_number);
      return false;
    }
    if (!isValidIndianVehicle(plateController.text.trim())) {
      _showError(loc.please_enter_valid_vehicle_number);
      return false;
    }



    if (yearController.text.trim().isEmpty) {
      _showError(loc.please_select_vehicle_production_year);
      return false;
    }

    return true;
  }

  void _showError(String message) {
     Utils.showErrorMessage(context, message);
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

  bool isValidIndianVehicle(String input) {
    final reg = RegExp(
        r'(^[A-Z]{2}[0-9]{1,2}[A-Z]{1,3}[0-9]{4}$)' // Normal
        r'|(^[0-9]{2}BH[0-9]{4}[A-Z]{1,2}$)'        // BH Series
        r'|(^TR[0-9]{2}[A-Z]{2}[0-9]{4}$)'          // Trade
        r'|(^[A-Z]{2}TC[0-9]{4}[A-Z]{1,2}$)'        // Temporary
        r'|((CD|CC)[0-9]{4}$)'                      // Diplomatic
        r'|(^[A-Z]{2}VA[0-9]{4}$)'                  // Vintage
    );

    return reg.hasMatch(
      input.toUpperCase().replaceAll(" ", ""),
    );
  }

  Future<void> _selectYear(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    int currentYear = DateTime.now().year;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            height: 350,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  loc.select_production_year,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: YearPicker(
                    firstDate: DateTime(1980),
                    lastDate: DateTime(currentYear),
                    selectedDate: DateTime(currentYear),
                    onChanged: (DateTime dateTime) {
                      yearController.text = dateTime.year.toString();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  // VEHICLE BRAND SELECTOR
  void pickBrand() {
    final loc = AppLocalizations.of(context)!;
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
                    TextConst(
                      title: loc.vehicle_brand,
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

              const SizedBox(height: 10),

              // ---------------- BRAND LIST ----------------
              Expanded(
                child: vehicleBrandVm.loading
                    ? const Center(child: CircularProgressIndicator())
                    : vehicleBrandVm.vehicleBrandModel?.data == null ||
                          vehicleBrandVm.vehicleBrandModel!.data!.isEmpty
                    ? Center(child: Text(loc.no_brands_found))
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
    final loc = AppLocalizations.of(context)!;
    final vehicleModelVm = Provider.of<VehicleModelViewModel>(
      context,
      listen: false,
    );
    if (selectedBrand == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.please_select_vehicle_brand_first)),
      );
      return;
    }

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
              TextConst(
                title: loc.vehicle_model,
                size: 20,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 20),

              Expanded(
                child: vehicleModelVm.loading
                    ? const Center(child: CircularProgressIndicator())
                    : vehicleModelVm.vehicleSameModel?.data == null ||
                    vehicleModelVm.vehicleSameModel!.data!.isEmpty
                    ? Center(child: Text(loc.no_models_found))
                    : ListView.builder(
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
                                selectedModelId = model.id;
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
    final loc = AppLocalizations.of(context)!;
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
                title: loc.vehicle_color,
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

  void pickFuelType() {
    final loc = AppLocalizations.of(context)!;
    final vehicleFuelVm = Provider.of<VehicleFuelViewModel>(
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
          height: MediaQuery.of(context).size.height * 0.55,
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
                    TextConst(
                      title: loc.fuel_type,
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

              const SizedBox(height: 10),

              // ---------------- FUEL LIST ----------------
              Expanded(
                child: vehicleFuelVm.loading
                    ? const Center(child: CircularProgressIndicator())
                    : vehicleFuelVm.vehicleFuelModel?.data == null ||
                    vehicleFuelVm.vehicleFuelModel!.data!.isEmpty
                    ? Center(child: Text(loc.no_fuel_types_found))
                    : ListView.builder(
                  itemCount: vehicleFuelVm.vehicleFuelModel!.data!.length,
                  itemBuilder: (_, i) {
                    final fuel = vehicleFuelVm.vehicleFuelModel!.data![i];

                    return ListTile(
                      title: TextConst(title: fuel.fuelType ?? ""),
                      trailing: selectedFuelTypeId == fuel.id
                          ? const Icon(
                        Icons.check,
                        color: AppColor.royalBlue,
                      )
                          : null,
                      onTap: () {
                        setState(() {
                          selectedFuelType = fuel.fuelType;
                          selectedFuelTypeId = fuel.id;
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
    final loc = AppLocalizations.of(context)!;
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
                leading: const Icon(Icons.photo, color: AppColor.royalBlue),
                title: Text(loc.select_from_gallery),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColor.royalBlue),
                title: Text(loc.take_photo),
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
    final driverRegisterFiveVm = Provider.of<DriverRegisterFiveViewModel>(
      context,
    );
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: true,
            child: Scaffold(
              backgroundColor: AppColor.white,

              appBar: ConstantAppbar(
                onBack: () => Navigator.pop(context),
                onClose: () =>  SystemNavigator.pop(),
              ),

              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: ListView(
                  children: [
                    SizedBox(height: topPadding),

                    TextConst(
                      title: loc.vehicle_information,
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
                          Text(
                            loc.photo_of_your_vehicle,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    // DROPDOWN FIELDS
                    dropdownField(
                      hint: loc.vehicle_brand_hint,
                      onTap: pickBrand,
                      value: selectedBrand,
                    ),
                    dropdownField(
                      hint: loc.vehicle_model_hint,
                      onTap: pickModel,
                      value: selectedModel,
                    ),
                    dropdownField(
                      hint: loc.vehicle_color_hint,
                      onTap: pickColor,
                      value: selectedColor,
                    ),
                    dropdownField(
                      hint: loc.fuel_type_hint,
                      onTap: pickFuelType,
                      value: selectedFuelType,
                    ),

                    inputField(
                      hint: loc.vehicle_number,
                      controller: plateController,
                    ),

                    inputField(
                      hint: loc.vehicle_production_year,
                      controller: yearController,
                      readOnly: true,
                      onTap: () => _selectYear(context),
                    ),


                    SizedBox(height: Sizes.screenHeight * 0.03),

                    /// FOOTER
                    Row(
                      children: [
                        const TextConst(
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
                            title: loc.next,
                            bgColor: AppColor.royalBlue,
                            textColor: Colors.white,
                            onTap: () {
                              if (!_validateVehicleInfo()) return;
                              driverRegisterFiveVm.driverRegisterFiveApi(
                                vehiclePhoto: vehiclePhoto!,
                                vehicleInfoStatus: "1",
                                brandId: selectedBrandId!,
                                brandName: selectedBrand!,
                                modelId: selectedModelId!,
                                modelName: selectedModel!,
                                vehicleColor: selectedColor!,
                                vehicleFuelTypeName: selectedFuelType!,
                                vehicleFuelTypeId: selectedFuelTypeId!,
                                vehiclePlateNumber: plateController.text.trim(),
                                vehicleProductionYear: yearController.text.trim(),
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
    );
  }



  Widget inputField({
    required String hint,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    final loc = AppLocalizations.of(context)!;
    final bool isVehicleNumber = hint == loc.vehicle_number;

    Widget field = Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      margin: const EdgeInsets.only(top: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),

        /// 🔴 RED BORDER ONLY FOR VEHICLE NUMBER
        border: isVehicleNumber && vehicleNumberError != null
            ? Border.all(color: Colors.red)
            : null,
      ),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,

        /// ⌨️ INPUT FORMAT ONLY FOR VEHICLE NUMBER
        inputFormatters: isVehicleNumber
            ? [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
          LengthLimitingTextInputFormatter(10),
          VehicleNumberFormatter(),
        ]
            : null,

        /// 🔍 VALIDATION ONLY FOR VEHICLE NUMBER
        onChanged: isVehicleNumber
            ? (value) {
          if (value.isEmpty) {
            setState(() => vehicleNumberError = null);
          } else if (!isValidIndianVehicle(value)) {
            setState(() => vehicleNumberError = loc.enter_valid_vehicle_number);
          } else {
            setState(() => vehicleNumberError = null);
          }
        }
            : null,

        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 17,
            fontFamily: AppFonts.kanitReg,
            color: Colors.grey,
          ),
          border: InputBorder.none,
          suffixIcon: readOnly
              ? const Icon(Icons.calendar_today, size: 20, color: Colors.grey)
              : null,
        ),
      ),
    );

    /// ⛔ ERROR TEXT ONLY FOR VEHICLE NUMBER
    if (!isVehicleNumber) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        field,
        if (vehicleNumberError != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 6),
            child: Text(
              vehicleNumberError!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }




}
class VehicleNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text.toUpperCase().replaceAll(' ', '');

    // max: AA00AA0000 (10 chars)
    if (text.length > 10) {
      text = text.substring(0, 10);
    }

    // NEW FORMAT → AA 00 AA 0000
    if (text.length >= 7 &&
        RegExp(r'^[A-Z]{2}[0-9]{2}[A-Z]{2}[0-9]').hasMatch(text)) {
      String p1 = text.substring(0, 2);
      String p2 = text.substring(2, 4);
      String p3 = text.substring(4, 6);
      String p4 = text.substring(6);
      text = "$p1 $p2 $p3 $p4";
    }

    // OLD FORMAT → AA 00 0000
    else if (text.length >= 6 &&
        RegExp(r'^[A-Z]{2}[0-9]{2}[0-9]{4}$').hasMatch(text)) {
      String p1 = text.substring(0, 2);
      String p2 = text.substring(2, 4);
      String p3 = text.substring(4, 8);
      text = "$p1 $p2 $p3";
    }

    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

