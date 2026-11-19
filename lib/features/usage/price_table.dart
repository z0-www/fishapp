/// No unverified prices are bundled. Null estimate means unknown, never free.
class PriceTable {
  const PriceTable({
    required this.version,
    required this.effectiveAt,
    required this.model,
    this.inputUsdPerMillion,
    this.outputUsdPerMillion,
    this.cachedUsdPerMillion,
  });
  final String version;
  final DateTime effectiveAt;
  final String model;
  final double? inputUsdPerMillion, outputUsdPerMillion, cachedUsdPerMillion;
  double? estimate({
    required DateTime requestedAt,
    required int input,
    required int output,
    required int cached,
  }) {
    if (requestedAt.isBefore(effectiveAt) ||
        input < 0 ||
        output < 0 ||
        cached < 0 ||
        cached > input ||
        inputUsdPerMillion == null ||
        outputUsdPerMillion == null ||
        (cached > 0 && cachedUsdPerMillion == null)) {
      return null;
    }
    return ((input - cached) * inputUsdPerMillion! +
            output * outputUsdPerMillion! +
            cached * (cachedUsdPerMillion ?? 0)) /
        1000000;
  }
}
