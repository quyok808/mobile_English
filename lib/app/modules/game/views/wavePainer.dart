import 'package:flutter/material.dart';

class WaterWavePainter extends CustomPainter {
  final double waveHeight;

  WaterWavePainter(this.waveHeight);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    // Vẽ sóng
    Path path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
      size.width * 0.25, size.height - waveHeight * 50,
      size.width * 0.5, size.height - waveHeight * 100,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height - waveHeight * 150,
      size.width, size.height - waveHeight * 200,
    );
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
