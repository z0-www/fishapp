import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'price_schedule.dart';

const walletPriceAsset = 'assets/pricing/deepseek_wallet_prices.json';

final walletPriceProvider = FutureProvider<WalletPriceSchedule?>((ref) async {
  try {
    return WalletPriceSchedule.parse(
      await rootBundle.loadString(walletPriceAsset),
    );
  } catch (_) {
    return null;
  }
});
