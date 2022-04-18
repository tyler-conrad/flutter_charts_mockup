import 'package:flutter_charts_mockup/widgets/filled_line_chart.dart' as flc;
import 'package:flutter_charts_mockup/widgets/currency_chart.dart' as cc;
import 'package:flutter_charts_mockup/widgets/alternating_bar_chart.dart'
    as abc;

/// The abstract interface for vertical factors.
///
/// Used to generate the x and y values for points and control points on curves.
abstract class VerticalFactors {
  Iterable<List<double>> get factors;
}

/// Vertical factors for the [flc.FilledLineChart].
class FilledLineChartVerticalFactors extends VerticalFactors {
  FilledLineChartVerticalFactors({required List<double> factors})
      : _factors = factors;

  final List<double> _factors;

  @override
  Iterable<List<double>> get factors => [
        _factors,
      ];
}

/// Vertical factors for the [cc.CurrencyChart].
class CurrencyChartVerticalFactors extends VerticalFactors {
  CurrencyChartVerticalFactors({
    required List<double> bitcoinFactors,
    required List<double> ethereumFactors,
  })  : _bitcoinFactors = bitcoinFactors,
        _ethereumFactors = ethereumFactors;

  final List<double> _bitcoinFactors;
  final List<double> _ethereumFactors;

  @override
  Iterable<List<double>> get factors => [
        _bitcoinFactors,
        _ethereumFactors,
      ];
}

/// Vertical factors for the [abc.AlternatingBarChart].
class AlternatingBarChartVerticalFactors extends VerticalFactors {
  AlternatingBarChartVerticalFactors({
    required List<double> factors,
    required List<double> barHeights,
  })  : _factors = factors,
        _barHeights = barHeights;

  final List<double> _factors;
  final List<double> _barHeights;

  @override
  Iterable<List<double>> get factors => [_factors, _barHeights];
}
