import 'dart:convert';

import 'price_table.dart';

enum PricePeriod {
  peak('峰时'),
  offPeak('谷时'),
  unknown('价格待核实');

  const PricePeriod(this.label);
  final String label;
}

class WalletPriceSchedule {
  WalletPriceSchedule._(
    this.version,
    this.effectiveAt,
    this.expiresAt,
    this.holidayRanges,
    this.peakWindows,
    this.rates,
  );
  final String version;
  final DateTime effectiveAt, expiresAt;
  final List<(DateTime, DateTime)> holidayRanges;
  final List<(int, int)> peakWindows;
  final Map<String, List<double>> rates;

  static WalletPriceSchedule parse(String source) {
    final data = jsonDecode(source) as Map<String, dynamic>;
    if (data['schema'] != 1 || data['currency'] != 'USD') {
      throw const FormatException('Unsupported pricing data');
    }
    final from = DateTime.parse(data['from'] as String).toUtc();
    final to = DateTime.parse(data['until'] as String).toUtc();
    final version = data['version'] as String;
    if (!to.isAfter(from) || version.isEmpty) throw const FormatException();
    final holidays = [
      for (final range in data['beijingHolidays'] as List)
        (
          DateTime.parse('${range[0]}T00:00:00Z'),
          DateTime.parse('${range[1]}T00:00:00Z'),
        ),
    ];
    final windows = [
      for (final range in data['beijingPeakMinutes'] as List)
        (range[0] as int, range[1] as int),
    ];
    final rates = {
      for (final entry in (data['rates'] as Map<String, dynamic>).entries)
        entry.key: (entry.value as List)
            .map((v) => (v as num).toDouble())
            .toList(),
    };
    if (holidays.any((range) => range.$2.isBefore(range.$1)) ||
        windows.isEmpty ||
        windows.any(
          (range) => range.$1 < 0 || range.$2 > 1440 || range.$1 >= range.$2,
        ) ||
        rates.isEmpty ||
        rates.values.any(
          (row) =>
              row.length != 6 || row.any((rate) => !rate.isFinite || rate < 0),
        )) {
      throw const FormatException('Invalid pricing data');
    }
    return WalletPriceSchedule._(version, from, to, holidays, windows, rates);
  }

  static DateTime beijing(DateTime time) =>
      time.toUtc().add(const Duration(hours: 8));
  static DateTime dayStart(DateTime time) {
    final local = beijing(time);
    return DateTime.utc(
      local.year,
      local.month,
      local.day,
    ).subtract(const Duration(hours: 8));
  }

  PricePeriod period(DateTime time) {
    if (time.isBefore(effectiveAt) || !time.isBefore(expiresAt)) {
      return PricePeriod.unknown;
    }
    final local = beijing(time);
    final date = DateTime.utc(local.year, local.month, local.day);
    final minute = local.hour * 60 + local.minute;
    final holiday = holidayRanges.any(
      (range) => !date.isBefore(range.$1) && !date.isAfter(range.$2),
    );
    final peak =
        local.weekday <= DateTime.friday &&
        !holiday &&
        peakWindows.any((window) => minute >= window.$1 && minute < window.$2);
    return peak ? PricePeriod.peak : PricePeriod.offPeak;
  }

  PriceTable? priceAt(
    DateTime time,
    String model, {
    bool conservative = false,
  }) {
    final row = rates[model];
    final slot = period(time);
    if (row == null || slot == PricePeriod.unknown) return null;
    final i = conservative || slot == PricePeriod.peak ? 0 : 3;
    return PriceTable(
      version: '$version-${i == 0 ? 'peak' : 'offpeak'}',
      effectiveAt: effectiveAt,
      model: model,
      inputUsdPerMillion: row[i],
      outputUsdPerMillion: row[i + 1],
      cachedUsdPerMillion: row[i + 2],
    );
  }
}
