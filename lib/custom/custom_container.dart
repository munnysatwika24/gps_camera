import 'dart:math';

import 'package:flutter/material.dart';
import 'clip_painter.dart';

class BezierContainerBottom extends StatelessWidget {
  const BezierContainerBottom({Key ?key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi/0.7,
      child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height *.5,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topRight,
                  colors: [Colors.teal,Colors.greenAccent]
              )
          ),
        ),
      ),
    );
  }
}