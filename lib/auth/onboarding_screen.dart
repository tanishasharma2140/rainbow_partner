import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/choose_vehicle.dart';
import 'package:rainbow_partner/view/Service%20Man/register/register_service_screen.dart';
import 'package:rainbow_partner/view/Service%20Provider/register/register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final mobileNumber = args["mobileNumber"];
    print("User Mobile Number: $mobileNumber");
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,color: AppColor.black,)),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.screenWidth * 0.06,
            // vertical: Sizes.screenHeight * 0.07,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              TextConst(
                title: "Choose your profile",
                color: AppColor.black,
                size: 24,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 10),

              Text(
                "*Please Note : One mobile number one Profile",
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 30),

              Container(height: 1, color: Colors.white30),

              const SizedBox(height: 32),

              _profileTile(
                image: "assets/cab_driver.png",
                title: "rainboW Driver",
                subtitle:
                "Drive customers safely with real-time navigation and trip updates.",
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> ChooseVehicle(
                    profileId: 1,
                  )));
                },
              ),
              _bigDivider(),

              _profileTile(
                image: "assets/service_provider.png",
                title: "Service Man",
                subtitle:
                "Provide on-demand home services at customer's location.",
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context)=> RegisterScreen(mobileNumber: mobileNumber, profileId: 2,),
                    ),
                  );             },
              ),

              _bigDivider(),

              _profileTile(
                image: "assets/service_man.png",
                title: "Need a Job",
                subtitle:
                "Offer professional repair, installation and maintenance services.",
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>RegisterServiceScreen(
                    profileId: 3,
                  )));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bigDivider() {
    return Column(
      children: [
        SizedBox(height: 32),
        Container(height: 1, color: Colors.black26),
        SizedBox(height: 32),
      ],
    );
  }

  Widget _profileTile({
    required String image,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 18,
                  spreadRadius: 2,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54
              ),
              child: ClipOval(
                child: Image.asset(
                  image,
                  height: 105,
                  width: 105,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextConst(
                  title: title,
                  color: AppColor.black,
                  size: 21,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8),
                TextConst(
                  title: subtitle,
                  color: Colors.black38,
                  size: 14,
                  fontFamily: AppFonts.poppinsReg,
                ),
              ],
            ),
          ),

          /// Arrow
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColor.black,
            size: 20,
          ),
        ],
      ),
    );
  }

}
