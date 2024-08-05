import 'dart:math' as math;

import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/canvas/path.dart' as p;
import 'package:flutter_charts_mockup/canvas/tooltip.dart' as tt;
import 'package:flutter_charts_mockup/canvas/curve_value_highlight.dart' as cvh;
import 'package:flutter_charts_mockup/canvas/curve.dart' as c;
import 'package:flutter_charts_mockup/widgets/vertical_factors.dart' as vf;
import 'package:flutter_charts_mockup/widgets/filled_line_chart.dart' as flc;
import 'package:flutter_charts_mockup/widgets/currency_chart.dart' as cc;

/// Base [m.CustomPainter] used by the [flc.FilledLineChart] and the [cc.CurrencyChart].
class LineChartPainterBase<T extends vf.VerticalFactors>
    extends m.CustomPainter {
  LineChartPainterBase({
    super.repaint,
    required this.verticalFactors,
    required this.ease,
    required m.Offset? dragPos,
    required this.context,
  }) : _dragPos = dragPos;

  static const double _lineWidth = 4.0;
  static const double _lineSigma = 4.0;
  static const double _toolTipHeightFactor = -128.0;
  static const double leftPadding = 8.0;
  static const double clipPathOuterSize = 64.0;
  static const double opacity = 0.6;

  final T verticalFactors;
  final double ease;
  final m.Offset? _dragPos;
  final m.BuildContext context;

  void paintToolTip(
    m.Canvas canvas,
    m.Size size,
    double chartLeftPadding,
    double halfHeight,
    List<double> verticalFactors,
    double chartWidth,
    m.Color color,
  ) {
    final path = m.Path();
    for (final Iterable<m.Offset> pair in c.curvedPathPoints(
      size,
      chartLeftPadding,
      halfHeight,
      verticalFactors,
      ease,
      0.0,
    )) {
      path.quadraticBezierTo(
        pair.first.dx,
        pair.first.dy,
        pair.last.dx,
        pair.last.dy,
      );
    }

    final left = chartWidth / (s.numVerticalFactors - 2) / chartWidth;

    double x = math.max(
      (1.0 - left) * ((_dragPos?.dx ?? 0.0) / chartWidth + left),
      s.minCurveX,
    );

    cvh.CurveValueHighlight(
      x: x,
      path: path,
      color: color,
      context: context,
    ).paint(
      canvas,
      size,
    );

    final offset = c.onPath(x, path);
    final toolTipHeightFactor = s.r(_toolTipHeightFactor);
    tt.ToolTip(
      center: m.Offset(
            0.0,
            toolTipHeightFactor * (offset.dy / size.height),
          ) +
          offset,
      color: color,
      context: context,
    ).paint(
      canvas,
      size,
    );
  }

  void paintLine(
    m.Canvas canvas,
    m.Path Function(m.Path) clipPath,
    m.Size size,
    double chartLeftPadding,
    double halfHeight,
    m.Color color,
    double chartWidth,
    List<double> verticalFactors,
  ) {
    canvas.drawPath(
      clipPath(
        p.buildLinePath(
          size,
          chartLeftPadding,
          halfHeight,
          verticalFactors,
          ease,
          _lineWidth,
        ),
      ),
      m.Paint()..color = color,
    );

    canvas.drawPath(
      clipPath(
        p.buildLinePath(
          size,
          chartLeftPadding,
          halfHeight,
          verticalFactors,
          ease,
          _lineWidth,
        ),
      ),
      m.Paint()
        ..color = color
        ..maskFilter = const m.MaskFilter.blur(
          m.BlurStyle.normal,
          _lineSigma,
        ),
    );
  }

  @override
  void paint(m.Canvas canvas, m.Size size) {}

  @override
  bool shouldRepaint(covariant m.CustomPainter oldDelegate) =>
      _dragPos != null || (ease > 0.001 && ease < 0.999);
}
