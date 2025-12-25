// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rainbow_partner/res/app_color.dart';
// import 'package:rainbow_partner/res/app_fonts.dart';
// import 'package:rainbow_partner/res/constant_appbar.dart';
// import 'package:rainbow_partner/res/custom_button.dart';
// import 'package:rainbow_partner/res/sizing_const.dart';
// import 'package:rainbow_partner/res/text_const.dart';
// import 'package:rainbow_partner/utils/location_utils.dart';
// import 'package:rainbow_partner/view/Cab%20Driver/home/document_verification_steps.dart';
// import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';
//
// class DocumentVerified extends StatefulWidget {
//   const DocumentVerified({super.key});
//
//   @override
//   State<DocumentVerified> createState() => _DocumentVerifiedState();
// }
//
// class _DocumentVerifiedState extends State<DocumentVerified> {
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final driverProfileVm = Provider.of<DriverProfileViewModel>(context, listen: false);
//       final position = await LocationUtils.getLocation(
//       );
//
//       final lat = position.latitude.toString();
//       final lng = position.longitude.toString();
//       driverProfileVm.driverProfileApi(lat, lng, context);
//
//       });
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       bottom: true,
//       child: Scaffold(
//         backgroundColor: AppColor.white,
//         appBar: ConstantAppbar(
//           onBack: () => Navigator.pop(context),
//           onClose: () => Navigator.pop(context),
//         ),
//
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 22),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//
//                TextConst(
//                  title:
//                 "Set up access to ride\nrequests",
//                  size: 25,
//                  fontWeight: FontWeight.w700,
//               ),
//
//               const SizedBox(height: 35),
//
//               // -------------------------
//               // TIMELINE
//               // -------------------------
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ICONS + LINES
//                   Column(
//                     children: [
//                       // Green Tick
//                       CircleAvatar(
//                         radius: 15,
//                         backgroundColor: Colors.green,
//                         child: const Icon(Icons.check, color: Colors.white),
//                       ),
//
//                       // Green Line
//                       Container(
//                         height: 70,
//                         width: 3,
//                         color: Colors.green,
//                       ),
//
//                       // Black Icon
//                       CircleAvatar(
//                         radius: 15,
//                         backgroundColor: Colors.black,
//                         child: const Icon(Icons.credit_card,
//                             color: Colors.white, size: 20),
//                       ),
//
//                       Container(
//                         height: 70,
//                         width: 3,
//                         color: Colors.grey.shade300,
//                       ),
//
//                       // Grey Icon
//                       CircleAvatar(
//                         radius: 15,
//                         backgroundColor: Colors.grey.shade200,
//                         child: const Icon(Icons.directions_car,
//                             color: Colors.grey, size: 22),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(width: 18),
//
//                   // TEXT BLOCK
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // STEP 1
//                          TextConst(
//                            title:
//                           "Documents submitted",
//                              size: 18, fontWeight: FontWeight.w600
//                         ),
//                         const SizedBox(height: 4),
//                         TextConst(
//                           title:
//                           "We have all the info we need to verify you",
//                           size: 15,
//                           fontFamily: AppFonts.poppinsReg,
//                           color: Colors.grey.shade700,
//                         ),
//
//                         const SizedBox(height: 30),
//
//                          TextConst(
//                            title:
//                           "Set up access to ride requests",
//                              size: 18, fontWeight: FontWeight.w600
//                         ),
//                         const SizedBox(height: 4),
//                         TextConst(
//                           title:
//                           "You'll be ready to accept ride requests right after verification",
//                           size: 15,
//                           fontFamily: AppFonts.poppinsReg,
//                           color: Colors.grey.shade700,
//                         ),
//                         const SizedBox(height: 30),
//                          TextConst(
//                            title:
//                           "Wait for verification result",
//                              size: 18, fontWeight: FontWeight.w600),
//                         const SizedBox(height: 4),
//                         TextConst(
//                           title:
//                           "We'll notify you within 24 hours",
//                           size: 15,
//                           fontFamily: AppFonts.poppinsReg,
//                           color: Colors.grey.shade700,
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//
//               const SizedBox(height: 35),
//               const Spacer(),
//
//               // -------------------------
//               // BOTTOM BUTTON
//               // -------------------------
//               CustomButton(
//                   bgColor: AppColor.royalBlue,
//                   title: "Go to setup", onTap: (){
//                     Navigator.push(context, CupertinoPageRoute(builder: (context)=>DocumentVerificationSteps()));
//               }),
//               SizedBox(height: Sizes.screenHeight*0.025,)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/view/Cab Driver/home/document_verification_steps.dart';
import 'package:rainbow_partner/view/Cab Driver/register/aadhaar_info.dart';
import 'package:rainbow_partner/view/Cab Driver/register/driving_license.dart';
import 'package:rainbow_partner/view/Cab Driver/register/personal_information.dart';
import 'package:rainbow_partner/view/Cab Driver/register/required_certificate.dart';
import 'package:rainbow_partner/view/Cab Driver/register/vehicle_document.dart';
import 'package:rainbow_partner/view/Cab Driver/register/vehicle_information.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';

