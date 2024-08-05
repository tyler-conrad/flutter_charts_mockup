import 'package:flutter/material.dart' as m;

import 'package:flutter_charts_mockup/shared.dart' as s;

/// Widget that wraps all displayed charts providing a surface on top of the
/// background color of the app.
class Card extends m.StatelessWidget {
  const Card({
    super.key,
    bool outerPadBottom = true,
    bool padChildOnLeft = true,
    bool padChildOnRight = true,
    required m.Widget child,
  })  : _outerPadBottom = outerPadBottom,
        _padChildOnLeft = padChildOnLeft,
        _padChildOnRight = padChildOnRight,
        _child = child;

  static const double _cornerRadius = 24.0;
  static const double _childPadding = 16.0;
  static const double _bottomPadding = 20.0;
  static const double _blurRadius = 14.0;
  static const double _shadowXOffset = 1.0;

  final bool _outerPadBottom;
  final bool _padChildOnLeft;
  final bool _padChildOnRight;
  final m.Widget _child;

  @override
  m.Widget build(
    m.BuildContext context,
  ) {
    final colors = m.Theme.of(context).colorScheme;
    return m.Padding(
      padding: m.EdgeInsets.only(
        bottom: _outerPadBottom ? s.r(_bottomPadding) : 0.0,
      ),
      child: m.DecoratedBox(
        decoration: m.BoxDecoration(
          color: colors.surface,
          boxShadow: [
            m.BoxShadow(
              color: colors.shadow,
              offset: m.Offset(
                0.0,
                s.r(_shadowXOffset),
              ),
              blurStyle: m.BlurStyle.outer,
              blurRadius: s.r(_blurRadius),
            ),
          ],
          borderRadius: m.BorderRadius.circular(
            s.r(_cornerRadius),
          ),
        ),
        child: m.Padding(
          padding: m.EdgeInsets.only(
            left: _padChildOnLeft ? s.r(_childPadding) : 0.0,
            right: _padChildOnRight ? s.r(_childPadding) : 0.0,
            top: s.r(_childPadding),
            bottom: s.r(_childPadding),
          ),
          child: _child,
        ),
      ),
    );
  }
}
