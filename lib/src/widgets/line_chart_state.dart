import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/src/shared.dart' as s;
import 'package:flutter_charts_mockup/src/widgets/line_chart_state.dart' as lcs;
import 'package:flutter_charts_mockup/src/widgets/filled_line_chart.dart'
    as flc;
import 'package:flutter_charts_mockup/src/widgets/currency_chart.dart' as cc;

/// Generic chart state that provides data initialization and animations for
/// the [flc.FilledLineChart] and the [cc.CurrencyChart].
class LineChartState<T extends m.TickerProviderStateMixin> {
  LineChartState({
    required T owner,
    required void Function(void Function()) setState,
  })  : _owner = owner,
        _setState = setState;

  static const int dragThrottleMillis = 300;

  final T _owner;
  final void Function(void Function()) _setState;

  static List<double> generateVerticalFactors(
      [int numFactors = s.numVerticalFactors]) {
    return List.generate(
      numFactors,
      (index) => 2.0 * (0.5 - s.rand()),
    );
  }

  late final m.AnimationController _easeController;
  late final m.Animation<double> easeAnimation;

  late final m.AnimationController _dragEaseController;
  late m.Animation<m.Offset> dragEaseAnimation;

  final m.ValueNotifier<m.Offset?> dragPos = m.ValueNotifier(null);
  m.Offset? _prevDragPos;

  m.Animation<m.Offset> _initDragEaseAnimation() {
    final animation = m.Tween<m.Offset>(
      begin: _prevDragPos ?? dragPos.value ?? m.Offset.zero,
      end: dragPos.value ?? m.Offset.zero,
    ).animate(
      m.CurvedAnimation(
        parent: _dragEaseController,
        curve: m.Curves.easeInOut,
      ),
    )..addStatusListener(
        (m.AnimationStatus status) {
          switch (status) {
            case m.AnimationStatus.dismissed:
              _setState(() {
                dragPos.value = null;
              });
              break;
            case m.AnimationStatus.completed:
              _setState(() {
                dragPos.value = null;
              });
              break;
            case m.AnimationStatus.forward:
              break;
            case m.AnimationStatus.reverse:
              break;
          }
        },
      );

    _prevDragPos = dragPos.value;

    _dragEaseController
      ..reset()
      ..forward();
    return animation;
  }

  void initState() {
    _easeController = m.AnimationController(
      vsync: _owner,
      duration: s.oneSecond,
    );

    easeAnimation = m.Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      m.CurvedAnimation(
        parent: _easeController,
        curve: m.Curves.easeInOut,
      ),
    )..addListener(() {
        _setState(() {});
      });

    _dragEaseController = m.AnimationController(
      vsync: _owner,
      duration: const Duration(
        milliseconds: lcs.LineChartState.dragThrottleMillis,
      ),
    );

    dragEaseAnimation = _initDragEaseAnimation();

    dragPos.addListener(
      () {
        dragEaseAnimation = _initDragEaseAnimation();
      },
    );
  }

  void onInView() {
    _easeController.forward();
  }

  void onNotInView() {
    _easeController.reverse();
  }

  void dispose() {
    dragPos.dispose();
    _dragEaseController.dispose();
    _easeController.dispose();
  }
}
