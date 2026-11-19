class DeepSeekBalance {
  DeepSeekBalance._(this.available, this.totals, this.updatedAt);
  final bool available;
  final Map<String, String> totals;
  final DateTime updatedAt;

  factory DeepSeekBalance.fromResponse(Object? data, DateTime time) {
    if (data is! Map ||
        data['is_available'] is! bool ||
        data['balance_infos'] is! List) {
      throw const FormatException();
    }
    final totals = <String, String>{};
    for (final row in data['balance_infos'] as List) {
      if (row is! Map ||
          !['USD', 'CNY'].contains(row['currency']) ||
          row['total_balance'] is! String) {
        throw const FormatException();
      }
      final currency = row['currency'] as String;
      final amount = row['total_balance'] as String;
      if (totals.containsKey(currency) ||
          !RegExp(r'^-?[0-9]{1,20}(?:\.[0-9]{1,12})?$').hasMatch(amount)) {
        throw const FormatException();
      }
      totals[currency] = amount;
    }
    if (totals.isEmpty) throw const FormatException();
    return DeepSeekBalance._(
      data['is_available'] as bool,
      Map.unmodifiable(totals),
      time,
    );
  }

  bool get low =>
      !available ||
      totals.entries.every(
        (item) => double.parse(item.value) <= (item.key == 'CNY' ? 5 : 1),
      );
}
