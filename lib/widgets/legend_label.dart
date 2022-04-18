import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/canvas/primitives.dart' as p;
import 'package:flutter_charts_mockup/widgets/weekly_progress.dart' as wp;

/// Paints a colored pill for the [wp.WeeklyProgress] widget.
class LegendPillPainter extends m.CustomPainter {
  LegendPillPainter({required m.Color color}) : _color = color;

  static const double _pillSizeFactor = 3.0;

  final m.Color _color;

  @override
  void paint(m.Canvas canvas, m.Size size) {
    p.Pill(
      orientation: m.Orientation.landscape,
      center: size.center(m.Offset(size.width / _pillSizeFactor, 0.0)),
      crossAxisSize: size.height / _pillSizeFactor,
      mainAxisSize: size.width / _pillSizeFactor,
      color: _color,
    ).paint(
      canvas,
      size,
    );
  }

  @override
  bool shouldRepaint(covariant m.CustomPainter oldDelegate) => false;
}

/// Paints a colored pill and a label.
class LegendLabel extends m.StatelessWidget {
  const LegendLabel({
    m.Key? key,
    required m.Color pillColor,
  })  : _pillColor = pillColor,
        super(key: key);
  static const double _fontSize = 14.0;

  final m.Color _pillColor;

  @override
  m.Widget build(m.BuildContext context) {
    final colors = m.Theme.of(context).colorScheme;
    return m.Row(
      crossAxisAlignment: m.CrossAxisAlignment.stretch,
      children: [
        m.Expanded(
          flex: 2,
          child: m.CustomPaint(
            painter: LegendPillPainter(color: _pillColor),
          ),
        ),
        m.Expanded(
          flex: 5,
          child: m.Center(
            child: m.Text(
              'to start working',
              textAlign: m.TextAlign.left,
              style: m.TextStyle(
                fontSize: s.r(_fontSize),
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
