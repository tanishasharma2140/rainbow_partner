import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:rainbow_partner/view/Cab%20Driver/home/document_verified.dart';

class PopperScreen extends StatefulWidget {
  const PopperScreen({super.key});

  @override
  State<PopperScreen> createState() => _PopperScreenState();
}

class _PopperScreenState extends State<PopperScreen> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    _controller.play();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          Center(
            child: Image.asset(
              "assets/congratulation.png",
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
          ),

          /// 🎉 Confetti from Top
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirection: -3.14 / 2, // top → downward
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              maxBlastForce: 30,
              minBlastForce: 10,
              gravity: 0.3,
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


