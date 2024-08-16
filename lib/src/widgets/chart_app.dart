import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/src/shared.dart' as s;
import 'package:flutter_charts_mockup/src/widgets/card.dart' as c;
import 'package:flutter_charts_mockup/src/widgets/fixed_overlapping_arc_chart.dart'
    as foac;
import 'package:flutter_charts_mockup/src/widgets/week_period_bar_chart.dart'
    as wpbc;
import 'package:flutter_charts_mockup/src/widgets/filled_line_chart.dart'
    as flc;
import 'package:flutter_charts_mockup/src/widgets/currency_chart.dart' as cc;
import 'package:flutter_charts_mockup/src/widgets/nested_arc_chart.dart' as nac;
import 'package:flutter_charts_mockup/src/widgets/progress_bar.dart' as pb;
import 'package:flutter_charts_mockup/src/widgets/alternating_bar_chart.dart'
    as abc;
import 'package:flutter_charts_mockup/src/widgets/stacked_bar_chart.dart'
    as sbc;
import 'package:flutter_charts_mockup/src/widgets/weekly_progress.dart' as wp;

/// The main widget that aggregates all of the charts and other widgets.
///
/// Implemented as a [m.SingleChildScrollView] with [m.Row]s and [m.Column]s
/// using [m.Expanded] widgets to size the cards displayed.
class ChartApp extends m.StatefulWidget {
  const ChartApp({
    super.key,
  });

  @override
  m.State<ChartApp> createState() => _ChartState();
}

class _ChartState extends m.State<ChartApp> {
  static const _screenPadding = 32.0;

  bool showOverly = false;

  @override
  m.Widget build(
    m.BuildContext context,
  ) {
    final mediaQuery = m.MediaQuery.of(context);
    return m.SafeArea(
      child: m.SingleChildScrollView(
        child: m.SizedBox(
          height: mediaQuery.size.width * (s.aspectHeight / s.aspectWidth),
          child: const m.Stack(
            children: [
              m.Padding(
                padding: m.EdgeInsets.all(
                  _screenPadding,
                ),
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.stretch,
                  children: [
                    m.Expanded(
                      flex: 16,
                      child: c.Card(
                        child: wp.WeeklyProgress(
                          circularChartWidget: foac.FixedOverlappingArcChart(),
                        ),
                      ),
                    ),
                    m.Expanded(
                      flex: 24,
                      child: c.Card(
                        child: wpbc.WeekPeriodBarChart(),
                      ),
                    ),
                    m.Expanded(
                      flex: 27,
                      child: c.Card(
                        padChildOnRight: false,
                        child: flc.FilledLineChart(),
                      ),
                    ),
                    m.Expanded(
                      flex: 22,
                      child: c.Card(
                        padChildOnLeft: false,
                        padChildOnRight: false,
                        child: cc.CurrencyChart(),
                      ),
                    ),
                    m.Expanded(
                      flex: 15,
                      child: c.Card(
                        child: wp.WeeklyProgress(
                          circularChartWidget: nac.NestedArcChart(),
                        ),
                      ),
                    ),
                    m.Expanded(
                      flex: 13,
                      child: c.Card(
                        child: pb.ProgressBar(type: pb.ProgressBarType.red),
                      ),
                    ),
                    m.Expanded(
                      flex: 13,
                      child: c.Card(
                        child: pb.ProgressBar(type: pb.ProgressBarType.yellow),
                      ),
                    ),
                    m.Expanded(
                      flex: 25,
                      child: c.Card(
                        padChildOnRight: false,
                        child: abc.AlternatingBarChart(),
                      ),
                    ),
                    m.Expanded(
                      flex: 18,
                      child: c.Card(
                        child: sbc.StackedBarChart(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
