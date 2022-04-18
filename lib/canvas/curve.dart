import 'dart:ui' as ui;

import 'package:flutter/material.dart' as m;

/// Generates the point and control point pairs that are used by
/// Path.quadraticBezierTo() to generate curved paths for line charts.
///
/// Adapted from https://stackoverflow.com/a/7058606
Iterable<Iterable<m.Offset>> curvedPathPoints(
  m.Size size,
  double chartLeftPadding,
  double halfHeight,
  List<double> verticalFactors,
  double ease,
  verticalOffset,
) sync* {
  double step = (size.width - chartLeftPadding) / (verticalFactors.length - 2);
  int i = 0;
  for (; i < verticalFactors.length - 2; i++) {
    yield [
      m.Offset(
        chartLeftPadding + i * step - step,
        halfHeight + halfHeight * verticalFactors[i] * ease + verticalOffset,
      ),
      m.Offset(
        (chartLeftPadding + i * step + chartLeftPadding + (i + 1) * step) *
                0.5 -
            step,
        (halfHeight +
                halfHeight * verticalFactors[i] * ease +
                verticalOffset +
                halfHeight +
                halfHeight * verticalFactors[i + 1] * ease +
                verticalOffset) *
            0.5,
      ),
    ];
  }

  yield [
    m.Offset(
      chartLeftPadding + i * step - step,
      halfHeight + halfHeight * verticalFactors[i] * ease + verticalOffset,
    ),
    m.Offset(
      chartLeftPadding + (i + 1) * step - step,
      (halfHeight +
              halfHeight * verticalFactors[i] * ease +
              verticalOffset +
              halfHeight +
              halfHeight * verticalFactors[i + 1] * ease +
              verticalOffset) *
          0.5,
    ),
  ];
}

/// Returns an Offset that represents the point on a Path given a normalized x
/// value.
m.Offset onPath(double x, m.Path path) {
  ui.PathMetric pathMetric = path.computeMetrics().first;
  return pathMetric.getTangentForOffset(pathMetric.length * x)!.position;
}
