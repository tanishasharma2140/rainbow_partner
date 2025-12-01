import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/car_loader_screen.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/choose_vehicle.dart';
import 'package:rainbow_partner/view/Service%20Provider/register/register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.royalBlue,
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,color: AppColor.white,)),
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
                color: Colors.white,
                size: 24,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 10),

              Text(
                "*Please Note : One mobile number one Profile",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 30),

              Container(height: 1, color: Colors.white30),

              const SizedBox(height: 32),

              _profileTile(
                image: "assets/service_provider.png",
                title: "Service Provider",
                subtitle:
                "Provide on-demand home services at customer's location.",
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>RegisterScreen()));
                },
              ),

              _bigDivider(),

              _profileTile(
                image: "assets/service_man.png",
                title: "Service Man",
                subtitle:
                "Offer professional repair, installation and maintenance services.",
                onTap: () {},
              ),

              _bigDivider(),

              _profileTile(
                image: "assets/cab_driver.png",
                title: "Cab Driver",
                subtitle:
                "Drive customers safely with real-time navigation and trip updates.",
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=> ChooseVehicle()));
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
        Container(height: 1, color: Colors.white24),
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
            padding: EdgeInsets.all(2), // border thickness
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // border color
            ),
            child: ClipOval(
              child: Image.asset(
                image,
                height: 105, // bigger image
                width: 105,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 18),

          /// Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextConst(
                  title: title,
                  color: Colors.white,
                  size: 21,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: 8),
                TextConst(
                  title: subtitle,
                  color: Colors.white70,
                  size: 14,
                  fontFamily: AppFonts.poppinsReg,
                ),
              ],
            ),
          ),

          /// Arrow
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
        ],
      ),
    );
  }
}
