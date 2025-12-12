import 'dart:math';
import 'package:flutter/material.dart';

class GradientCirPro extends StatefulWidget {
  final double strokeWidth;
  final double size;
  final Gradient gradient;

  const GradientCirPro({
    super.key,
    this.strokeWidth = 6.0,
    this.size = 60.0,
    required this.gradient,
  });

  @override
  _GradientCirProState createState() => _GradientCirProState();
}

class _GradientCirProState extends State<GradientCirPro>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // 🔥 Faster Rotation
    )..repeat(); // Infinite rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * pi, // Full Rotation
            child: CustomPaint(
              painter: _GradientCircularProgressPainter(widget.strokeWidth, widget.gradient),
            ),
          );
        },
      ),
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double strokeWidth;
  final Gradient gradient;

  _GradientCircularProgressPainter(this.strokeWidth, this.gradient);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * 0.75; // 75% progress
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}