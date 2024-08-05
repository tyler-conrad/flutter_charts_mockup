import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/canvas/primitives.dart' as p;
import 'package:flutter_charts_mockup/widgets/currency_chart.dart' as cc;

/// Legend item type displayed for the [cc.CurrencyChart].
enum LegendItemType {
  bitcoin,
  ethereum,
}

/// Paints a dot in red or yellow to the left of the legend label.
class LegendDotPainter extends m.CustomPainter {
  const LegendDotPainter({
    super.repaint,
    required m.Color color,
  }) : _color = color;

  static const _dotRadius = 4.0;

  final m.Color _color;

  @override
  void paint(
    m.Canvas canvas,
    m.Size size,
  ) {
    final halfSize = size * 0.5;

    p.Circle(
      center: m.Offset(
        halfSize.width,
        halfSize.height,
      ),
      radius: s.r(_dotRadius),
      color: _color,
    ).paint(
      canvas,
      size,
    );
  }

  @override
  bool shouldRepaint(covariant m.CustomPainter oldDelegate) => false;
}

/// Draws a colored circle matching the color of a curve in the [cc.CurrencyChart]
/// and a label for the currency type.
class LegendItem extends m.StatelessWidget {
  LegendItem({
    super.key,
    required LegendItemType type,
  }) : _type = type;
  final double _spacerSize = s.r(12.0);
  final LegendItemType _type;

  @override
  m.Widget build(m.BuildContext context) {
    final colors = m.Theme.of(context).colorScheme;
    return m.Center(
      child: m.Row(
        mainAxisAlignment: m.MainAxisAlignment.center,
        children: [
          m.CustomPaint(
            painter: LegendDotPainter(
              color: _type == LegendItemType.bitcoin
                  ? colors.secondary
                  : colors.tertiary,
            ),
          ),
          m.SizedBox(
            width: s.r(_spacerSize),
          ),
          m.Text(
            _type == LegendItemType.bitcoin ? 'Bitcoin' : 'Ethereum',
            style: m.TextStyle(
              fontFamily: 'Roboto',
              fontSize: s.r(12.0),
              fontWeight: m.FontWeight.w100,
              fontStyle: m.FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
