import 'dart:math' as math;

import 'package:flutter/material.dart' as m;
import 'package:visibility_detector/visibility_detector.dart' as vd;

import 'package:flutter_charts_mockup/src/shared.dart' as s;
import 'package:flutter_charts_mockup/src/canvas/primitives.dart' as p;
import 'package:flutter_charts_mockup/src/widgets/chart_state.dart' as cs;

/// Paints three [p.ArcedPill]s at the same radius.
///
/// Paints a background tube with arcs painted over the top.  The angle of the
/// arcs are animated based on a normalized tween value.
class FixedOverlappingArcChartPainter extends m.CustomPainter {
  FixedOverlappingArcChartPainter({
    super.repaint,
    required double sweepAngleFactor,
    required m.ColorScheme colors,
  })  : _sweepAngleFactor = sweepAngleFactor,
        _colors = colors {
    _width = s.arcWidth * 2.0;
  }

  late final double _width;
  final double _sweepAngleFactor;
  final m.ColorScheme _colors;

  @override
  void paint(
    m.Canvas canvas,
    m.Size size,
  ) {
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

    void paintArcedPill(
      double sweepAngle,
      m.Color color,
    ) {
      p.ArcedPill(
        center: center,
        radius: halfMinSideSize,
        crossAxisSize: _width,
        startAngle: math.pi * 1.5,
        sweepAngle: sweepAngle,
        color: color,
      ).paint(
        canvas,
        size,
      );
    }

    p.Circle(
      center: center,
      radius: halfMinSideSize,
      color: _colors.surfaceContainerHighest,
    ).paint(
      canvas,
      size,
    );

    paintArcedPill(
      math.pi * 1.5 * _sweepAngleFactor,
      _colors.primary,
    );
    paintArcedPill(
      math.pi * 1.2 * _sweepAngleFactor,
      _colors.secondary,
    );
    paintArcedPill(
      math.pi * _sweepAngleFactor,
      _colors.tertiary,
    );

    p.Circle(
      center: center,
      radius: halfMinSideSize - _width,
      color: _colors.surface,
    ).paint(
      canvas,
      size,
    );
  }

  @override
  bool shouldRepaint(covariant m.CustomPainter oldDelegate) =>
      _sweepAngleFactor > 0.001 && _sweepAngleFactor < 0.999;
}

class FixedOverlappingArcChart extends m.StatefulWidget {
  const FixedOverlappingArcChart({super.key});

  @override
  m.State<FixedOverlappingArcChart> createState() =>
      _FixedOverlappingArcChartState();
}

class _FixedOverlappingArcChartState extends m.State<FixedOverlappingArcChart>
    with m.SingleTickerProviderStateMixin {
  final _visibilityDetectorKey = m.UniqueKey();

  late final cs.ChartState _state;

  final _visible = m.ValueNotifier(false);

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
        painter: FixedOverlappingArcChartPainter(
          sweepAngleFactor: _state.easeAnimation.value,
          colors: m.Theme.of(context).colorScheme,
        ),
      ),
    );
  }
}
