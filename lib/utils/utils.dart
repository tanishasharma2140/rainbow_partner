import 'dart:async';
import 'package:flutter/material.dart';

enum MessagePosition { top, bottom }

class Utils {
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  static void showSuccessMessage(BuildContext context, String message,
      {MessagePosition position = MessagePosition.top}) {
    _showOverlayMessage(
      context,
      message,
      Colors.green,
      Icons.check_circle_outline,
      position,
    );
  }

  static void showErrorMessage(BuildContext context, String message,
      {MessagePosition position = MessagePosition.top}) {
    _showOverlayMessage(
      context,
      message,
      Colors.redAccent,
      Icons.error_outline,
      position,
    );
  }

  static void _showOverlayMessage(
      BuildContext context,
      String message,
      Color backgroundColor,
      IconData icon,
      MessagePosition position) {

    // ---- FIX #1: SAFE REMOVE ----
    if (_isShowing && _overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position == MessagePosition.top ? 60 : null,
        bottom: position == MessagePosition.bottom ? 60 : null,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: backgroundColor,
              border: Border.all(color: backgroundColor.withOpacity(0.9), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // ---- FIX #2: SAFE REMOVE ----
                    if (_overlayEntry != null && _overlayEntry!.mounted) {
                      _overlayEntry!.remove();
                    }
                    _isShowing = false;
                  },
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                )
              ],
            ),
          ),
        ),
      ),
    );

    // ---- FIX #3: Check overlay is available ----
    final overlay = Overlay.of(context);

    overlay.insert(_overlayEntry!);
    _isShowing = true;

    // ---- FIX #4: SAFE TIMER REMOVE ----
    Timer(const Duration(seconds: 2), () {
      if (_overlayEntry != null && _overlayEntry!.mounted) {
        _overlayEntry!.remove();
      }
      _isShowing = false;
    });
  }
}
