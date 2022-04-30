import 'package:flutter/material.dart';



//this class creates custom boxes to be filled 

class Chevron extends CustomPainter {

  var screenWidth;
  var screenHeight;

  Chevron({ required this.screenWidth , required this.screenHeight});

  @override
  void paint(Canvas canvas, Size size) {

    final Paint paint = Paint()
      ..color = const Color.fromRGBO(123, 44, 191,1);

    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, screenHeight/2.5);
    path.lineTo(screenWidth , screenHeight/7);
    path.lineTo(screenWidth, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}