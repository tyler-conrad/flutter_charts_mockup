import 'package:flutter/material.dart' as m;
import 'package:visibility_detector/visibility_detector.dart' as vd;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/widgets/vertical_factors.dart' as vf;
import 'package:flutter_charts_mockup/widgets/line_chart_state.dart' as lcs;
import 'package:flutter_charts_mockup/widgets/statistics.dart' as stats;
import 'package:flutter_charts_mockup/widgets/line_chart_painter_base.dart'
    as lcpb;
import 'package:flutter_charts_mockup/widgets/pointer_drag_listener.dart'
    as pdl;
import 'package:flutter_charts_mockup/canvas/tooltip.dart' as tt;

/// Paints a red and yellow curve with a [tt.ToolTip] displaying a currency amount
/// based the curves y value from the x position of a pointer drag.
class CurrencyChartPainter extends lcpb.LineChartPainterBase {
  CurrencyChartPainter({
    required vf.CurrencyChartVerticalFactors super.verticalFactors,
    required super.ease,
    required super.dragPos,
    required super.context,
  });

  @override
  void paint(m.Canvas canvas, m.Size size) {
    final colors = m.Theme.of(context).colorScheme;
    paintLine(
      canvas,
      (_) => _,
      size,
      0.0,
      size.height * 0.5,
      colors.secondary,
      size.width,
      verticalFactors.factors.first,
    );

    paintToolTip(
      canvas,
      size,
      0.0,
      size.height * 0.5,
      verticalFactors.factors.first,
      size.width,
      colors.secondary,
    );

    paintLine(
      canvas,
      (_) => _,
      size,
      0.0,
      size.height * 0.5,
      colors.tertiary,
      size.width,
      verticalFactors.factors.skip(1).first,
    );
  }
}

/// A chart displaying two curves for currency prices.  Includes a [tt.ToolTip] that
/// is drawn at the x coordinate of a mouse drag.
class CurrencyChart extends m.StatefulWidget {
  const CurrencyChart({super.key});

  @override
  m.State<CurrencyChart> createState() => _CurrencyChartState();
}

class _CurrencyChartState extends m.State<CurrencyChart>
    with m.TickerProviderStateMixin {
  final _visibilityDetectorKey = m.UniqueKey();
  final _visible = m.ValueNotifier(false);

  late final lcs.LineChartState<_CurrencyChartState> _state;

  final vf.CurrencyChartVerticalFactors _verticalFactors =
      vf.CurrencyChartVerticalFactors(
    bitcoinFactors: lcs.LineChartState.generateVerticalFactors(),
    ethereumFactors: lcs.LineChartState.generateVerticalFactors(),
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
      buildLegend: true,
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
              painter: CurrencyChartPainter(
                ease: _state.easeAnimation.value,
                dragPos: _state.dragEaseAnimation.value,
                context: context,
                verticalFactors: _verticalFactors,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
