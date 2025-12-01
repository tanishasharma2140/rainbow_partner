import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';

class AddServices extends StatefulWidget {
  const AddServices({super.key});

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  // ---------------- IMAGE PICKER ----------------
  final ImagePicker picker = ImagePicker();
  List<XFile> selectedImages = [];

  // ---------------- SERVICE FIELDS ----------------
  String selectedCategory = "Select Category";
  String selectedSubCategory = "Select SubCategory";
  String selectedType = "Fixed";
  String selectedStatus = "Active";

  final List<String> typeList = ["Fixed", "Hourly"];
  final List<String> statusList = ["Active", "Inactive"];

  final List<String> categoryList = [
    "Cleaning",
    "Plumbing",
    "AC Repair",
    "Electrician"
  ];

  final Map<String, List<String>> subCategoryMap = {
    "Cleaning": ["Home Cleaning", "Office Cleaning", "Deep Cleaning"],
    "Plumbing": ["Leak Fix", "Tap Install", "Pipeline Repair"],
    "AC Repair": ["Gas Filling", "Cooling Issue", "AC Servicing"],
    "Electrician": ["Switch Repair", "Wiring", "Light Install"]
  };

  String visitOption = "On-Site Visit";
  bool isFeature = false;

  // ---------------- POPUP ----------------
  void openChooseImagePopup() {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: AppColor.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 TextConst(title: "Choose Action",
                     size: 20, fontWeight: FontWeight.w700),
                const SizedBox(height: 10),

                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, size: 28),
                  title: const TextConst(title: "Camera"),
                  onTap: () {
                    pickFromCamera();
                    Navigator.pop(context);
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, size: 28),
                  title: const TextConst(title: "Gallery"),
                  onTap: () {
                    pickFromGallery();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- PICK CAMERA ----------------
  Future<void> pickFromCamera() async {
    final XFile? img = await picker.pickImage(source: ImageSource.camera);
    if (img != null) {
      setState(() => selectedImages.add(img));
    }
  }

  // ---------------- MULTIPLE FROM GALLERY ----------------
  Future<void> pickFromGallery() async {
    final List<XFile> imgs = await picker.pickMultiImage();
    if (imgs.isNotEmpty) {
      setState(() => selectedImages.addAll(imgs));
    }
  }

  // ---------------- REMOVE IMAGE ----------------
  void removeImage(int index) {
    setState(() => selectedImages.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,

        // ---------------- APP BAR ----------------
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
                  title:
                  "Add Service",
                  color: Colors.white, size: 20, fontWeight: FontWeight.w600
              ),
            ],
          ),
        ),

        // ---------------- BODY ----------------
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: openChooseImagePopup,
                  child: DottedBorder(
                    color: AppColor.grey,
                    strokeWidth: 1.5,
                    dashPattern: const [6, 4],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(12),
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: selectedImages.isEmpty
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image_outlined,
                              size: 45, color: Colors.grey),
                          SizedBox(height: 8),
                          TextConst(title: "Choose Image",
                              size: 16, color: Colors.grey),
                        ],
                      )
                          : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(selectedImages.first.path),
                          width: double.infinity,
                          height: 160,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                const TextConst(
                  title:
                  "Note: You can upload multiple images ('jpg','png','jpeg')",
                    size: 12, color: Colors.grey
                ),

                if (selectedImages.isNotEmpty) ...[
                  const SizedBox(height: 15),

                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedImages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, index) {
                        return Stack(
                          clipBehavior: Clip.none,   // <-- IMPORTANT
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(selectedImages[index].path),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),

                            // ❌ CROSS ICON SHOULD BE OUTSIDE IMAGE
                            Positioned(
                              top: -6,         // <-- moves icon above image
                              right: -6,       // <-- moves icon outside right side
                              child: GestureDetector(
                                onTap: () => removeImage(index),
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.close,
                                      size: 15, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )

                ],

                const SizedBox(height: 20),

                // -------------------------------------------------------------
                // INPUT FORM
                // -------------------------------------------------------------
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      buildInput("Service Name"),
                      const SizedBox(height: 15),

                      // CATEGORY
                      buildSelector(selectedCategory, openCategorySheet),
                      const SizedBox(height: 15),

                      // SUB CATEGORY
                      buildSelector(selectedSubCategory, () {
                        if (selectedCategory == "Select Category") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select category first"),
                            ),
                          );
                        } else {
                          openSubCategorySheet();
                        }
                      }),

                      const SizedBox(height: 15),

                      buildInput("Price"),
                      const SizedBox(height: 15),

                      buildInput("Discount (%)"),
                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Expanded(child: buildInput("Duration: Hours")),
                          const SizedBox(width: 10),
                          Expanded(child: buildInput("Duration: Minutes")),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // TYPE & STATUS DROPDOWNS
                      Row(
                        children: [
                          Expanded(
                            child: buildDropdown(
                              selectedType,
                              typeList,
                                  (val) => setState(() => selectedType = val),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: buildDropdown(
                              selectedStatus,
                              statusList,
                                  (val) => setState(() => selectedStatus = val),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      // DESCRIPTION
                      Container(
                        height: 110,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          maxLines: 5,
                          decoration: InputDecoration(
                              hintText: "Description",
                              hintStyle: TextStyle(fontFamily: AppFonts.kanitReg),
                              border: InputBorder.none),
                        ),
                      ),

                      const SizedBox(height: 5),

                      // FEATURE TOGGLE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           TextConst(title: "Set as Feature"),
                          Checkbox(
                            value: isFeature,
                            activeColor: AppColor.royalBlue,
                            onChanged: (v) => setState(() => isFeature = v!),
                          ),
                        ],
                      ),


                    ],
                  ),
                ),

                const SizedBox(height: 12),

                 TextConst(title: "Visit Option",
                     size: 18, fontWeight: FontWeight.w600),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    buildVisitOption("On-Site Visit"),
                    buildVisitOption("Online/Remote Service"),
                    buildVisitOption("Shop"),
                  ],
                ),

                const SizedBox(height: 40),

                 CustomButton(
                     bgColor: AppColor.royalBlue,
                     textColor: AppColor.white,
                     title: "Save", onTap: (){}),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget buildInput(String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: hint, border: InputBorder.none,
           hintStyle: TextStyle(
             fontFamily: AppFonts.kanitReg
           )
        ),
      ),
    );
  }

  Widget buildSelector(String label, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextConst(title:label),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  Widget buildDropdown(
      String value, List<String> list, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: const InputDecoration(border: InputBorder.none),
        items: list
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }

  Widget buildVisitOption(String label) {
    bool selected = visitOption == label;

    return GestureDetector(
      onTap: () => setState(() => visitOption = label),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 160,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? AppColor.royalBlue : Colors.grey.shade400,
                width: 1.5,
              ),
            ),
            child: Center(
              child: TextConst(
                title:
                label,
                textAlign: TextAlign.center,
                size: 15,
                color: selected ? AppColor.royalBlue : Colors.black,
              ),
            ),
          ),

          // ✅ Purple Tick Outside Box (Correct Position)
          if (selected)
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 28,  // fixed circle size
                height: 28,
                decoration: BoxDecoration(
                  color: AppColor.royalBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }


  void openCategorySheet() {
    showModalBottomSheet(
      context: context,
      shape:
      const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const TextConst(title: "Select Category",
                size: 18, fontWeight: FontWeight.w700),
            const SizedBox(height: 10),

            ...categoryList.map((e) => ListTile(
              title: Text(e),
              onTap: () {
                setState(() {
                  selectedCategory = e;
                  selectedSubCategory = "Select SubCategory";
                });
                Navigator.pop(context);
              },
            ))
          ],
        );
      },
    );
  }

  void openSubCategorySheet() {
    showModalBottomSheet(
      context: context,
      shape:
      const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextConst(title:"Select $selectedCategory",
            size: 18, fontWeight: FontWeight.w700),
            const SizedBox(height: 10),

            ...subCategoryMap[selectedCategory]!.map((e) => ListTile(
              title: Text(e),
              onTap: () {
                setState(() => selectedSubCategory = e);
                Navigator.pop(context);
              },
            ))
          ],
        );
      },
    );
  }
}
