import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/canvas/text.dart' as t;
import 'package:flutter_charts_mockup/widgets/legend_label.dart' as ll;

/// Wraps a child widget with a title and legend.
class WeeklyProgress extends m.StatelessWidget {
  const WeeklyProgress({
    super.key,
    required m.Widget circularChartWidget,
  }) : _circularChartWidget = circularChartWidget;

  final m.Widget _circularChartWidget;

  @override
  m.Widget build(
    m.BuildContext context,
  ) {
    final colors = m.Theme.of(context).colorScheme;
    return m.Row(
      crossAxisAlignment: m.CrossAxisAlignment.stretch,
      children: [
        m.Expanded(
          flex: 2,
          child: _circularChartWidget,
        ),
        m.Expanded(
          flex: 3,
          child: m.Column(
            crossAxisAlignment: m.CrossAxisAlignment.stretch,
            children: [
              m.Expanded(
                flex: 3,
                child: t.titleText(
                  'Weekly Progress',
                  colors.onSurface,
                  context,
                ),
              ),
              m.Expanded(
                flex: 7,
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.stretch,
                  children: [
                    m.Expanded(
                      flex: 1,
                      child: ll.LegendLabel(pillColor: colors.tertiary),
                    ),
                    m.Expanded(
                      flex: 1,
                      child: ll.LegendLabel(pillColor: colors.secondary),
                    ),
                    m.Expanded(
                      flex: 1,
                      child: ll.LegendLabel(pillColor: colors.primary),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
