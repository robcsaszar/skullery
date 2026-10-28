import 'package:larder_api/larder_api.dart';

const _fractions = [
  (0.25, '¼'),
  (0.5, '½'),
  (0.75, '¾'),
  (0.333, '⅓'),
  (0.667, '⅔'),
  (0.125, '⅛'),
];

/// A number the way a cook reads it: 2, 1½, 0.3, 2.33.
String formatNumber(double v) {
  if (v == v.roundToDouble()) return v.toInt().toString();
  final whole = v.floor();
  final part = v - whole;
  for (final (value, glyph) in _fractions) {
    if ((part - value).abs() < 0.01) {
      return whole == 0 ? glyph : '$whole$glyph';
    }
  }
  var s = v.toStringAsFixed(2);
  while (s.endsWith('0')) {
    s = s.substring(0, s.length - 1);
  }
  return s.endsWith('.') ? s.substring(0, s.length - 1) : s;
}

/// The amount and unit as entered, with the metric reading in brackets when
/// the entered unit is not already metric. Empty when there is no amount.
String formatAmount(Amount a) {
  switch (a.type) {
    case AmountType.none:
      return '';
    case AmountType.toTaste:
      return 'to taste';
    case AmountType.exact:
    case AmountType.range:
      final value = a.value;
      if (value == null) return '';
      var text = formatNumber(value);
      if (a.type == AmountType.range && a.valueMax != null) {
        text = '$text–${formatNumber(a.valueMax!)}';
      }
      if (a.unit != null) text = '$text ${a.unit}';
      if (a.metricValue != null &&
          a.metricUnit != null &&
          a.metricUnit != a.unit) {
        text = '$text (${formatNumber(a.metricValue!)} ${a.metricUnit})';
      }
      return text;
  }
}

/// One line for an ingredient: amount, unit and the raw text.
String formatIngredient(Ingredient i) {
  final amount = formatAmount(i.amount);
  final rest = i.raw ?? i.item ?? '';
  return [amount, rest].where((s) => s.isNotEmpty).join(' ');
}

/// A yield such as "4 servings".
String formatYield(Yield y) => '${formatNumber(y.amount)} ${y.unit}';

/// 2020-05-01, the way the old site wrote dates.
String formatDate(DateTime d) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${d.year}-${two(d.month)}-${two(d.day)}';
}