class DocumentVerified extends StatefulWidget {
  const DocumentVerified({super.key});

  @override
  State<DocumentVerified> createState() => _DocumentVerifiedState();
}

class _DocumentVerifiedState extends State<DocumentVerified> {

  // ================= API HIT =================
  Future<void> hitProfileApi() async {
    final vm = Provider.of<DriverProfileViewModel>(context, listen: false);
    final position = await LocationUtils.getLocation();

    await vm.driverProfileApi(
      position.latitude.toString(),
      position.longitude.toString(),
      context,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hitProfileApi();
    });
  }

  // ================= OVERALL STATUS =================
  String getOverallStatus(DriverProfileViewModel vm) {
    final d = vm.driverProfileModel?.data;
    if (d == null) return "pending";

    final statuses = [
      d.personalInformationStatus,
      d.driverLicenceStatus,
      d.aadhaarPanStatus,
      d.requiredCertificatesStatus,
      d.vehicleInfoStatus,
      d.vehicleDocumentsStatus,
    ];

    if (statuses.any((e) => e == 3)) return "rejected";
    if (statuses.every((e) => e == 2)) return "verified";
    return "pending";
  }

  // ================= REJECTED PAGE SELECTOR (PRIORITY) =================
  Widget getRejectedTargetPage(DriverProfileViewModel vm) {
    final d = vm.driverProfileModel!.data!;

    if (d.personalInformationStatus == 3) {
      return const PersonalInformation(
        vehicleId: "",
        vehicleName: "",
        mobileNumber: "",
        profileId: 2,
      );
    }
    if (d.driverLicenceStatus == 3) {
      return const DrivingLicense();
    }
    if (d.aadhaarPanStatus == 3) {
      return const AadhaarInfo();
    }
    if (d.requiredCertificatesStatus == 3) {
      return const RequiredCertificates();
    }
    if (d.vehicleInfoStatus == 3) {
      return const VehicleInformation();
    }
    if (d.vehicleDocumentsStatus == 3) {
      return const VehicleDocument();
    }

    // fallback (should never hit)
    return const DocumentVerificationSteps();
  }

  // ================= UI STATES =================
  Widget pendingWidget() {
    return statusLayout(
      icon: Icons.hourglass_top,
      iconColor: Colors.orange,
      title: "Verification Pending",
      subTitle: "Your documents are under review.\nWe’ll notify you soon.",
    );
  }

  Widget verifiedWidget() {
    return statusLayout(
      icon: Icons.check_circle,
      iconColor: Colors.green,
      title: "Documents Verified",
      subTitle: "You are ready to accept ride requests",
      showButton: true,
      onButtonTap: () {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (_) => const DocumentVerificationSteps(),
          ),
        );
      },
    );
  }

  Widget rejectedWidget(DriverProfileViewModel vm) {
    return statusLayout(
      icon: Icons.cancel,
      iconColor: Colors.red,
      title: "Verification Rejected",
      subTitle: "Some documents were rejected. Please fix them to continue.",
      showButton: true,
      isRejected: true,
      onButtonTap: () {
        final page = getRejectedTargetPage(vm);

        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => page),
        );
      },
    );
  }

  // ================= COMMON STATUS LAYOUT =================
  Widget statusLayout({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subTitle,
    bool showButton = false,
    bool isRejected = false,
    VoidCallback? onButtonTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          Icon(icon, size: 70, color: iconColor),
          const SizedBox(height: 20),

          TextConst(
            title: title,
            size: 26,
            fontWeight: FontWeight.w700,
            color: iconColor,
          ),

          const SizedBox(height: 10),

          TextConst(
            title: subTitle,
            size: 16,
            color: isRejected ? Colors.red.shade700 : Colors.grey.shade700,
            fontFamily: AppFonts.poppinsReg,
          ),

          const Spacer(),

          if (showButton)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: onButtonTap,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColor.royalBlue, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isRejected ? "Fix Documents" : "Go to setup",
                  style: TextStyle(
                    color: AppColor.royalBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          SizedBox(height: Sizes.screenHeight * 0.04),
        ],
      ),
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: ConstantAppbar(
          onBack: () => Navigator.pop(context),
          onClose: () => Navigator.pop(context),
        ),
        body: RefreshIndicator(
          color: AppColor.royalBlue,
          onRefresh: hitProfileApi,
          child: Consumer<DriverProfileViewModel>(
            builder: (context, vm, _) {
              final status = getOverallStatus(vm);

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top,
                  child: () {
                    if (status == "verified") return verifiedWidget();
                    if (status == "rejected") return rejectedWidget(vm);
                    return pendingWidget();
                  }(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


