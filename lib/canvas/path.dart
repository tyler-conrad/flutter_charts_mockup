import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/canvas/curve.dart' as c;

/// Builds an [m.Path] used for graphs containing curves.
m.Path buildLinePath(
  m.Size size,
  double chartLeftPadding,
  double halfHeight,
  List<double> verticalFactors,
  double ease, [
  double verticalOffset = 0.0,
]) {
  final topPoints = c.curvedPathPoints(
    size,
    chartLeftPadding,
    halfHeight,
    verticalFactors,
    ease,
    verticalOffset,
  );

  final path = m.Path()
    ..moveTo(
      topPoints.first.first.dx,
      topPoints.first.first.dy,
    );

  for (final pair in topPoints.skip(1)) {
    path.quadraticBezierTo(
      pair.first.dx,
      pair.first.dy,
      pair.last.dx,
      pair.last.dy,
    );
  }

  path.lineTo(
    size.width,
    halfHeight + halfHeight * verticalFactors.last * ease + verticalOffset,
  );

  path.lineTo(
    size.width,
    halfHeight + halfHeight * verticalFactors.last * ease,
  );

  final bottomPoints = c
      .curvedPathPoints(
        size,
        chartLeftPadding,
        halfHeight,
        verticalFactors,
        ease,
        0.0,
      )
      .toList()
      .reversed;

  path.lineTo(
    bottomPoints.first.last.dx,
    bottomPoints.first.last.dy,
  );

  for (int i = 0; i < bottomPoints.length - 1; i++) {
    path.quadraticBezierTo(
      bottomPoints.skip(i).first.first.dx,
      bottomPoints.skip(i).first.first.dy,
      bottomPoints.skip(i + 1).first.last.dx,
      bottomPoints.skip(i + 1).first.last.dy,
    );
  }

  path.lineTo(
    chartLeftPadding,
    halfHeight + halfHeight * verticalFactors.first * ease,
  );

  return path..close();
}
