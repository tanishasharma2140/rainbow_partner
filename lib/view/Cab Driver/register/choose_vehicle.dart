import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/constant_appbar.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab%20Driver/register/personal_information.dart';
import 'package:rainbow_partner/view_model/cabdriver/vehicle_view_model.dart';

class ChooseVehicle extends StatefulWidget {
  final int profileId;
  final String mobileNumber;
  const ChooseVehicle({super.key, required this.profileId, required this.mobileNumber});

  @override
  State<ChooseVehicle> createState() => _ChooseVehicleState();
}

class _ChooseVehicleState extends State<ChooseVehicle> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VehicleViewModel>(context, listen: false).vehicleApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vehicleVm = Provider.of<VehicleViewModel>(context);
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
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: AppColor.black),
              ),
              SizedBox(height: Sizes.screenHeight * 0.02),
              TextConst(
                title: "Choose your vehicle",
                color: Colors.black,
                size: 25,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 30),

              /// Vehicle Item 1
              if (vehicleVm.loading)
                const Center(child: CircularProgressIndicator())
              else if (vehicleVm.vehicleModel?.data == null ||
                  vehicleVm.vehicleModel!.data!.isEmpty)
                const Center(child: Text("No vehicles found"))
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vehicleVm.vehicleModel!.data!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 22),
                  itemBuilder: (context, index) {
                    final vehicle = vehicleVm.vehicleModel!.data![index];

                    return _vehicleTile(
                      image: vehicle.image ?? "",
                      title: vehicle.name ?? "",
                      onTap: () {
                        context.read<VehicleViewModel>().setSelectedVehicle(
                          vehicleId: vehicle.id!,
                          vehicleName: vehicle.name ?? "",
                        );

                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => PersonalInformation(
                              vehicleId: vehicle.id.toString(),
                              vehicleName: vehicle.name,
                              mobileNumber : widget.mobileNumber.toString(),
                              profileId : widget.profileId
                            ),
                          ),
                        );
                      },
                    );
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
              child: Image.network(
                image,
                height: 40,
                width: 40,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.directions_car),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: TextConst(
              title: title,
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
