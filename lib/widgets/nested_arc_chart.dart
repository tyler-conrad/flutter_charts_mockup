import 'dart:math' as math;

import 'package:flutter/material.dart' as m;
import 'package:visibility_detector/visibility_detector.dart' as vd;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/canvas/primitives.dart' as p;
import 'package:flutter_charts_mockup/widgets/chart_state.dart' as cs;

/// Chart with arcs of decreasing radius whose sweep angle is animated.
class NestedArcChartPainter extends m.CustomPainter {
  NestedArcChartPainter({
    required double sweepAngleFactor,
    required m.BuildContext context,
  })  : _sweepAngleFactor = sweepAngleFactor,
        _context = context;

  static const _numCircles = 3;

  final double _sweepAngleFactor;
  final m.BuildContext _context;

  @override
  void paint(m.Canvas canvas, m.Size size) {
    final halfSize = size * 0.5;

    final center = m.Offset(
      halfSize.width,
      halfSize.height,
    );

    final halfMinSideSize = math.min(
          size.width,
          size.height,
        ) /
        2;

    final colors = m.Theme.of(_context).colorScheme;
    for (int i = 0; i < _numCircles * 2; i++) {
      final circleRadius = halfMinSideSize - s.arcWidth * i * 2.0;
      final circleColor =
          i % 2 == 0 ? colors.surfaceContainerHighest : colors.surface;
      p.Circle(
        center: center,
        radius: circleRadius,
        color: circleColor,
      ).paint(
        canvas,
        size,
      );

      if (i % 2 == 0) {
        final arcRadius = halfMinSideSize - s.arcWidth * i * 2.0;
        late final m.Color arcColor;
        late final double maxSweepAngleFactor;
        switch (i % 3) {
          case 0:
            arcColor = colors.primary;
            maxSweepAngleFactor = 0.8;

            break;
          case 1:
            arcColor = colors.secondary;
            maxSweepAngleFactor = 0.6;
            break;
          case 2:
            arcColor = colors.tertiary;
            maxSweepAngleFactor = 1.0;
            break;
        }

        p.ArcedPill(
          center: center,
          radius: arcRadius,
          crossAxisSize: s.arcWidth * 2.0,
          startAngle: math.pi * 1.5,
          sweepAngle: math.pi * maxSweepAngleFactor * _sweepAngleFactor,
          color: arcColor,
        ).paint(
          canvas,
          size,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant m.CustomPainter oldDelegate) =>
      _sweepAngleFactor > 0.001 && _sweepAngleFactor < 0.999;
}

class NestedArcChart extends m.StatefulWidget {
  const NestedArcChart({super.key});

  @override
  m.State<NestedArcChart> createState() => _NestedArcChartState();
}

class _NestedArcChartState extends m.State<NestedArcChart>
    with m.SingleTickerProviderStateMixin {
  final _visibilityDetectorKey = m.UniqueKey();
  final _visible = m.ValueNotifier(false);

  late final cs.ChartState _state;

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
    return vd.VisibilityDetector(
      key: _visibilityDetectorKey,
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.0) {
          _visible.value = true;
        } else {
          _visible.value = false;
        }
      },
      child: m.CustomPaint(
        painter: NestedArcChartPainter(
          sweepAngleFactor: _state.easeAnimation.value,
          context: context,
        ),
      ),
    );
  }
}
