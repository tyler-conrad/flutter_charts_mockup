import 'package:flutter/material.dart' as m;
import 'package:flutter_svg/flutter_svg.dart' as svg;
import 'package:visibility_detector/visibility_detector.dart' as vd;

import 'package:flutter_charts_mockup/shared.dart' as s;
import 'package:flutter_charts_mockup/canvas/primitives.dart' as p;
import 'package:flutter_charts_mockup/widgets/chart_state.dart' as cs;

/// The two types of progress bars.
enum ProgressBarType {
  red,
  yellow,
}

/// Draws a [p.Pill] whose width is animated.
class ProgressBarPainter extends m.CustomPainter {
  ProgressBarPainter({
    required ProgressBarType type,
    required double progressFactor,
    required double ease,
    required m.BuildContext context,
  })  : _type = type,
        _progressFactor = progressFactor,
        _ease = ease,
        _context = context;

  final ProgressBarType _type;
  final double _progressFactor;
  final double _ease;
  final m.BuildContext _context;

  @override
  void paint(m.Canvas canvas, m.Size size) {
    final halfSize = size * 0.5;

    final center = m.Offset(
      halfSize.width,
      halfSize.height,
    );

    final colors = m.Theme.of(_context).colorScheme;

    p.Pill(
      center: center,
      crossAxisSize: size.height * 0.8,
      mainAxisSize: size.width,
      color: colors.surfaceVariant,
    ).paint(
      canvas,
      size,
    );

    final width = size.width * _ease * _progressFactor;

    p.Pill(
      center: m.Offset(
        width * 0.5,
        center.dy,
      ),
      crossAxisSize: size.height * 0.8,
      mainAxisSize: width,
      color: _type == ProgressBarType.red ? colors.secondary : colors.tertiary,
    ).paint(
      canvas,
      size,
    );
  }

  @override
  bool shouldRepaint(covariant m.CustomPainter oldDelegate) =>
      _ease > 0.001 && _ease < 0.999;
}

/// A progress bar widget with an icon, percent label and progress bar.
class ProgressBar extends m.StatefulWidget {
  const ProgressBar({
    m.Key? key,
    required ProgressBarType type,
  })  : _type = type,
        super(key: key);

  final ProgressBarType _type;

  @override
  m.State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends m.State<ProgressBar>
    with m.SingleTickerProviderStateMixin {
  final _visibilityDetectorKey = m.UniqueKey();
  final _visible = m.ValueNotifier(false);

  late final cs.ChartState _state;

  static const double _fontSize = 17.0;
  static const double _cornerRadius = 12.0;
  static const double _outerPadding = 12.0;
  static const double _innerPadding = 18.0;

  late final double _progressFactor;

  @override
  void initState() {
    super.initState();
    _state = cs.ChartState(
      owner: this,
      setState: setState,
    )..initState();

    _progressFactor = widget._type == ProgressBarType.red ? 0.15 : 0.75;

    _visible.addListener(() {
      if (_visible.value) {
        _state.onInView();
      } else {
        _state.onNotInView();
      }
    });
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  m.Widget build(m.BuildContext context) {
    final colors = m.Theme.of(context).colorScheme;
    final fontSize = s.r(_fontSize);
    final cornerRadius = s.r(_cornerRadius);

    final outerPadding = s.r(_outerPadding);

    const innerPadding = _innerPadding;
    return m.Row(
      crossAxisAlignment: m.CrossAxisAlignment.stretch,
      children: [
        m.Expanded(
          flex: 2,
          child: m.Padding(
            padding: m.EdgeInsets.all(outerPadding),
            child: m.Container(
              decoration: m.BoxDecoration(
                color: widget._type == ProgressBarType.red
                    ? colors.secondary
                    : colors.tertiary,
                borderRadius: m.BorderRadius.all(
                  m.Radius.circular(
                    cornerRadius,
                  ),
                ),
              ),
              child: m.Padding(
                padding: const m.EdgeInsets.all(innerPadding),
                child: svg.SvgPicture.asset(
                  widget._type == ProgressBarType.red
                      ? 'assets/svg/down_arrow.svg'
                      : 'assets/svg/up_arrow.svg',
                ),
              ),
            ),
          ),
        ),
        m.Expanded(
          flex: 5,
          child: m.Column(
            crossAxisAlignment: m.CrossAxisAlignment.stretch,
            children: [
              m.Expanded(
                flex: 3,
                child: m.Row(
                  crossAxisAlignment: m.CrossAxisAlignment.stretch,
                  children: [
                    m.Expanded(
                      flex: 5,
                      child: m.Center(
                        child: m.Text(
                          'Weekly Progress',
                          style: m.TextStyle(
                              color: colors.onSurface,
                              fontSize: fontSize,
                              fontWeight: m.FontWeight.w700),
                        ),
                      ),
                    ),
                    const m.Spacer(flex: 1),
                    m.Expanded(
                      flex: 2,
                      child: m.Center(
                        child: m.Text(
                          '${(100.0 * _state.easeAnimation.value * _progressFactor).toInt()}%',
                          style: m.TextStyle(
                            color: widget._type == ProgressBarType.red
                                ? colors.secondary
                                : colors.tertiary,
                            fontSize: fontSize,
                            fontWeight: m.FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const m.Spacer(flex: 1),
              m.Expanded(
                flex: 1,
                child: vd.VisibilityDetector(
                  key: _visibilityDetectorKey,
                  onVisibilityChanged: (visibilityInfo) {
                    if (visibilityInfo.visibleFraction > 0.0) {
                      _visible.value = true;
                    } else {
                      _visible.value = false;
                    }
                  },
                  child: m.CustomPaint(
                    painter: ProgressBarPainter(
                      type: widget._type,
                      progressFactor: _progressFactor,
                      ease: _state.easeAnimation.value,
                      context: context,
                    ),
                  ),
                ),
              ),
              const m.Spacer(flex: 1),
            ],
          ),
        ),
      ],
    );
  }
}
