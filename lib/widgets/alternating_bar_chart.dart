import 'dart:math' as math;

import 'package:flutter/material.dart' as m;
import 'package:visibility_detector/visibility_detector.dart' as vd;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/canvas/primitives.dart' as p;
import 'package:flutter_charts_mockup/canvas/curve.dart' as c;
import 'package:flutter_charts_mockup/canvas/background_lines.dart' as bl;
import 'package:flutter_charts_mockup/widgets/vertical_factors.dart' as vf;
import 'package:flutter_charts_mockup/widgets/line_chart_painter_base.dart'
    as lcpb;
import 'package:flutter_charts_mockup/widgets/line_chart_state.dart' as lcs;
import 'package:flutter_charts_mockup/widgets/statistics.dart' as stats;

/// Paints a bar chart with bars of alternating heights and
/// colors drawn along a curve.
class AlternatingBarChartPainter extends m.CustomPainter {
  AlternatingBarChartPainter({
    required double ease,
    required vf.AlternatingBarChartVerticalFactors factors,
    required m.BuildContext context,
  })  : _ease = ease,
        _factors = factors,
        _context = context;

  static const _barWidth = 12.0;
  static const double _leftPaddingFactor = 1.75;

  final double _ease;
  final vf.AlternatingBarChartVerticalFactors _factors;
  final m.BuildContext _context;

  @override
  void paint(m.Canvas canvas, m.Size size) {
    final chartLeftPadding = bl.paintBackgroundLines(
      size,
      s.r(lcpb.LineChartPainterBase.leftPadding),
      canvas,
      _context,
    );

    final path = m.Path();
    for (final Iterable<m.Offset> pair in c.curvedPathPoints(
      size,
      chartLeftPadding,
      size.height * 0.7,
      _factors.factors.first,
      _ease,
      0.0,
    )) {
      path.quadraticBezierTo(
        pair.first.dx,
        pair.first.dy,
        pair.last.dx,
        pair.last.dy,
      );
    }

    final chartWidth = size.width - chartLeftPadding;
    final left = chartWidth / (s.numVerticalFactors - 2) / chartWidth;
    final colors = m.Theme.of(_context).colorScheme;
    for (int i = 0; i < AlternatingBarChart._numAlternatingBars; i++) {
      final color = i % 2 == 0 ? colors.primary : colors.secondary;
      final x = left + (i / AlternatingBarChart._numAlternatingBars);
      final offset = c.onPath(
          math.max(
            x,
            s.minCurveX,
          ),
          path);

      p.Pill(
        center: m.Offset(
            chartLeftPadding * _leftPaddingFactor +
                chartWidth * (i / AlternatingBarChart._numAlternatingBars),
            (offset.dy - 0.5 * _factors.factors.last[i] * size.height) *
                    0.5 *
                    _ease +
                size.height * 0.25),
        crossAxisSize: s.r(_barWidth),
        mainAxisSize: _factors.factors.last[i] * size.height * _ease,
        color: color,
        orientation: m.Orientation.portrait,
      ).paint(
        canvas,
        size,
      );
    }
  }

  @override
  bool shouldRepaint(covariant m.CustomPainter oldDelegate) =>
      _ease > 0.001 && _ease < 0.990;
}

/// A chart with bars of alternating colors and heights.
class AlternatingBarChart extends m.StatefulWidget {
  const AlternatingBarChart({m.Key? key}) : super(key: key);

  static const _numAlternatingBars = 10;

  @override
  m.State<AlternatingBarChart> createState() => _AlternatingBarChartState();
}

class _AlternatingBarChartState extends m.State<AlternatingBarChart>
    with m.TickerProviderStateMixin {
  final _visibilityDetectorKey = m.UniqueKey();
  final _visible = m.ValueNotifier(false);

  late final lcs.LineChartState<_AlternatingBarChartState> _state;

  final vf.AlternatingBarChartVerticalFactors _verticalFactors =
      vf.AlternatingBarChartVerticalFactors(
    factors: lcs.LineChartState.generateVerticalFactors()
        .map((f) => f * 0.5)
        .toList(),
    barHeights: lcs.LineChartState.generateVerticalFactors(
            AlternatingBarChart._numAlternatingBars)
        .map((f) => f * 0.25 + 0.3)
        .toList(),
  );

  @override
  void initState() {
    super.initState();

    _state = lcs.LineChartState(
      owner: this,
      setState: setState,
    )..initState();

    _visible.addListener(() {
      if (_visible.value) {
        _state.onInView();
      } else {
        _state.onNotInView();
      }
    });
  }

  @override
  void dispose() {
    _visible.dispose();
    _state.dispose();
    super.dispose();
  }

  @override
  m.Widget build(m.BuildContext context) {
    return stats.Statistics(
      chart: vd.VisibilityDetector(
        key: _visibilityDetectorKey,
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction > 0.0) {
            _visible.value = true;
          } else {
            _visible.value = false;
          }
        },
        child: m.ClipRect(
          child: m.CustomPaint(
            painter: AlternatingBarChartPainter(
              ease: _state.easeAnimation.value,
              factors: _verticalFactors,
              context: context,
            ),
          ),
        ),
      ),
    );
  }
}
