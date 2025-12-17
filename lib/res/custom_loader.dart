import 'package:flutter/cupertino.dart';
import 'app_color.dart';

class CustomLoader extends StatefulWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const CustomLoader({
    super.key,
    this.color = AppColor.white,
    this.size = 26,
    this.strokeWidth = 4,
  });

  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: CustomPaint(
        painter: LoaderPainter(
          color: widget.color,
          strokeWidth: widget.strokeWidth,
        ),
        size: Size(widget.size, widget.size),
      ),
    );
  }
}

class LoaderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  LoaderPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 3.14,
        colors: [
          color,
          color.withOpacity(0.5),
          color.withOpacity(0.2),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: radius,
      ),
      0,
      3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant LoaderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
