import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/no_data_found.dart';
import 'package:rainbow_partner/view_model/policy_view_model.dart';

class ServiceTermsAndCondition extends StatefulWidget {
  const ServiceTermsAndCondition({super.key});

  @override
  State<ServiceTermsAndCondition> createState() => _ServiceTermsAndConditionState();
}

class _ServiceTermsAndConditionState extends State<ServiceTermsAndCondition> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PolicyViewModel>(context, listen: false)
          .policyApi("2");
    });
  }

  @override
  Widget build(BuildContext context) {
    final privacyVm = Provider.of<PolicyViewModel>(context);

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.royalBlue,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Terms and Condition",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        // ---------- BODY ----------
        body: _buildBody(privacyVm),
      ),
    );
  }

  Widget _buildBody(PolicyViewModel vm) {
    // 1️⃣ Show loader while loading
    if (vm.loading) {
      return Center(child: CircularProgressIndicator(color: AppColor.black,));
    }

    if (vm.policyModel == null ||
        vm.policyModel!.data == null ||
        vm.policyModel!.data!.description == null ||
        vm.policyModel!.data!.description!.trim().isEmpty)
    {
      return  NoDataFound();
    }

    // 3️⃣ DATA AVAILABLE → Show HTML
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: HtmlWidget(
        vm.policyModel!.data!.description!,
        textStyle: TextStyle(
          fontFamily: AppFonts.kanitReg,
          fontSize: 14,
          // color: AppColor.bl,
          height: 1.5,
        ),
      ),
    );
  }
}
