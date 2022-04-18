import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/canvas/dashed_line_level.dart' as dll;

/// Number of graph interval lines to draw.
const int _numDashedLineLevels = 5;

/// Space added to left of canvas for interval line labels.
const double _chartLeftPaddingFactor = 4.0;

/// Padding added to bottom of canvas to offset the vertical beginning of the
/// interval lines.
const double _bottomPadding = 48.0;

/// Paints the background interval lines and labels for line charts.
double paintBackgroundLines(
    m.Size size, double leftPadding, m.Canvas canvas, m.BuildContext context) {
  final spacing = size.height / _numDashedLineLevels;

  final chartLeftPadding = leftPadding * _chartLeftPaddingFactor;
  for (int index = 0; index < _numDashedLineLevels; index++) {
    dll.DashedLineLevel(
      pos: m.Offset(
        leftPadding,
        (size.height - spacing * index) - s.r(_bottomPadding),
      ),
      index: index,
      leftPadding: chartLeftPadding,
      context: context,
    ).paint(
      canvas,
      size,
    );
  }
  return chartLeftPadding;
}
