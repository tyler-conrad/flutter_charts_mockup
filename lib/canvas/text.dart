import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/widgets/statistics.dart' as stats;
import 'package:flutter_charts_mockup/widgets/weekly_progress.dart' as wp;

/// Draws the text used by the [stats.Statistics] widget and the
/// [wp.WeeklyProgress] widget for the title labels.
const double _titleTextFontSize = 20.0;
m.Center titleText(String title, m.Color color, m.BuildContext context) {
  return m.Center(
    child: m.Text(
      title,
      style: m.TextStyle(
        fontSize: s.r(_titleTextFontSize),
        color: color,
        fontWeight: m.FontWeight.w700,
      ),
    ),
  );
}

/// Paints text centered around an [m.Offset].
double paintText({
  required m.Canvas canvas,
  required m.Offset center,
  required String text,
  required double fontSize,
  required m.Color color,
}) {
  final m.TextPainter textPainter = m.TextPainter(
    text: m.TextSpan(
      text: text,
      style: m.TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    ),
    textAlign: m.TextAlign.justify,
    textDirection: m.TextDirection.ltr,
  )..layout(
      maxWidth: double.infinity,
    );
  textPainter.paint(
    canvas,
    center -
        m.Offset(
              textPainter.width,
              textPainter.height,
            ) *
            0.5,
  );
  return textPainter.height;
}
