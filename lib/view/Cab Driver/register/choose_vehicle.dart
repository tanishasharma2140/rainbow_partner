import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/personal_information.dart';

class ChooseVehicle extends StatefulWidget {
  const ChooseVehicle({super.key});

  @override
  State<ChooseVehicle> createState() => _ChooseVehicleState();
}

class _ChooseVehicleState extends State<ChooseVehicle> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: ConstantAppbar(
          onBack: () => Navigator.pop(context),
          onClose: () => Navigator.pop(context),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 8),
               Icon(Icons.arrow_back,color: AppColor.black,),
               SizedBox(height: Sizes.screenHeight*0.02),
               TextConst(
                 title:
                "Choose your vehicle",
                 color: Colors.black,
                 size: 25,
                 fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 30),

              /// Vehicle Item 1
              _vehicleTile(
                image: "assets/car.png",
                title: "Car",
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>PersonalInformation()));
                },
              ),

              const SizedBox(height: 22),

              /// Vehicle Item 2
              _vehicleTile(
                image: "assets/motor_cycle.png",
                title: "Motorcycle",
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>PersonalInformation()));

                },
              ),

              const SizedBox(height: 22),

              /// Vehicle Item 3
              _vehicleTile(
                image: "assets/auto_rikshaw.png",
                title: "Rickshaw",
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context)=>PersonalInformation()));

                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// VEHICLE TILE UI (same as screenshot)
  Widget _vehicleTile({
    required String image,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [

          /// Icon container
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                image,
                height: 40,
                width: 40,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: TextConst(title:
              title,
              size: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: AppFonts.poppinsReg,
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
