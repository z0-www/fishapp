import 'price_table.dart';
import '../ai/data/deepseek_models.dart';

/// Peak ceiling snapshot, USD per million tokens. Never an actual bill.
abstract final class DeepSeekPrices {
  static PriceTable? forModel(String model) => switch (model) {
    DeepSeekModels.defaultModel => PriceTable(
      version: 'deepseek-2026-11-17-peak-ceiling',
      effectiveAt: DateTime.utc(2026, 11, 17),
      model: DeepSeekModels.defaultModel,
      inputUsdPerMillion: .3,
      outputUsdPerMillion: 1.2,
      cachedUsdPerMillion: .006,
    ),
    DeepSeekModels.proModel => PriceTable(
      version: 'deepseek-2026-11-17-peak-ceiling',
      effectiveAt: DateTime.utc(2026, 11, 17),
      model: DeepSeekModels.proModel,
      inputUsdPerMillion: 1.32,
      outputUsdPerMillion: 3.96,
      cachedUsdPerMillion: .044,
    ),
    _ => null,
  };
  static double? estimate(String model, int input, int output) =>
      forModel(model)?.estimate(
        requestedAt: DateTime.now(),
        input: input,
        output: output,
        cached: 0,
      );
}
