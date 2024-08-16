import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/src/shared.dart' as s;
import 'package:flutter_charts_mockup/src/canvas/text.dart' as t;
import 'package:flutter_charts_mockup/src/widgets/filled_line_chart.dart'
    as flc;
import 'package:flutter_charts_mockup/src/widgets/alternating_bar_chart.dart'
    as abc;

/// A single chart y value level designator implemented as a label and a
/// dashed line.
///
/// Used by [flc.FilledLineChart] and [abc.AlternatingBarChart].
class DashedLineLevel {
  DashedLineLevel({
    required m.Offset pos,
    required int index,
    required double leftPadding,
    required m.BuildContext context,
  })  : _pos = pos,
        _index = index,
        _leftPadding = leftPadding,
        _context = context;

  static const double _dashWidth = 12.0;
  static const double _strokeWidth = 2.0;
  static const double _fontSize = 14.0;
  static const double _lineOpacity = 0.2;

  final m.Offset _pos;
  final int _index;
  final double _leftPadding;
  final m.BuildContext _context;

  void paintDashedLine(
    m.Canvas canvas,
    m.Size size,
    m.Offset pos,
    m.BuildContext context,
  ) {
    while (pos.dx < size.width) {
      canvas.drawLine(
          m.Offset(
            pos.dx,
            pos.dy,
          ),
          m.Offset(
            pos.dx + _dashWidth,
            pos.dy,
          ),
          m.Paint()
            ..strokeWidth = s.r(_strokeWidth)
            ..color = m.Theme.of(context)
                .colorScheme
                .onSurfaceVariant
                .withOpacity(_lineOpacity));
      pos = m.Offset(
        pos.dx + _dashWidth * 2.0,
        pos.dy,
      );
    }
  }

  void paint(
    m.Canvas canvas,
    m.Size size,
  ) {
    t.paintText(
      canvas: canvas,
      center: _pos,
      text: '${_index * 2}${_index == 0 ? '' : 'k'}',
      fontSize: s.r(_fontSize),
      color: m.Theme.of(_context).colorScheme.onSurfaceVariant,
    );

    paintDashedLine(
      canvas,
      size,
      _pos +
          m.Offset(
            _leftPadding,
            0.0,
          ),
      _context,
    );
  }
}
