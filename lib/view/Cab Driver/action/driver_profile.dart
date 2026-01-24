import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/auth/splash.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/user_view_model.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {

  void _openFullImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.8,
              maxScale: 4.0,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
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
        actions: [
          GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: AppColor.white,
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  builder: (BuildContext context) {
                    return logoutBottomSheet(context);
                  },
                );
              },
              child: Icon(Icons.logout)),
          SizedBox(width: 13,)
        ],
      ),



      body: Consumer<DriverProfileViewModel>(
        builder: (context, vm, _) {
          final data = vm.driverProfileModel?.data;

          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ---------------- PROFILE PHOTO ----------------
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: data.profilePhoto != null &&
                            data.profilePhoto.toString().isNotEmpty
                            ? NetworkImage(data.profilePhoto)
                            : null,
                        child: data.profilePhoto == null ||
                            data.profilePhoto.toString().isEmpty
                            ? const Icon(Icons.person,
                            size: 70, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 8),
                      const TextConst(
                        title: "Driver Photo",
                        size: 13,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ---------------- PERSONAL DETAILS ----------------
                sectionTitle("Personal Details"),
                infoTile(
                  "Name",
                  [
                    data.firstName,
                    data.lastName,
                  ].where((e) => e != null && e.toString().isNotEmpty).join(" "),
                ),
                infoTile("Mobile Number", data.mobile?.toString() ?? "--"),
                infoTile("Date of Birth", data.dateOfBirth?.toString() ?? "--"),

                const SizedBox(height: 30),

                // ---------------- DRIVING LICENSE ----------------
                sectionTitle("Driving License"),
                Row(
                  children: [
                    Expanded(
                        child: viewImageBox(
                            "Front Side", data.driverLicenceFront)),
                    const SizedBox(width: 14),
                    Expanded(
                        child: viewImageBox(
                            "Back Side", data.driverLicenceBack)),
                  ],
                ),
                const SizedBox(height: 12),
                infoTile("License Number",
                    data.driverLicenceNumber?.toString() ?? "--"),

                const SizedBox(height: 30),

                // ---------------- AADHAAR ----------------
                sectionTitle("Aadhaar Card"),
                Row(
                  children: [
                    Expanded(
                        child: viewImageBox(
                            "Front Side", data.aadhaarFront)),
                    const SizedBox(width: 14),
                    Expanded(
                        child:
                        viewImageBox("Back Side", data.aadhaarBack)),
                  ],
                ),
                SizedBox(height: 12,),
                infoTile(
                    "Aadhaar Number", data.aadhaarNumber?.toString() ?? "--"),

                const SizedBox(height: 30),

                // ---------------- PAN ----------------
                sectionTitle("PAN Card"),
                Row(
                  children: [
                    Expanded(
                        child:
                        viewImageBox("Front Side", data.panCardFront)),
                    const SizedBox(width: 14),

                  ],
                ),
                SizedBox(height: 12,),
                infoTile("PAN Number",
                    data.panCardNumber?.toString() ?? "--"),

                const SizedBox(height: 20),

                // ---------------- VEHICLE DETAILS ----------------
                sectionTitle("Vehicle Details"),
                infoTile("Brand", data.brandName?.toString() ?? "--"),
                infoTile("Model", data.modelName?.toString() ?? "--"),
                infoTile("Color", data.vehicleColor?.toString() ?? "--"),
                infoTile("Plate Number",
                    data.vehiclePlateNumber?.toString() ?? "--"),
                infoTile("Production Year",
                    data.vehicleProductionYear?.toString() ?? "--"),

                const SizedBox(height: 20),
                viewImageBox("Vehicle Photo", data.vehiclePhoto),

                const SizedBox(height: 30),

                // ---------------- VEHICLE DOCUMENTS ----------------
                if (data.vehicleCategory != 2) ...[
                  sectionTitle("Vehicle Documents"),
                  Row(
                    children: [
                      Expanded(
                          child: viewImageBox(
                              "RC Front", data.vehicleRegistrationFront)),
                      const SizedBox(width: 14),
                      Expanded(
                          child: viewImageBox(
                              "RC Back", data.vehicleRegistrationBack)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                          child: viewImageBox(
                              "Permit Part A", data.vehiclePermitPartA)),
                      const SizedBox(width: 14),
                      Expanded(
                          child: viewImageBox(
                              "Permit Part B", data.vehiclePermitPartB)),
                    ],
                  ),
                ],

                const SizedBox(height: 30),

                // ---------------- CERTIFICATES ----------------
                sectionTitle("Certificates"),

                if (data.fitnessCertificate != null && data.fitnessCertificate.toString().isNotEmpty) ...[
                  viewImageBox("Fitness Certificate", data.fitnessCertificate),
                  const SizedBox(height: 12),
                ],

                viewImageBox("Insurance Certificate", data.insuranceCertificate),
                const SizedBox(height: 12),

                viewImageBox("Pollution Certificate", data.pollutionCertificate),
                const SizedBox(height: 12),

                if (data.policeCertificate != null && data.policeCertificate.toString().isNotEmpty) ...[
                  viewImageBox("Police Verification", data.policeCertificate),
                  const SizedBox(height: 12),
                ],

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------- COMMON UI (UNCHANGED) ----------------

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

  Widget viewImageBox(String label, String? imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: imageUrl != null && imageUrl.isNotEmpty
              ? () => _openFullImage(imageUrl)
              : null,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              image: imageUrl != null && imageUrl.isNotEmpty
                  ? DecorationImage(
                  image: NetworkImage(imageUrl), fit: BoxFit.cover)
                  : null,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: imageUrl == null || imageUrl.isEmpty
                ? const Center(
              child: Icon(Icons.image_not_supported,
                  size: 35, color: Colors.grey),
            )
                : null,
          ),
        ),
        const SizedBox(height: 6),
        TextConst(title: label, size: 13),
      ],
    );
  }
  Widget logoutBottomSheet(context) {
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: EdgeInsets.all(Sizes.screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextConst(
                title: "Are you sure you want to log out?",
                size: 16,
                color:AppColor.black),
            SizedBox(height: Sizes.screenHeight * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: Sizes.screenHeight * 0.058,
                    width: Sizes.screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      border: Border.all(
                          color: AppColor.royalBlue.withOpacity(0.75), width: 2),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: TextConst(
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.kanitReg,
                          title: "No", color: AppColor.royalBlue),
                    ),
                  ),
                ),
                SizedBox(
                  width: Sizes.screenWidth * 0.02,
                ),
                InkWell(
                  onTap: () {
                    UserViewModel().remove();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Splash()),
                            (context) => false);
                  },
                  child: Container(
                    height: Sizes.screenHeight * 0.058,
                    width: Sizes.screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: AppColor.royalBlue,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: TextConst(title: "Yes", color: AppColor.white,fontFamily:AppFonts.kanitReg,fontWeight: FontWeight.w400,),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
