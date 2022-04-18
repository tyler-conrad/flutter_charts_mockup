import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/widgets/week_period_bar_chart.dart'
    as wpbc;
import 'package:flutter_charts_mockup/canvas/text.dart' as t;

/// Circle primitive that can be painted.
class Circle {
  Circle({
    required m.Offset center,
    required double radius,
    required m.Color color,
  })  : _center = center,
        _radius = radius,
        _color = color;

  final m.Offset _center;
  final double _radius;
  final m.Color _color;

  void paint(
    m.Canvas canvas,
    m.Size size,
  ) {
    canvas.drawCircle(
      _center,
      _radius,
      m.Paint()..color = _color,
    );
  }
}

/// Two [Circle] instances with an Canvas.drawArc() call in order to emulate a pill
/// shape that follows a circular arc.
class ArcedPill {
  ArcedPill({
    required m.Offset center,
    required double radius,
    required double crossAxisSize,
    required double startAngle,
    required double sweepAngle,
    required m.Color color,
  })  : _center = center,
        _radius = radius,
        _crossAxisSize = crossAxisSize,
        _startAngle = startAngle,
        _sweepAngle = sweepAngle,
        _color = color;

  final m.Offset _center;
  final double _radius;
  final double _crossAxisSize;
  final double _startAngle;
  final double _sweepAngle;
  final m.Color _color;

  void paint(
    m.Canvas canvas,
    m.Size size,
  ) {
    final capRadius = _crossAxisSize * 0.5;

    canvas.drawCircle(
      _center + m.Offset.fromDirection(_startAngle, _radius - capRadius),
      capRadius,
      m.Paint()..color = _color,
    );

    canvas.drawCircle(
      _center +
          m.Offset.fromDirection(
              _startAngle + _sweepAngle, _radius - capRadius),
      capRadius,
      m.Paint()..color = _color,
    );

    canvas.drawArc(
      m.Rect.fromCenter(
          center: _center, width: _radius * 2.0, height: _radius * 2.0),
      _startAngle,
      _sweepAngle,
      true,
      m.Paint()..color = _color,
    );
  }
}

/// A rounded rectangle that implements a pill shape.
///
/// The [orientation] determines whether the Pill is drawn horizontally or
/// vertically.  The [mainAxisSize] is the length of the pill, the
/// [crossAxisSize] is the width;
class Pill {
  Pill({
    m.Orientation orientation = m.Orientation.landscape,
    required m.Offset center,
    required double crossAxisSize,
    required double mainAxisSize,
    required m.Color color,
  })  : _centerPos = center,
        _orientation = orientation,
        _crossAxisSize = crossAxisSize,
        _mainAxisSize = mainAxisSize,
        _color = color;

  final m.Orientation _orientation;
  final m.Offset _centerPos;
  final double _crossAxisSize;
  final double _mainAxisSize;
  final m.Color _color;

  m.RRect rect() {
    final cornerRadius = m.Radius.circular(_crossAxisSize * 0.5);
    return _orientation == m.Orientation.landscape
        ? m.RRect.fromRectAndRadius(
            m.Rect.fromCenter(
              center: _centerPos,
              width: _mainAxisSize,
              height: _crossAxisSize,
            ),
            cornerRadius)
        : m.RRect.fromRectAndRadius(
            m.Rect.fromCenter(
              center: _centerPos,
              width: _crossAxisSize,
              height: _mainAxisSize,
            ),
            cornerRadius,
          );
  }

  void paint(
    m.Canvas canvas,
    m.Size size,
  ) {
    canvas.drawRRect(
      rect(),
      m.Paint()..color = _color,
    );
  }
}

/// Draws two vertical [Pill]s with a background [Pill] along with labels for
/// the day of the week and the day of the month.
class DayBar {
  DayBar({
    required double width,
    required int index,
    required double bottomHeightScale,
    required double topHeightScale,
    required m.BuildContext context,
  })  : _width = width,
        _index = index,
        _bottomHeightScale = bottomHeightScale,
        _topHeightScale = topHeightScale,
        _context = context;

  static const double _fontSize = 10.0;
  static const double _centerPadding = 4.0;
  static const double _heightFactor = 1.5;
  static const double _dayOfMonthYFactor = 2.2;
  static const double _backgroundHeightFactor = 3.6;
  static const int _dayOffset = 17;

  final double _width;
  final int _index;
  final double _bottomHeightScale;
  final double _topHeightScale;
  final m.BuildContext _context;

  String dayOfWeekFromIndex(int index) {
    switch (index) {
      case 0:
        return 'MON';
      case 1:
        return 'TUE';
      case 2:
        return 'WED';
      case 3:
        return 'THU';
      case 4:
        return 'FRI';
      case 5:
        return 'SAT';
      case 6:
        return 'SUN';
      default:
        throw Exception('Unreachable');
    }
  }

  void paint(
    m.Canvas canvas,
    m.Size size,
    double heightFactor,
  ) {
    final fontSize = s.r(_fontSize);

    final centerPadding = s.r(_centerPadding);

    final horizontalWidth = size.width / wpbc.WeekPeriodBarChart.numDaysInWeek;
    final horizontalCenter = horizontalWidth * _index + horizontalWidth * 0.5;
    final colors = m.Theme.of(_context).colorScheme;

    final dayOfWeekTextHeight = t.paintText(
      canvas: canvas,
      center: m.Offset(
        horizontalCenter,
        size.height - fontSize * _heightFactor * 0.5,
      ),
      text: dayOfWeekFromIndex(_index),
      fontSize: fontSize,
      color: colors.onSurfaceVariant,
    );

    t.paintText(
      canvas: canvas,
      center: m.Offset(
        horizontalCenter,
        size.height - (dayOfWeekTextHeight * _dayOfMonthYFactor),
      ),
      text: '${_index + _dayOffset}',
      fontSize: fontSize,
      color: colors.onSurfaceVariant,
    );

    final backgroundHeight =
        (size.height - dayOfWeekTextHeight * _backgroundHeightFactor);
    Pill(
      center: m.Offset(
        horizontalCenter,
        backgroundHeight * 0.5,
      ),
      crossAxisSize: _width,
      mainAxisSize: backgroundHeight,
      color: colors.surfaceVariant,
      orientation: m.Orientation.portrait,
    ).paint(
      canvas,
      size,
    );

    final bottomHeight =
        0.5 * heightFactor * _bottomHeightScale * backgroundHeight -
            centerPadding;
    Pill(
      center: m.Offset(horizontalCenter, backgroundHeight - 0.5 * bottomHeight),
      crossAxisSize: _width,
      mainAxisSize: bottomHeight,
      color: colors.primary,
      orientation: m.Orientation.portrait,
    ).paint(
      canvas,
      size,
    );

    final topHeight = 0.5 * heightFactor * _topHeightScale * backgroundHeight;
    Pill(
      center: m.Offset(
          horizontalCenter,
          (backgroundHeight - (bottomHeight + centerPadding)) -
              0.5 * topHeight),
      crossAxisSize: _width,
      mainAxisSize: topHeight,
      color: colors.secondary,
      orientation: m.Orientation.portrait,
    ).paint(
      canvas,
      size,
    );
  }
}
