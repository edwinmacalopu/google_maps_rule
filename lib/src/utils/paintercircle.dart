import 'package:flutter/material.dart';

class PainterCircle extends CustomPainter {
   
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint=Paint();
   final rect=Rect.fromLTWH(0,0,size.width,size.height);
   final RRect rRect=RRect.fromRectAndRadius(rect, Radius.circular(50));  
  paint.color=Colors.black;
   canvas.drawRRect(rRect, paint);
  final rect2=Rect.fromLTWH(6,6,size.width/1.7,size.height/1.7);
   final RRect rRect2=RRect.fromRectAndRadius(rect2, Radius.circular(50));  
  paint.color=Colors.white;
   canvas.drawRRect(rRect2, paint);
  }
  @override
  bool shouldRepaint(PainterCircle oldDelegate) => false;
   
  @override
  bool shouldRebuildSemantics(PainterCircle oldDelegate) => false;
}