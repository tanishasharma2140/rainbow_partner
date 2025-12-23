import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:rainbow_partner/main.dart';
import 'package:rainbow_partner/res/app_color.dart';
import 'package:rainbow_partner/res/app_fonts.dart';
import 'package:rainbow_partner/res/sizing_const.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/utils/routes/routes_name.dart';
import 'package:rainbow_partner/utils/utils.dart';
import 'package:rainbow_partner/view_model/auth_view_model.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber, });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  Timer? _timer;
  int _secondsLeft = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Map arguments =
    //   ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //   Provider.of<AuthViewModel>(
    //     context,
    //     listen: false,
    //   ).sendOtpApi(arguments["mobileNumber"], context);
    // });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = 60;
      _canResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  void _onResend() {
    if (!_canResend) return;

    _startTimer();

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("OTP resent")),
    // );
  }

  void _verifyOtp(String pin) {

    // Safely get AuthViewModel from Provider
    final authVm = context.read<AuthViewModel>();

    final enteredOtp = pin.trim();

    if (enteredOtp.length == 4 && int.tryParse(enteredOtp) != null) {
      authVm.verifySentApi(
        widget.phoneNumber,  // ✔ safe
        enteredOtp,
        context,
      );
      print("widget.phoneNumber");
      print(widget.phoneNumber);
      print(enteredOtp);
      print("enteredOtp");
    } else {
      Utils.showErrorMessage(context, "Please enter a valid 4-digit OTP.");
    }
  }


  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  String _formatTimer(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        shape: BoxShape.circle,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.royalBlue),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: const BoxDecoration(
        color: AppColor.white,
        shape: BoxShape.circle,
      ),
      textStyle: const TextStyle(
        fontSize: 34,
        color: AppColor.black,
        fontFamily: AppFonts.poppinsReg,
        fontWeight: FontWeight.w800,
      ),
    );

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: Sizes.screenWidth*0.05,vertical: Sizes.screenHeight*0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: topPadding),

              GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, size: 26, color: Colors.black)),

              const SizedBox(height: 8),

              TextConst(
                textAlign: TextAlign.center,
                title: "Enter the code",
                size: 25,
                fontWeight: FontWeight.w700,
              ),

              const SizedBox(height: 8),

              TextConst(
                title: "We sent your code via SMS to\n${widget.phoneNumber}",
                size: 16,
                color: AppColor.blackLightI,
                fontFamily: AppFonts.poppinsReg,
              ),

              SizedBox(height: Sizes.screenHeight*0.07),

              Pinput(
                length: 4,
                controller: _pinController,
                focusNode: _pinFocusNode,
                keyboardType: TextInputType.number,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: false,
                onCompleted: (pin) {
                  _verifyOtp(pin);

                },
              ),


              const Spacer(),
              GestureDetector(
                onTap: _canResend ? _onResend : null,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: TextConst(
                    title:
                    _canResend
                        ? "Resend code"
                        : "Resend code ${_formatTimer(_secondsLeft)}",
                    fontWeight: FontWeight.w600,
                    size: 16,
                    color: _canResend ? Colors.black : Colors.grey,
                  ),
                ),
              ),

              SizedBox(height: Sizes.screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
