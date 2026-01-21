import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_profile_view_model.dart';
import 'package:rainbow_partner/utils/location_utils.dart';

class EditServicemanProfile extends StatefulWidget {
  const EditServicemanProfile({super.key});

  @override
  State<EditServicemanProfile> createState() => _EditServicemanProfileState();
}

class _EditServicemanProfileState extends State<EditServicemanProfile> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = Provider.of<ServicemanProfileViewModel>(context, listen: false);

      final position = await LocationUtils.getLocation();
      final lat = position.latitude.toString();
      final lng = position.longitude.toString();

      vm.servicemanProfileApi(lat, lng, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,color: AppColor.white,)),
          title:  TextConst(
            title:
            "Profile",
            size: 20,
            color: AppColor.white,
          ),
          centerTitle: true,
        ),

        body: Consumer<ServicemanProfileViewModel>(
          builder: (context, vm, child) {
            final d = vm.servicemanProfileModel?.data;

            if (vm.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (d == null) {
              return const Center(child: Text("No Profile Found"));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ---------------- PROFILE PHOTO ---------------
                  Center(
                    child: Container(
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: d.profilePhoto != null
                            ? DecorationImage(
                          image: NetworkImage(d.profilePhoto),
                          fit: BoxFit.cover,
                        )
                            : const DecorationImage(
                          image: AssetImage("assets/prooo.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ------------- BASIC DETAILS ------------------
                  profileTitle("Basic Details"),
                  profileRow("Name", "${d.firstName} ${d.lastName}"),
                  profileRow("Mobile", d.mobile),
                  profileRow("Address", d.address),
                  profileRow("Service Name", d.serviceName),

                  const SizedBox(height: 20),

                  // ------------ DOCUMENTS ------------------
                  profileTitle("Documents"),
                  profileDoc("Aadhaar Front", d.aadhaarFront),
                  profileDoc("Aadhaar Back", d.aadhaarBack),
                  profileDoc("Experience Certificate", d.experienceCertificate),

                  const SizedBox(height: 20),

                  // ------------ OTHER INFO ------------------
                  profileTitle("Other Info"),
                  profileRow("Wallet", "₹${d.wallet}"),
                  profileRow("Due Wallet", "₹${d.dueWallet}"),
                  profileRow("Created At", d.createdAt),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget profileTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          fontFamily: AppFonts.kanitReg
        ),
      ),
    );
  }

  Widget profileRow(String k, dynamic v) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$k:", style: const TextStyle(fontWeight: FontWeight.w600)),
          Flexible(
            child: Text(
              "$v",
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget profileDoc(String k, dynamic url) {
    return GestureDetector(
      onTap: () {
        if (url != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FullImageView(url)),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: const TextStyle(fontWeight: FontWeight.w600,fontFamily: AppFonts.kanitReg)),
            Icon(url != null ? Icons.visibility : Icons.remove_red_eye_outlined),
          ],
        ),
      ),
    );
  }
}

/// ---------- IMAGE VIEW -------
class FullImageView extends StatelessWidget {
  final String url;
  const FullImageView(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Document")),
      body: Center(child: Image.network(url)),
    );
  }
}
