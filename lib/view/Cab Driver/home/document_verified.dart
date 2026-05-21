import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/l10n/app_localizations.dart';
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
import 'package:rainbow_partner/view/Cab%20Driver/home/driver_home_page.dart';
import 'package:rainbow_partner/view_model/cabdriver/driver_profile_view_model.dart';

class DocumentVerified extends StatefulWidget {
  const DocumentVerified({super.key});

  @override
  State<DocumentVerified> createState() => _DocumentVerifiedState();
}

class _DocumentVerifiedState extends State<DocumentVerified> {

  // ================= API HIT =================
  Future<void> hitProfileApi() async {

    if (!mounted) return;

    final vm = Provider.of<DriverProfileViewModel>(context, listen: false);

    final position = await LocationUtils.getLocation();

    if (!mounted) return;  // 🔥 VERY IMPORTANT

    await vm.driverProfileApi(
      position.latitude.toString(),
      position.longitude.toString(),
      context,
    );
  }


  bool _navigated = false;
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
    final loc = AppLocalizations.of(context)!;

    return statusLayout(
      icon: Icons.access_time_rounded,
      iconColor: Colors.orange,
      title: loc.verification_in_progress,
      subTitle: loc.verification_in_progress_description,
      customTop: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hourglass_bottom, size: 18, color: Colors.orange),
            SizedBox(width: 6),
            Text(
              loc.pending_verification,
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget verifiedWidget() {
    final loc = AppLocalizations.of(context)!;
    return statusLayout(
      icon: Icons.check_circle,
      iconColor: Colors.green,
      title: loc.documents_verified,
      subTitle: loc.documents_verified_description,
      showButton: true,
      onButtonTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context)=>DriverHomePage()));
      },
    );
  }

  Widget rejectedWidget(DriverProfileViewModel vm) {
    final loc = AppLocalizations.of(context)!;
    return statusLayout(
      icon: Icons.cancel,
      iconColor: Colors.red,
      title: loc.verification_rejected,
      subTitle: loc.verification_rejected_description,
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
    Widget? customTop,
  }) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          if (customTop != null) customTop,

          if (customTop != null) const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.12),
            ),
            child: Icon(icon, size: 36, color: iconColor),
          ),

          const SizedBox(height: 20),

          TextConst(
            title: title,
            size: 24,
            fontWeight: FontWeight.w700,
            color: iconColor,
          ),

          const SizedBox(height: 10),

          TextConst(
            title: subTitle,
            size: 16,
            color: Colors.grey.shade700,
            fontFamily: AppFonts.poppinsReg,
          ),

          const Spacer(),

          if (showButton) ...[
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
                  isRejected ? loc.fix_documents : loc.go_to_setup,
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
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColor.white,
          appBar: ConstantAppbar(
            onBack: () => Navigator.pop(context),
            onClose: () => SystemNavigator.pop(),
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
                      if (status == "verified") {
                        if (!_navigated && mounted) {
                          _navigated = true;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(builder: (_) => const DriverHomePage()),
                            );
                          });
                        }
                        return const SizedBox.shrink();
                      }
                      if (status == "rejected") return rejectedWidget(vm);
                      return pendingWidget();
                    }(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
