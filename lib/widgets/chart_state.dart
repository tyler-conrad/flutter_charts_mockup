import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/shared.dart' as s;

/// Generic state class meant to be used with composition to provide animation
/// related functionality to different charts.
class ChartState {
  ChartState(
      {required m.SingleTickerProviderStateMixin owner,
      required void Function(void Function()) setState})
      : _owner = owner,
        _setState = setState;

  final m.SingleTickerProviderStateMixin _owner;
  final void Function(void Function()) _setState;

  late final m.AnimationController _easeAnimationController;
  late final m.Animation<double> easeAnimation;

  void initState() {
    _easeAnimationController = m.AnimationController(
      vsync: _owner,
      duration: s.oneSecond,
    );

    easeAnimation = m.Tween<double>(begin: 0.1, end: 1.0).animate(
      m.CurvedAnimation(
        parent: _easeAnimationController,
        curve: m.Curves.easeInOut,
      ),
    )..addListener(() {
        _setState(() {});
      });
  }

  void onInView() {
    _easeAnimationController.forward();
  }

  void onNotInView() {
    _easeAnimationController.reverse();
  }

  void dispose() {
    _easeAnimationController.dispose();
  }
}
