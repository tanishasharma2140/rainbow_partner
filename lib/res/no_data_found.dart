import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/text_const.dart';

class NoDataFound extends StatelessWidget {
  final String message;
  final double gifSize;

  const NoDataFound({
    super.key,
    this.message = "No Data Found",
    this.gifSize = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // GIF
          SizedBox(
            height: gifSize,
            width: gifSize,
            child: Image.asset(
              "assets/nodatafound.gif",
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),

          // Text Label
          TextConst(
            title:
            message,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
            size: 16,
          ),
        ],
      ),
    );
  }
}
