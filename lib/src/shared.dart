import 'dart:async' as async;
import 'dart:math' as math;

import 'package:flutter/material.dart' as m;
import 'package:responsive_sizer/responsive_sizer.dart';

import 'widgets/vertical_factors.dart' as vf;
import 'canvas/tooltip.dart' as tt;

/// Used to determine the height of a [m.SizedBox] that is a child of a
/// [m.SingleChildScrollView].
const aspectWidth = 37;

/// Used to determine the height of a [m.SizedBox] that is a child of a
/// [m.SingleChildScrollView].
const aspectHeight = 163;

const oneSecond = Duration(seconds: 1);

/// The number of random points generated for charts with curves.
const int numVerticalFactors = 8;

/// The default width of ArcedPills
final double arcWidth = r(6.0);

/// A magic number that is required by the use of a left offset on charts with curves used to calculate the
/// height of a curve base on the x value of a pointer drag.
const double minCurveX = 0.28;

const double _min = 0.25;
const double _factor = 1.0 - _min;
final math.Random rng = math.Random();

/// Used to generate the values of the [vf.VerticalFactors] used to draw curves.
double rand() {
  return _min + _factor * rng.nextDouble();
}

/// A magic number for the screen size scaling.
const double _scaleFactor = 0.2;

/// Scales an input double based on the minimum of the scaled width and height
/// as determined by the responsive_sizer library.
double r(double size) {
  final widthFactor = _scaleFactor.w;
  final heightFactor = _scaleFactor.h;
  return widthFactor > heightFactor ? heightFactor * size : widthFactor * size;
}

/// Function that returns a dollar amount based on the position of a [tt.ToolTip].
String priceFromHeight(
  m.Size size,
  m.Offset center,
) =>
    '\$ ${(18800 * ((size.height - center.dy) / size.height) - 10000).toInt()}';

/// Blocks a callback from being executed for a give duration even when it is
/// called multiple times within that duration.  Used to prevent interaction
/// updates from always causing immediate calculations.
void Function() throttle(
  void Function() callback,
  int millis,
) {
  async.Timer? lastTimer;

  return () {
    if (!(lastTimer?.isActive ?? false)) {
      lastTimer?.cancel();
      lastTimer = async.Timer(
        Duration(milliseconds: millis),
        callback,
      );
    }
  };
}
