import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:rainbow_partner/res/text_const.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/document_verified.dart';

class PopperScreen extends StatefulWidget {
  const PopperScreen({super.key});

  @override
  State<PopperScreen> createState() => _PopperScreenState();
}

class _PopperScreenState extends State<PopperScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _controller;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    /// ⭐ Confetti Controller
    _controller = ConfettiController(duration: const Duration(seconds: 2));
    _controller.play();

    /// ⭐ Icon Scale + Text Fade Animation
    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();

    /// ⭐ Move to Next Page
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (_) => DocumentVerified()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          /// ⭐ CENTER CONTENT WITH ANIMATION
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// ⭐ ZOOM-IN ANIMATION FOR ICON
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Image.asset(
                      "assets/congratulation.png",
                      width: 170,
                      height: 170,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const TextConst(
                    title: "Congratulations!",
                    size: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),

                  const SizedBox(height: 10),

                  const TextConst(
                    title:
                    "Your documents have been successfully\nsubmitted for verification.",
                    size: 15,
                    color: Colors.black54,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const TextConst(
                    title: "We’re reviewing them shortly.",
                    size: 14,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ),

          /// ⭐ CONFETTI
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirection: 3.14 / 2,      // downward fall
              emissionFrequency: 0.015,       // smoother / less
              numberOfParticles: 10,          // light & premium
              maxBlastForce: 10,
              minBlastForce: 4,
              gravity: 0.25,                  // gentle fall
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.yellow,
                Colors.green,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
