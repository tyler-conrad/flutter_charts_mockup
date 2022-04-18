import 'dart:ui' as ui;

import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/canvas/curve.dart' as c;
import 'package:flutter_charts_mockup/widgets/filled_line_chart.dart' as flc;
import 'package:flutter_charts_mockup/widgets/currency_chart.dart' as cc;

/// A circular highlight used on [flc.FilledLineChart] and [cc.CurrencyChart]
/// at the curves y value based on the x value of a pointer drag.
class CurveValueHighlight {
  const CurveValueHighlight({
    required double x,
    required m.Path path,
    required m.Color color,
    required m.BuildContext context,
  })  : _x = x,
        _path = path,
        _color = color,
        _context = context;
  static const double _strokeWidth = 2.0;
  static const double _blurRadius = 4.0;

  final double _x;
  final m.Path _path;
  final m.Color _color;
  final m.BuildContext _context;

  void paint(
    m.Canvas canvas,
    m.Size size,
  ) {
    final pos = c.onPath(_x, _path);
    final double radius = s.r(4.0);

    canvas.drawCircle(
      pos,
      radius,
      m.Paint()..color = m.Theme.of(_context).colorScheme.onSurface,
    );

    final strokeWidth = s.r(_strokeWidth);

    canvas.drawCircle(
      pos,
      radius,
      m.Paint()
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = _color,
    );

    canvas.drawCircle(
      pos,
      radius,
      m.Paint()
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = _color
        ..maskFilter = m.MaskFilter.blur(
          m.BlurStyle.normal,
          s.r(_blurRadius),
        ),
    );
  }
}
