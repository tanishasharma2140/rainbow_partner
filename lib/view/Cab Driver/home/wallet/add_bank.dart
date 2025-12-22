import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:rainbow_partner/res/app_color.dart";
import "package:rainbow_partner/res/app_fonts.dart";
import "package:rainbow_partner/res/gradient_circle_pro.dart";
import "package:rainbow_partner/res/sizing_const.dart";
import "package:rainbow_partner/res/text_const.dart";
import "package:rainbow_partner/view/Cab%20Driver/home/wallet/cab_bank_detail_view.dart";
import "package:rainbow_partner/view_model/service_man/add_bank_detail_view_model.dart";

class AddBank extends StatefulWidget {
  const AddBank({super.key});

  @override
  State<AddBank> createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  final CollectionReference myItems = FirebaseFirestore.instance.collection(
    "data",
  );

  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _reAccountController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();

  bool _showBankDetails = false;
  String _bankName = "";
  String _branchName = "";

  // Simulate IFSC code validation
  void _validateIfscCode(String ifscCode) {
    if (ifscCode.length >= 4) {
      setState(() {
        _showBankDetails = true;
        // Mock bank data - replace with actual API
        if (ifscCode.toUpperCase().contains("HDFC")) {
          _bankName = "HDFC Bank";
          _branchName = "Mumbai Main Branch";
        } else if (ifscCode.toUpperCase().contains("ICIC")) {
          _bankName = "ICICI Bank";
          _branchName = "Delhi Central Branch";
        } else if (ifscCode.toUpperCase().contains("SBIN")) {
          _bankName = "State Bank of India";
          _branchName = "Chennai South Branch";
        } else {
          _bankName = "Bank Name";
          _branchName = "Branch Name";
        }
      });
    } else {
      setState(() {
        _showBankDetails = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cabAddBankVm = Provider.of<AddBankDetailViewModel>(context);
    return Stack(
      children: [
        SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            backgroundColor: AppColor.whiteDark,
            appBar: AppBar(
              backgroundColor: AppColor.royalBlue,
              elevation: 0,
              title: TextConst(
                title: "Add Bank Account",
                color: AppColor.white,
                size: 18,
                fontWeight: FontWeight.w600,
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColor.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.history, color: AppColor.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            CabBankDetailView(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                        transitionDuration: Duration(milliseconds: 300),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Sizes.screenHeight * 0.02),
                    // Main Form Container
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.royalBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColor.royalBlue,
                                  width: 1,
                                ),
                              ),
                              child: TextConst(
                                title: "Bank Account Information",
                                color: AppColor.royalBlue,
                                fontWeight: FontWeight.w600,
                                size: 14,
                              ),
                            ),
                          ),

                          SizedBox(height: Sizes.screenHeight * 0.03),

                          // Account Holder Name
                          _buildFormField(
                            title: "Bank Name",
                            hintText: "Enter bank name",
                            controller: _bankController,
                            icon: Icons.account_balance,
                          ),

                          SizedBox(height: Sizes.screenHeight * 0.03),

                          // Account Holder Name
                          _buildFormField(
                            title: "Account Holder Name",
                            hintText: "Enter full name as per bank records",
                            controller: _holderNameController,
                            icon: Icons.person_outline,
                          ),

                          SizedBox(height: Sizes.screenHeight * 0.025),

                          // Account Number
                          _buildFormField(
                            title: "Account Number",
                            hintText: "Enter 12-digit account number",
                            controller: _accountController,
                            icon: Icons.credit_card,
                            keyboardType: TextInputType.number,
                            maxLength: 12,
                          ),

                          SizedBox(height: Sizes.screenHeight * 0.025),

                          // Confirm Account Number
                          _buildFormField(
                            title: "Confirm Account Number",
                            hintText: "Re-enter account number",
                            controller: _reAccountController,
                            icon: Icons.credit_card_outlined,
                            keyboardType: TextInputType.number,
                            maxLength: 12,
                          ),

                          SizedBox(height: Sizes.screenHeight * 0.025),

                          // IFSC Code with Auto-detect
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet,
                                    color: AppColor.royalBlue,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "IFSC Code",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _ifscCodeController,
                                        onChanged: _validateIfscCode,
                                        decoration: InputDecoration(
                                          hintText: "Enter IFSC Code",
                                          hintStyle: TextStyle(
                                            fontFamily: AppFonts.kanitReg,
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 14,
                                          ),
                                          counterText: "",
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLength: 11,
                                        textCapitalization:
                                            TextCapitalization.characters,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Bank Details Card (Shows when IFSC is valid)
                          if (_showBankDetails) ...[
                            SizedBox(height: Sizes.screenHeight * 0.025),
                            _buildBankDetailsCard(),
                          ],

                          SizedBox(height: Sizes.screenHeight * 0.04),

                          // Submit Button
                          Container(
                            height: Sizes.screenHeight * 0.06,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor.royalBlue,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.royalBlue.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(15),
                                onTap: () {
                                  cabAddBankVm.addBankDetailApi(
                                    2,
                                    _bankController.text,
                                    _accountController.text,
                                    _reAccountController.text,
                                    _holderNameController.text,
                                    _ifscCodeController.text,
                                    context,
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Center(
                                      child:
                                          // !bankDetailViewModel.loading
                                          //     ?
                                          TextConst(
                                            title: "ADD BANK ACCOUNT",
                                            color: AppColor.white,
                                            size: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      //     :  const CupertinoActivityIndicator(
                                      //   color: Colors.white,
                                      //   radius: 14,
                                      // ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: Sizes.screenHeight * 0.02),

                          // Security Note
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.green.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.verified_user,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextConst(
                                    title:
                                        "Your bank details are secure and encrypted",
                                    color: Colors.green,
                                    size: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (cabAddBankVm.loading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Container(
                height: Sizes.screenHeight * 0.13,
                width: Sizes.screenWidth * 0.28,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: GradientCirPro(
                    strokeWidth: 6,
                    size: 70,
                    gradient: AppColor.circularIndicator,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFormField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColor.royalBlue, size: 18),
            SizedBox(width: 8),
            TextConst(
              title: title,
              size: 15,
              fontWeight: FontWeight.w600,
              color: AppColor.blackLight,
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: AppFonts.kanitReg,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              counterText: "",
            ),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildBankDetailsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.royalBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.royalBlue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.royalBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.business, color: AppColor.royalBlue, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _bankName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  _branchName,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  "IFSC: ${_ifscCodeController.text.toUpperCase()}",
                  style: TextStyle(
                    color: AppColor.royalBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.verified, color: Colors.green, size: 12),
                SizedBox(width: 4),
                Text(
                  "Verified",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColor.royalBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColor.royalBlue, size: 16),
            ),
            SizedBox(height: 6),
            TextConst(
              title: title,
              textAlign: TextAlign.center,
              size: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            SizedBox(height: 2),
            TextConst(
              title: subtitle,
              textAlign: TextAlign.center,
              size: 10,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
