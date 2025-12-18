import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/custom_button.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/location_utils.dart';
import 'package:rainbow_partner/view_model/service_man/serviceman_profile_view_model.dart';

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

      vm.servicemanProfileApi(lat, lng,context).then((_) {
        final d = vm.servicemanProfileModel?.data;

        setState(() {
          firstName.text = d?.firstName ?? "";
          lastName.text = d?.lastName ?? "";
          email.text = d?.email ?? "";
          username.text = d?.serviceName ?? "";
          designation.text = d?.serviceCategory.toString() ?? "";
          imagePath = d?.profilePhoto; // API image URL
        });
      });
    });
  }


  // TEXT CONTROLLERS
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController designation = TextEditingController();

  String? imagePath;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

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
              const TextConst(
                title: "Edit Profile",
                color: Colors.white,
                size: 20,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------------- PROFILE PHOTO ----------------
              Center(
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                        image: imagePath != null
                            ? DecorationImage(
                            image: NetworkImage(imagePath!),
                            fit: BoxFit.cover)
                            : const DecorationImage(
                          image: AssetImage("assets/prooo.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImagePicker,
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: const BoxDecoration(
                            color: AppColor.royalBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ---------------- TEXT FIELDS ----------------
              fieldTitle("First Name"),
              profileField(firstName),

              fieldTitle("Last Name"),
              profileField(lastName),

              fieldTitle("Email"),
              profileField(email),

              fieldTitle("Service Name"),
              profileField(username),

              fieldTitle("Designation"),
              profileField(designation),

              const SizedBox(height: 30),

              // ---------------- SAVE BUTTON ----------------
               CustomButton(
                   bgColor: AppColor.royalBlue,
                   title: "Save Changes", onTap: (){}),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // FIELD TITLE
  // ------------------------------------------------------------
  Widget fieldTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 8),
      child: TextConst(
        title: title,
        size: 15,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  // ------------------------------------------------------------
  // BEAUTIFUL INPUT FIELD
  // ------------------------------------------------------------
  Widget profileField(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // IMAGE PICKER POPUP (GALLERY OR CAMERA)
  // ------------------------------------------------------------
  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextConst(
                title: "Choose Option",
                size: 17,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 10),

              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColor.royalBlue),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColor.royalBlue),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
