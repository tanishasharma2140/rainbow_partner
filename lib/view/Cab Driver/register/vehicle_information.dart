import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/vehicle_document.dart';

class VehicleInformation extends StatefulWidget {
  const VehicleInformation({super.key});

  @override
  State<VehicleInformation> createState() => _VehicleInformationState();
}

class _VehicleInformationState extends State<VehicleInformation> {
  File? vehiclePhoto;

  String? selectedBrand;
  String? selectedModel;
  String? selectedColor;

  TextEditingController plateController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  final picker = ImagePicker();

  // BRAND LIST
  List<String> brandList = [
    "Maruti Suzuki",
    "Hyundai",
    "Tata",
    "Mahindra",
    "Kia",
    "Toyota",
    "Honda",
    "Renault",
    "BMW",
    "Audi",
    "Mercedes"
  ];

  // MODEL LIST (Auto fill)
  Map<String, List<String>> modelMap = {
    "Maruti Suzuki": ["Swift", "Dzire", "Baleno", "WagonR"],
    "Hyundai": ["i10", "i20", "Creta", "Verna"],
    "Tata": ["Nexon", "Punch", "Harrier", "Altroz"],
    "Mahindra": ["Thar", "Bolero", "Scorpio", "XUV700"],
    "Kia": ["Seltos", "Sonet", "Carnival"],
    "Toyota": ["Glanza", "Innova", "Fortuner"],
    "Honda": ["City", "Amaze", "Jazz"],
    "Renault": ["Kwid", "Triber", "Duster"],
    "BMW": ["X1", "X3", "5 Series"],
    "Audi": ["A4", "Q3", "Q7"],
    "Mercedes": ["C Class", "E Class", "GLA"],
  };

  // COLOR LIST
  List<Map<String, dynamic>> colorList = [
    {"name": "Beige", "color": Colors.grey},
    {"name": "Black", "color": Colors.black},
    {"name": "Blue", "color": Colors.blue},
    {"name": "Bronze", "color": Colors.brown.shade400},
    {"name": "Brown", "color": Colors.brown},
    {"name": "Burgundy", "color": Colors.red.shade900},
    {"name": "Dark gray", "color": Colors.grey.shade800},
    {"name": "Gold", "color": Colors.amber},
    {"name": "Gray", "color": Colors.grey},
    {"name": "Green", "color": Colors.green},
    {"name": "Light blue", "color": Colors.lightBlueAccent},
    {"name": "Orange", "color": Colors.orange},
    {"name": "Pink", "color": Colors.pinkAccent},
  ];

  // IMAGE PICKER
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

              // TOP BAR WITH TITLE + CLOSE BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 30), // just to balance layout

                     TextConst(
                       title:
                      "Vehicle brand",
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

              // Search bar
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

              // LIST
              Expanded(
                child: ListView.builder(
                  itemCount: brandList.length,
                  itemBuilder: (_, i) {
                    return ListTile(
                      title: TextConst(title: brandList[i]),
                      onTap: () {
                        selectedBrand = brandList[i];
                        selectedModel = null;
                        Navigator.pop(context);
                        setState(() {});
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


  // VEHICLE MODEL SELECTOR
  void pickModel() {
    if (selectedBrand == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select vehicle brand first!"),
      ));
      return;
    }

    List<String> models = modelMap[selectedBrand] ?? [];

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
              const TextConst(title: "Vehicle model",
                  size: 20, fontWeight: FontWeight.w700),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: models.length,
                  itemBuilder: (_, i) {
                    return ListTile(
                      title: TextConst(title: models[i]),
                      onTap: () {
                        selectedModel = models[i];
                        Navigator.pop(context);
                        setState(() {});
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
               TextConst(title: "Vehicle color",
                   size: 20, fontWeight: FontWeight.w700),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: colorList.length,
                  itemBuilder: (_, i) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 12,
                        backgroundColor: colorList[i]["color"],
                      ),
                      title: TextConst(title: colorList[i]["name"]),
                      onTap: () {
                        selectedColor = colorList[i]["name"];
                        Navigator.pop(context);
                        setState(() {});
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
  Widget dropdownField({required String hint, required VoidCallback onTap, required String? value}) {
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
          title:
          value ?? hint,
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
    return SafeArea(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  children: [
                    Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade100,
                        image: vehiclePhoto != null
                            ? DecorationImage(image: FileImage(vehiclePhoto!), fit: BoxFit.cover)
                            : null,
                      ),
                      child: vehiclePhoto == null
                          ? const Icon(Icons.add, size: 35)
                          : null,
                    ),
                    const SizedBox(height: 8),
                    const Text("Photo of your\nvehicle", textAlign: TextAlign.center)
                  ],
                ),
              ),

              // DROPDOWN FIELDS
              dropdownField(hint: "Vehicle brand", onTap: pickBrand, value: selectedBrand),
              dropdownField(hint: "Vehicle model", onTap: pickModel, value: selectedModel),
              dropdownField(hint: "Vehicle color", onTap: pickColor, value: selectedColor),

              inputField("Plate number"),
              inputField("Vehicle production year"),

              const Spacer(),

              /// FOOTER
              Row(
                children: [
                  TextConst(title: "4 of 5", size: 18, fontWeight: FontWeight.w600),

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
                            width: 95,
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
                        Navigator.push(context, CupertinoPageRoute(builder: (context)=>VehicleDocument()));
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
  Widget inputField(String hint) {
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
