import 'package:responsive_sizer/responsive_sizer.dart' as sizer;
import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/widgets/chart_app.dart' as ca;

void main() {
  const backgroundColor = m.Color(0xFF222E34);

  m.runApp(
    m.MaterialApp(
      theme: m.ThemeData(
        brightness: m.Brightness.dark,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: const m.ColorScheme.dark().copyWith(
          primary: const m.Color(0xFF3DD598),
          secondary: const m.Color(0xFFFF575F),
          tertiary: const m.Color(0xFFFFC542),
          surface: const m.Color(0xFF34434D),
          surfaceContainerHighest: const m.Color(0xFF2E3B43),
          onSurface: m.Colors.white,
          onSurfaceVariant: const m.Color(0xFF96A7AF),
          shadow: m.Colors.black.withOpacity(0.25),
        ),
      ),
      builder: (context, child) => sizer.ResponsiveSizer(
        builder: (context, orientation, screenType) => child!,
      ),
      home: const m.Scaffold(
        body: ca.ChartApp(),
      ),
    ),
  );
}
