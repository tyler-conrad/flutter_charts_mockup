import 'package:flutter/material.dart' as m;
import 'package:visibility_detector/visibility_detector.dart' as vd;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/canvas/primitives.dart' as p;

/// Paints seven [p.DayBar]s.
class WeekPeriodBarChartPainter extends m.CustomPainter {
  WeekPeriodBarChartPainter(
      {super.repaint,
      required Iterable<p.DayBar> bars,
      required double heightFactor})
      : _bars = bars,
        _heightFactor = heightFactor;

  final Iterable<p.DayBar> _bars;
  final double _heightFactor;

  @override
  void paint(m.Canvas canvas, m.Size size) {
    for (final bar in _bars) {
      bar.paint(
        canvas,
        size,
        _heightFactor,
      );
    }
  }

  @override
  bool shouldRepaint(covariant m.CustomPainter oldDelegate) =>
      _heightFactor > 0.001 && _heightFactor < 0.999;
}

/// Chart with two vertical bars of different colors a pair of which is drawn
/// for each day of the week.
class WeekPeriodBarChart extends m.StatefulWidget {
  const WeekPeriodBarChart({super.key});

  static const int numDaysInWeek = 7;

  @override
  m.State<WeekPeriodBarChart> createState() => _WeekPeriodBarChartState();
}

class _WeekPeriodBarChartState extends m.State<WeekPeriodBarChart>
    with m.SingleTickerProviderStateMixin {
  final _visibilityDetectorKey = m.UniqueKey();
  final _visible = m.ValueNotifier(false);

  late final m.AnimationController _heightFactorAnimationController;
  late final m.Animation<double> _heightFactorAnimation;

  static const double _dayBarWidth = 12.0;

  Iterable<p.DayBar> _bars = [];

  @override
  void initState() {
    super.initState();
    _heightFactorAnimationController = m.AnimationController(
      vsync: this,
      duration: s.oneSecond,
    );

    _heightFactorAnimation = m.Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      m.CurvedAnimation(
        parent: _heightFactorAnimationController,
        curve: m.Curves.easeInOut,
      ),
    )..addListener(
        () {
          setState(
            () {},
          );
        },
      );

    _visible.addListener(() {
      if (_visible.value) {
        _heightFactorAnimationController.forward();
      } else {
        _heightFactorAnimationController.reverse();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bars = List.generate(
      WeekPeriodBarChart.numDaysInWeek,
      (index) {
        return p.DayBar(
          width: s.r(_dayBarWidth),
          index: index,
          bottomHeightScale: s.rand(),
          topHeightScale: s.rand(),
          context: context,
        );
      },
    );
  }

  @override
  void dispose() {
    _visible.dispose();
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
        painter: WeekPeriodBarChartPainter(
          bars: _bars,
          heightFactor: _heightFactorAnimation.value,
        ),
      ),
    );
  }
}
