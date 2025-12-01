import 'dart:math';
import 'package:flutter/material.dart';

class CarLoaderScreen extends StatefulWidget {
  const CarLoaderScreen({super.key});

  @override
  State<CarLoaderScreen> createState() => _CarLoaderScreenState();
}

class _CarLoaderScreenState extends State<CarLoaderScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  double radius = 120;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
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

          /// Close text
          Positioned(
            right: 20,
            top: 50,
            child: Text(
              "Close",
              style: TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          /// Top green line
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Container(
              height: 5,
              color: Colors.greenAccent,
            ),
          ),

          /// CENTER ANIMATION
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                final angle = _controller.value * 2 * pi;

                /// Car position on circle
                final carOffset = Offset(
                  radius * cos(angle),
                  radius * sin(angle),
                );

                return Stack(
                  alignment: Alignment.center,
                  children: [

                    /// Rotating arc
                    Transform.rotate(
                      angle: angle,
                      child: CustomPaint(
                        size: const Size(260, 260),
                        painter: LoaderArcPainter(),
                      ),
                    ),

                    /// Rotating car
                    Transform.translate(
                      offset: carOffset,
                      child: Transform.rotate(
                        angle: angle + pi / 2,
                        child: Image.network(
                          "https://cdn-icons-png.flaticon.com/512/743/743131.png",
                          height: 70,
                          width: 70,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// SINGLE ARC — same like InDrive
class LoaderArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -pi * 0.3;
    const sweepAngle = pi * 1.6;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.8,
      height: size.height * 0.8,
    );

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
