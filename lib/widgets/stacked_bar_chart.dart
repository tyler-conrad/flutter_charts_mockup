import 'dart:math' as math;

import 'package:flutter/material.dart' as m;
import 'package:visibility_detector/visibility_detector.dart' as vd;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/canvas/curve.dart' as c;
import 'package:flutter_charts_mockup/canvas/primitives.dart' as p;
import 'package:flutter_charts_mockup/widgets/vertical_factors.dart' as vf;
import 'package:flutter_charts_mockup/widgets/chart_state.dart' as cs;
import 'package:flutter_charts_mockup/widgets/line_chart_state.dart' as lcs;
import 'package:flutter_charts_mockup/widgets/statistics.dart' as s;

/// Paints one of three possible vertical [p.Pill]s.  One for a background, one
/// for a single vertical bar and for a pair of vertical bars.
class StackedBarChartPainter extends m.CustomPainter {
  StackedBarChartPainter({
    required double ease,
    required StackedBarChartVerticalFactors factors,
    required m.BuildContext context,
  })  : _ease = ease,
        _factors = factors,
        _context = context;

  static const _barWidth = 4.0;

  final double _ease;
  final StackedBarChartVerticalFactors _factors;
  final m.BuildContext _context;

  @override
  void paint(m.Canvas canvas, m.Size size) {
    final path = m.Path();
    for (final Iterable<m.Offset> pair in c.curvedPathPoints(
      size,
      0.0,
      size.height * 0.5,
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

    final colors = m.Theme.of(_context).colorScheme;
    m.Color colorFromIndex(int index) {
      switch (index % 3) {
        case 0:
          return colors.primary;
        case 1:
          return colors.secondary;
        case 2:
          return colors.tertiary;
        default:
          throw Exception('Unreachable');
      }
    }

    final left = size.width / (s.numVerticalFactors - 2) / size.width;

    for (int i = 0; i < StackedBarChart._numStackedBars; i++) {
      final x = left + (i / StackedBarChart._numStackedBars);
      final offset = c.onPath(
          math.max(
            x,
            s.minCurveX,
          ),
          path);

      final dx = size.width * (i / StackedBarChart._numStackedBars) +
          size.width * 0.025;
      final crossAxisSize = s.r(_barWidth);

      if (i > 6 && i < 15) {
        if (_factors._isStacked[i]) {
          p.Pill(
            center: m.Offset(
                dx,
                (offset.dy -
                        0.25 * _factors.factors.last[i * 2] * size.height) -
                    size.height * 0.01),
            crossAxisSize: crossAxisSize,
            mainAxisSize:
                0.5 * _factors.factors.last[i * 2] * size.height * _ease,
            color: colorFromIndex(i),
            orientation: m.Orientation.portrait,
          ).paint(
            canvas,
            size,
          );

          p.Pill(
            center: m.Offset(
                dx,
                offset.dy +
                    0.25 * _factors.factors.last[i * 2 + 1] * size.height +
                    size.height * 0.01),
            crossAxisSize: crossAxisSize,
            mainAxisSize:
                0.5 * _factors.factors.last[i * 2 + 1] * size.height * _ease,
            color: colorFromIndex(i + 1),
            orientation: m.Orientation.portrait,
          ).paint(
            canvas,
            size,
          );
        } else {
          p.Pill(
            center: m.Offset(dx, offset.dy),
            crossAxisSize: crossAxisSize,
            mainAxisSize: _factors.factors.last[i * 2] * size.height * _ease,
            color: colorFromIndex(i + 1),
            orientation: m.Orientation.portrait,
          ).paint(
            canvas,
            size,
          );
        }
      } else {
        p.Pill(
          center: m.Offset(dx, offset.dy),
          crossAxisSize: crossAxisSize,
          mainAxisSize: _factors.factors.last[i * 2] * size.height * _ease,
          color: colors.surfaceContainerHighest,
          orientation: m.Orientation.portrait,
        ).paint(
          canvas,
          size,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant m.CustomPainter oldDelegate) =>
      _ease > 0.001 && _ease < 0.999;
}

/// Draws single and paired vertical bars of different colors.
class StackedBarChartVerticalFactors extends vf.VerticalFactors {
  StackedBarChartVerticalFactors({
    required List<double> factors,
    required List<double> barHeights,
    required List<bool> isStacked,
  })  : _factors = factors,
        _barHeights = barHeights,
        _isStacked = isStacked;

  final List<double> _factors;
  final List<double> _barHeights;
  final List<bool> _isStacked;

  List<bool> get isStacked => _isStacked;

  @override
  Iterable<List<double>> get factors => [_factors, _barHeights];
}

class StackedBarChart extends m.StatefulWidget {
  const StackedBarChart({super.key});

  static const _numStackedBars = 20;

  @override
  m.State<StackedBarChart> createState() => _StackedBarChartState();
}

class _StackedBarChartState extends m.State<StackedBarChart>
    with m.SingleTickerProviderStateMixin {
  final _visibilityDetectorKey = m.UniqueKey();
  final _visible = m.ValueNotifier(false);

  late final cs.ChartState _state;

  final StackedBarChartVerticalFactors _verticalFactors =
      StackedBarChartVerticalFactors(
    factors: lcs.LineChartState.generateVerticalFactors()
        .map((f) => f * 0.25)
        .toList(),
    barHeights: lcs.LineChartState.generateVerticalFactors(
            StackedBarChart._numStackedBars * 2)
        .map((f) => f * 0.25 + 0.5)
        .toList(),
    isStacked: List.generate(
        StackedBarChart._numStackedBars, (index) => index % 2 == 0).toList(),
  );

  @override
  void initState() {
    super.initState();

    _state = cs.ChartState(
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
    return s.Statistics(
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
            painter: StackedBarChartPainter(
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
