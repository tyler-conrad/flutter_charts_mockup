import 'package:flutter/material.dart' as m;
import 'package:visibility_detector/visibility_detector.dart' as vd;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/widgets/vertical_factors.dart' as vf;
import 'package:flutter_charts_mockup/canvas/curve.dart' as c;
import 'package:flutter_charts_mockup/canvas/background_lines.dart' as bl;
import 'package:flutter_charts_mockup/widgets/line_chart_state.dart' as lcs;
import 'package:flutter_charts_mockup/widgets/line_chart_painter_base.dart'
    as lcpb;
import 'package:flutter_charts_mockup/widgets/statistics.dart' as stats;
import 'package:flutter_charts_mockup/widgets/pointer_drag_listener.dart'
    as pdl;

/// Draws a curve that is filled with a gradient that fades from the primary
/// color to transparent.
///
/// Includes a ToolTip parameterized by the x value of a pointer drag which
/// displays the curves y value interpreted as a dollar amount.
class FilledLineChartPainter
    extends lcpb.LineChartPainterBase<vf.FilledLineChartVerticalFactors> {
  FilledLineChartPainter({
    required vf.FilledLineChartVerticalFactors verticalFactors,
    required double ease,
    required m.Offset? dragPos,
    required m.BuildContext context,
  }) : super(
          verticalFactors: verticalFactors,
          ease: ease,
          dragPos: dragPos,
          context: context,
        );

  @override
  void paint(
    m.Canvas canvas,
    m.Size size,
  ) {
    super.paint(
      canvas,
      size,
    );

    final leftPadding = s.r(lcpb.LineChartPainterBase.leftPadding);

    double chartLeftPadding = bl.paintBackgroundLines(
      size,
      leftPadding,
      canvas,
      context,
    );

    m.Path clipPath(m.Path path) => m.Path.combine(
          m.PathOperation.difference,
          path,
          m.Path()
            ..moveTo(-lcpb.LineChartPainterBase.clipPathOuterSize,
                -lcpb.LineChartPainterBase.clipPathOuterSize)
            ..lineTo(-lcpb.LineChartPainterBase.clipPathOuterSize,
                size.height + lcpb.LineChartPainterBase.clipPathOuterSize)
            ..lineTo(chartLeftPadding,
                size.height + lcpb.LineChartPainterBase.clipPathOuterSize)
            ..lineTo(
                chartLeftPadding, -lcpb.LineChartPainterBase.clipPathOuterSize)
            ..close(),
        );

    final halfHeight = size.height * 0.5;

    Iterable<m.Offset> borderPoints([double verticalOffset = 0.0]) sync* {
      yield m.Offset(
        size.width,
        halfHeight +
            halfHeight * verticalFactors.factors.first.last * ease +
            verticalOffset,
      );
      yield m.Offset(
        size.width,
        size.height,
      );
      yield m.Offset(
        chartLeftPadding,
        size.height,
      );
      yield m.Offset(
        chartLeftPadding,
        halfHeight +
            halfHeight * verticalFactors.factors.first.first * ease +
            verticalOffset,
      );
    }

    m.Path filled([double verticalOffset = 0.0]) {
      final points = borderPoints(
        verticalOffset,
      );

      final path = m.Path()
        ..moveTo(
          points.first.dx,
          points.first.dy,
        );

      for (final offset in points.skip(1)) {
        path.lineTo(
          offset.dx,
          offset.dy,
        );
      }

      for (final Iterable<m.Offset> pair in c.curvedPathPoints(
        size,
        chartLeftPadding,
        halfHeight,
        verticalFactors.factors.first,
        ease,
        verticalOffset,
      )) {
        path.quadraticBezierTo(
          pair.first.dx,
          pair.first.dy,
          pair.last.dx,
          pair.last.dy,
        );
      }

      return path;
    }

    final color = m.Theme.of(context).colorScheme.primary;
    var chartWidth = size.width - chartLeftPadding;
    canvas.drawPath(
      clipPath(filled()),
      m.Paint()
        ..shader = m.LinearGradient(
            begin: m.Alignment.topCenter,
            end: m.Alignment.bottomCenter,
            colors: [
              color,
              color.withOpacity(lcpb.LineChartPainterBase.opacity),
              m.Colors.transparent,
            ]).createShader(
          m.Rect.fromLTWH(
            chartLeftPadding,
            0.0,
            chartWidth,
            size.height,
          ),
        ),
    );

    paintLine(
      canvas,
      clipPath,
      size,
      chartLeftPadding,
      halfHeight,
      color,
      chartWidth,
      verticalFactors.factors.first,
    );

    paintToolTip(
      canvas,
      size,
      chartLeftPadding,
      halfHeight,
      verticalFactors.factors.first,
      chartWidth,
      color,
    );
  }
}

/// Chart with a curve filled with a gradient and a tooltip positioned on the
/// curve at the x position of a pointer drag.
class FilledLineChart extends m.StatefulWidget {
  const FilledLineChart({m.Key? key}) : super(key: key);

  @override
  m.State<FilledLineChart> createState() => _FilledLineChartState();
}

class _FilledLineChartState extends m.State<FilledLineChart>
    with m.TickerProviderStateMixin {
  final _visibilityDetectorKey = m.UniqueKey();
  final _visible = m.ValueNotifier(false);

  late final lcs.LineChartState<_FilledLineChartState> _state;

  final vf.FilledLineChartVerticalFactors _verticalFactors =
      vf.FilledLineChartVerticalFactors(
    factors: lcs.LineChartState.generateVerticalFactors(),
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
      chart: pdl.PointerDragListener(
        onPointerDrag: (m.Offset? pos) {
          s.throttle(
            () {
              setState(() {
                _state.dragPos.value = pos;
              });
            },
            lcs.LineChartState.dragThrottleMillis,
          )();
        },
        child: vd.VisibilityDetector(
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
              painter: FilledLineChartPainter(
                ease: _state.easeAnimation.value,
                dragPos: _state.dragEaseAnimation.value,
                verticalFactors: _verticalFactors,
                context: context,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
