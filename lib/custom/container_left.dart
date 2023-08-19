import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gps_camera/custom/clip_paint_left.dart';

class BezierContainerLeft extends StatelessWidget {
  const BezierContainerLeft({Key ?key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 2.1,
      child: ClipPath(
        clipper: ClipPainterLeft(),
        child: Container(
          height: MediaQuery.of(context).size.height *.5,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [Colors.purple,Colors.tealAccent]
              )
          ),
        ),
      ),
    );
  }
}