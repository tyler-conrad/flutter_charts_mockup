import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/src/canvas/text.dart' as t;
import 'package:flutter_charts_mockup/src/widgets/legend_item.dart' as li;

/// Wraps charts with a label.
class Statistics extends m.StatelessWidget {
  const Statistics({
    super.key,
    required m.Widget chart,
    bool buildLegend = false,
  })  : _chart = chart,
        _buildLegend = buildLegend;

  final m.Widget _chart;
  final bool _buildLegend;

  @override
  m.Widget build(m.BuildContext context) {
    final colors = m.Theme.of(context).colorScheme;
    return m.Column(
      crossAxisAlignment: m.CrossAxisAlignment.stretch,
      children: [
        m.Expanded(
          flex: 1,
          child: m.Row(
            crossAxisAlignment: m.CrossAxisAlignment.stretch,
            children: [
              m.Expanded(
                flex: 1,
                child: t.titleText(
                  'Statistics',
                  colors.onSurface,
                  context,
                ),
              ),
              if (_buildLegend)
                m.Expanded(
                  flex: 2,
                  child: m.Row(
                    mainAxisAlignment: m.MainAxisAlignment.spaceAround,
                    crossAxisAlignment: m.CrossAxisAlignment.stretch,
                    children: [
                      const m.Spacer(flex: 2),
                      m.Expanded(
                        flex: 4,
                        child: li.LegendItem(type: li.LegendItemType.bitcoin),
                      ),
                      const m.Spacer(flex: 1),
                      m.Expanded(
                        flex: 4,
                        child: li.LegendItem(type: li.LegendItemType.ethereum),
                      ),
                      const m.Spacer(flex: 1),
                    ],
                  ),
                ),
              if (!_buildLegend) const m.Spacer(flex: 2),
            ],
          ),
        ),
        m.Expanded(
          flex: 4,
          child: _chart,
        ),
      ],
    );
  }
}
