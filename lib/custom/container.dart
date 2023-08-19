import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gps_camera/custom/clip_painter.dart';


class BezierContainer extends StatelessWidget {
  const BezierContainer({Key ?key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 2.4,
      child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height *.5,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [Colors.purpleAccent,Colors.deepOrange]
              )
          ),
        ),
      ),
    );
  }
}