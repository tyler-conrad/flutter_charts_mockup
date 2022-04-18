# flutter_charts_mockup

Flutter project implementing the graphs from the Figma design available [here](https://dribbble.com/shots/10904459-Marvie-iOS-App-UI-Kit-Dark-Theme?ref=uistore.design).

![demo](assets/demo.gif)

## Implementation
CustomPainter subclasses are used extensively to implement:
 - Primitives for Circles, Pills, and ArcedPills that can be painted.
 - AlternatingBarChart
 - CurrencyChart
 - FilledLineChart
 - FixedOverlappingArcChart
 - NestedArcChart
 - ProgressBar
 - StackedBarChart
 - WeekPeriodBarChart
 - PointerDragListener

## Documentation
Code documentation is available [here](https://tyler-conrad.github.io/flutter_charts_mockup/).

## Web Demo
A demo of the application is available [here](https://tyler-conrad.github.io/flutter_charts_mockup/demo).

## Tested on
Platform:
 - Ubuntu 20.04.4 LTS
 - Android 11
   - Platform android-31, build-tools 31.0.0
   - Java version OpenJDK Runtime Environment (build 11.0.11+0-b60-7590822) 

Flutter:
 - Flutter 2.13.0-0.1.pre • channel beta • https://github.com/flutter/flutter.git
 - Framework • revision 13a2fb10b8 (5 days ago) • 2022-04-12 15:34:25 -0500
 - Engine • revision 499984f99c
 - Tools • Dart 2.17.0 (build 2.17.0-266.1.beta) • DevTools 2.12.1