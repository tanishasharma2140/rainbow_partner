import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/auth/splash.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/pdf_view_screen.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
import 'package:rainbow_partner/view_model/service_man/driver_online_status_view_model.dart';
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

  void _openFile(String fileUrl) {
    if (fileUrl.toLowerCase().endsWith(".pdf")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfViewScreen(url: fileUrl),
        ),
      );
    } else {
      _openFullImage(fileUrl);
    }
  }


  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: TextConst(
          title: loc.driver_profile,
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
              child: const Icon(Icons.logout)),
          const SizedBox(width: 13,)
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
                      TextConst(
                        title: loc.driver_photo,
                        size: 13,
                        color: Colors.grey,
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ---------------- PERSONAL DETAILS ----------------
                sectionTitle(loc.personal_details),
                infoTile(
                  loc.name,
                  [
                    data.firstName,
                    data.lastName,
                  ].where((e) => e != null && e.toString().isNotEmpty).join(" "),
                ),
                infoTile(loc.mobile_number, data.mobile?.toString() ?? "--"),
                infoTile(loc.date_of_birth, data.dateOfBirth?.toString() ?? "--"),

                const SizedBox(height: 30),

                // ---------------- DRIVING LICENSE ----------------
                sectionTitle(loc.driving_license),
                Row(
                  children: [
                    Expanded(
                        child: viewImageBox(
                            loc.front_side, data.driverLicenceFront)),
                    const SizedBox(width: 14),
                    Expanded(
                        child: viewImageBox(
                            loc.back_side, data.driverLicenceBack)),
                  ],
                ),
                const SizedBox(height: 12),
                infoTile(loc.license_number,
                    data.driverLicenceNumber?.toString() ?? "--"),

                const SizedBox(height: 30),

                // ---------------- AADHAAR ----------------
                sectionTitle(loc.aadhaar_card),
                Row(
                  children: [
                    Expanded(
                        child: viewImageBox(
                            loc.front_side, data.aadhaarFront)),
                    const SizedBox(width: 14),
                    Expanded(
                        child:
                        viewImageBox(loc.back_side, data.aadhaarBack)),
                  ],
                ),
                const SizedBox(height: 12,),
                infoTile(
                    loc.aadhaar_number, data.aadhaarNumber?.toString() ?? "--"),

                const SizedBox(height: 30),

                // ---------------- PAN ----------------
                sectionTitle(loc.pan_card),
                Row(
                  children: [
                    Expanded(
                        child:
                        viewImageBox(loc.front_side, data.panCardFront)),
                    const SizedBox(width: 14),

                  ],
                ),
                const SizedBox(height: 12,),
                infoTile(loc.pan_number,
                    data.panCardNumber?.toString() ?? "--"),

                const SizedBox(height: 20),

                // ---------------- VEHICLE DETAILS ----------------
                sectionTitle(loc.vehicle_details),
                infoTile(loc.brand, data.brandName?.toString() ?? "--"),
                infoTile(loc.model, data.modelName?.toString() ?? "--"),
                infoTile(loc.color, data.vehicleColor?.toString() ?? "--"),
                infoTile(loc.plate_number,
                    data.vehiclePlateNumber?.toString() ?? "--"),
                infoTile(loc.production_year,
                    data.vehicleProductionYear?.toString() ?? "--"),

                const SizedBox(height: 20),
                viewImageBox(loc.vehicle_photo, data.vehiclePhoto),

                const SizedBox(height: 30),

                // ---------------- VEHICLE DOCUMENTS ----------------
                if (data.vehicleCategory != 2) ...[
                  sectionTitle(loc.vehicle_documents),
                  Row(
                    children: [
                      Expanded(
                          child: viewImageBox(
                              loc.rc_front, data.vehicleRegistrationFront)),
                      const SizedBox(width: 14),
                      Expanded(
                          child: viewImageBox(
                              loc.rc_back, data.vehicleRegistrationBack)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                          child: viewImageBox(
                              loc.permit_part_a, data.vehiclePermitPartA)),
                      const SizedBox(width: 14),
                      Expanded(
                          child: viewImageBox(
                              loc.permit_part_b, data.vehiclePermitPartB)),
                    ],
                  ),
                ],

                const SizedBox(height: 30),

                // ---------------- CERTIFICATES ----------------
                sectionTitle(loc.certificates),

                if (data.fitnessCertificate != null && data.fitnessCertificate.toString().isNotEmpty) ...[
                  viewImageBox(loc.rc_certificate, data.fitnessCertificate),
                  const SizedBox(height: 12),
                ],

                viewImageBox(loc.insurance_certificate, data.insuranceCertificate),
                const SizedBox(height: 12),

                viewImageBox(loc.pollution_certificate, data.pollutionCertificate),
                const SizedBox(height: 12),

                if (data.policeCertificate != null && data.policeCertificate.toString().isNotEmpty) ...[
                  viewImageBox(loc.police_verification, data.policeCertificate),
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
    final loc = AppLocalizations.of(context)!;
    final bool isPdf =
        imageUrl != null &&
            imageUrl.isNotEmpty &&
            imageUrl.toLowerCase().endsWith(".pdf");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: imageUrl != null && imageUrl.isNotEmpty
              ? () => _openFile(imageUrl)
              : null,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              image: !isPdf &&
                  imageUrl != null &&
                  imageUrl.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
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
              child: Icon(
                Icons.image_not_supported,
                size: 35,
                color: Colors.grey,
              ),
            )
                : isPdf
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.picture_as_pdf,
                    size: 45,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 6),
                  Text(loc.view_pdf)
                ],
              ),
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
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: EdgeInsets.all(Sizes.screenHeight * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextConst(
                title: loc.are_you_sure_logout,
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
                          title: loc.no, color: AppColor.royalBlue),
                    ),
                  ),
                ),
                SizedBox(
                  width: Sizes.screenWidth * 0.02,
                ),
                InkWell(
                  onTap: () async {
                    await _handleLogout(context);
                  },
                  child: Container(
                    height: Sizes.screenHeight * 0.058,
                    width: Sizes.screenWidth * 0.4,
                    decoration: BoxDecoration(
                      color: AppColor.royalBlue,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                      child: TextConst(title: loc.yes, color: AppColor.white,fontFamily:AppFonts.kanitReg,fontWeight: FontWeight.w400,),
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

Future<void> _handleLogout(BuildContext context) async {
  final driverOnlineVm =
  Provider.of<DriverOnlineStatusViewModel>(context, listen: false);

  final driverProfileVm =
  Provider.of<DriverProfileViewModel>(context, listen: false);


  final position = await LocationUtils.getLocation();


  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  Placemark place = placemarks.first;

  String currentLocation =
      "${place.name ?? ''}, "
      "${place.street ?? ''}, "
      "${place.subLocality ?? ''}, "
      "${place.locality ?? ''}, "
      "${place.administrativeArea ?? ''}, "
      "${place.postalCode ?? ''}, "
      "${place.country ?? ''}";

  try {
    // 🔥 1️⃣ Make driver offline via API
    await driverOnlineVm.driverOnlineStatusApi(
      0, // offline
      position.latitude,
      position.longitude,
      currentLocation,
      context,
    );

    // 🔁 2️⃣ Refresh profile (optional but good)
    await driverProfileVm.driverProfileApi("0", "0", context);

  } catch (e) {
    debugPrint("Offline API error: $e");
  }

  // 🔌 3️⃣ Disconnect socket immediately
  // DriverSocketService().disconnect();

  // 📴 4️⃣ Stop background service
  // await stopBackgroundService();

  // 🧹 5️⃣ Clear user data
  await UserViewModel().remove();

  // 🚪 6️⃣ Navigate to Splash
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const Splash()),
        (_) => false,
  );
}
