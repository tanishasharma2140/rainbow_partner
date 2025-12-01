import 'package:flutter/material.dart';
import 'package:rainbow_partner/res/text_const.dart';

class ConstantAppbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  final VoidCallback? onClose;
  final String closeText;

  const ConstantAppbar({
    super.key,
    required this.onBack,
    this.onClose,
    this.closeText = "Close",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.white,

        /// ⭐ Same shadow as your other CustomAppBar
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        children: [

          /// Back Arrow

          const Spacer(),

          /// Close text
          GestureDetector(
            onTap: onClose,
            child: Padding(
              padding: const EdgeInsets.only(right: 12,top: 30),
              child: TextConst(
                title:
                closeText,
                size: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
