import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/canvas/text.dart' as t;
import 'package:flutter_charts_mockup/widgets/filled_line_chart.dart' as flc;
import 'package:flutter_charts_mockup/widgets/currency_chart.dart' as cc;

/// Draws a tooltip with a label of a currency amount.
///
/// Used by the [flc.FilledLineChart] and the [cc.CurrencyChart].  Implemented
/// as a rounded rectangle [m.Path] unioned with a triangle.
class ToolTip {
  const ToolTip({
    required m.Offset center,
    required m.Color color,
    required m.BuildContext context,
  })  : _center = center,
        _color = color,
        _context = context;

  static const double _width = 48.0;
  static const double _height = 24.0;
  static const double _cornerRadius = 4.0;

  final m.Offset _center;
  final m.Color _color;
  final m.BuildContext _context;

  void drawRect(m.Canvas canvas, double width, double height) {
    canvas.drawPath(
      m.Path.combine(
        m.PathOperation.union,
        m.Path()
          ..addRRect(
            m.RRect.fromRectAndRadius(
              m.Rect.fromCenter(center: _center, width: width, height: height),
              m.Radius.circular(
                s.r(
                  _cornerRadius,
                ),
              ),
            ),
          )
          ..close(),
        m.Path()
          ..moveTo(_center.dx - width * 0.125, _center.dy + height * 0.5)
          ..lineTo(_center.dx, _center.dy + height * 0.75)
          ..lineTo(_center.dx + width * 0.125, _center.dy + height * 0.5)
          ..close(),
      ),
      m.Paint()..color = _color,
    );
  }

  void text(m.Canvas canvas, m.Size size, double height) {
    t.paintText(
      canvas: canvas,
      center: _center,
      text: s.priceFromHeight(
        size,
        _center,
      ),
      fontSize: s.r(12.0),
      color: m.Theme.of(_context).colorScheme.onSurface,
    );
  }

  void paint(
    m.Canvas canvas,
    m.Size size,
  ) {
    final width = s.r(_width);
    final height = s.r(_height);

    drawRect(
      canvas,
      width,
      height,
    );

    text(
      canvas,
      size,
      height,
    );
  }
}
