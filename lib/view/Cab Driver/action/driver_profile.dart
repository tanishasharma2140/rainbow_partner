import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/res/app_color.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  @override
  Widget build(BuildContext context) {
    File? profileImg;
    File? dlFront;
    File? dlBack;
    File? aadhaar;
    File? panCard;

    String name = "John";
    String surname = "Doe";
    String mobile = "9876543210";
    String dob = "12/08/1999";
    String dlNumber = "DL-45-2020-8899";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const TextConst(
          title: "Driver Profile",
          size: 18,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: AppColor.royalBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ------------------ PROFILE PICTURE ------------------
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                    profileImg != null ? FileImage(profileImg!) : null,
                    child: profileImg == null
                        ? const Icon(Icons.person, size: 70, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextConst(
                    title: "Driver Photo",
                    size: 13,
                    color: Colors.grey,
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ------------------ PERSONAL DETAILS ------------------
            sectionTitle("Personal Details"),
            infoTile("Name", "$name $surname"),
            infoTile("Mobile Number", mobile),
            infoTile("Date of Birth", dob),

            const SizedBox(height: 30),

            // ------------------ DRIVING LICENSE ------------------
            sectionTitle("Driving License"),

            Row(
              children: [
                Expanded(child: viewImageBox("Front Side", dlFront)),
                const SizedBox(width: 14),
                Expanded(child: viewImageBox("Back Side", dlBack)),
              ],
            ),

            const SizedBox(height: 12),
            infoTile("License Number", dlNumber),

            const SizedBox(height: 30),

            // ------------------ AADHAAR & PAN ------------------
            sectionTitle("Aadhaar & PAN Card"),

            Row(
              children: [
                Expanded(child: viewImageBox("Aadhaar", aadhaar)),
                const SizedBox(width: 14),
                Expanded(child: viewImageBox("PAN Card", panCard)),
              ],
            ),

            const SizedBox(height: 30),

            // ------------------ CERTIFICATES & VEHICLE INFO ------------------
            sectionTitle("Certificates"),

            optionButton(
              title: "View Required Certificates",
              icon: Icons.file_copy,
              onTap: () {},
            ),

            const SizedBox(height: 12),

            optionButton(
              title: "View Vehicle Information",
              icon: Icons.directions_car,
              onTap: () {},
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  //                     CUSTOM WIDGETS
  // -----------------------------------------------------------

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextConst(
        title: title,
        size: 18,
        fontWeight: FontWeight.w700,
        color: AppColor.royalBlue,
      ),
    );
  }

  Widget infoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          TextConst(
            title: "$label: ",
            size: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
          Expanded(
            child: TextConst(
              title: value,
              size: 15,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget viewImageBox(String label, File? file) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            image: file != null
                ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
                : null,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: file == null
              ? const Center(
              child: Icon(Icons.image_not_supported,
                  size: 35, color: Colors.grey))
              : null,
        ),
        const SizedBox(height: 6),
        TextConst(
          title: label,
          size: 13,
        ),
      ],
    );
  }

  Widget optionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.royalBlue),
            const SizedBox(width: 14),
            Expanded(
              child: TextConst(
                title: title,
                size: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 18, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
