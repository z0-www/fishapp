class WalletPlan {
  const WalletPlan({
    this.daily,
    this.warning,
    this.automatic,
    this.authorizedDay,
    this.authorizedVersion,
  });
  final double? daily, warning, automatic;
  final String? authorizedDay, authorizedVersion;

  factory WalletPlan.fromJson(Map<String, dynamic>? values) {
    double? amount(Object? value) =>
        value is num && value.isFinite && value > 0 ? value.toDouble() : null;
    return WalletPlan(
      daily: amount(values?['daily']),
      warning: amount(values?['warning']),
      automatic: amount(values?['automatic']),
      authorizedDay: values?['day'] as String?,
      authorizedVersion: values?['version'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'daily': daily,
    'warning': warning,
    'automatic': automatic,
    'day': authorizedDay,
    'version': authorizedVersion,
  };
}

class WalletSpending {
  const WalletSpending(this.usd, this.unknown);
  final double usd;
  final int unknown;
}

class WalletQuote {
  WalletQuote(
    this.plan,
    this.spending,
    this.estimated,
    this.day,
    this.version,
    this.model,
    this.input,
    this.maxOutput,
  );
  final WalletPlan plan;
  final WalletSpending spending;
  final double? estimated;
  final String day;
  final String? version;
  final String model;
  final int input, maxOutput;
  bool _used = false;

  double? get remaining => plan.daily == null
      ? null
      : (plan.daily! - spending.usd).clamp(0, plan.daily!).toDouble();
  bool get exhausted => remaining == 0;
  bool get nearLimit => plan.daily != null && spending.usd >= plan.daily! * .8;
  bool get budgetUncertain =>
      plan.daily != null && (spending.unknown > 0 || estimated == null);
  bool get blocked =>
      exhausted ||
      budgetUncertain ||
      (remaining != null &&
          estimated != null &&
          _exceeds(estimated!, remaining!));
  bool get automaticAllowed =>
      !blocked &&
      spending.unknown == 0 &&
      estimated != null &&
      version != null &&
      plan.daily != null &&
      plan.automatic != null &&
      plan.authorizedDay == day &&
      plan.authorizedVersion == version &&
      !_exceeds(spending.usd + estimated!, plan.automatic!) &&
      (plan.warning == null || !_exceeds(estimated!, plan.warning!));
  String? get notice {
    if (exhausted) return '今日本机预算已用完。可在消费计划调整，或等到北京时间次日。';
    if (budgetUncertain) return '无法核对今日预算剩余，已暂停请求。请查看消费记录和价格状态。';
    if (blocked) return '本轮预计费用超过今日预算剩余，已暂停请求。';
    if (spending.unknown != 0) return '今日有 ${spending.unknown} 笔未确定费用，本轮需手动确认。';
    if (estimated == null) return '价格待核实或无法估价，本轮需手动确认。';
    if (plan.warning != null && _exceeds(estimated!, plan.warning!)) {
      return '本轮预计费用超过你的单轮提醒额度。';
    }
    if (nearLimit || (remaining != null && estimated! >= remaining! * .8)) {
      return '今日消费接近本机预算。';
    }
    return null;
  }

  bool consume() {
    if (_used) return false;
    _used = true;
    return true;
  }

  static bool _exceeds(double a, double b) => a - b > 1e-12;
}

class WalletRequestBlocked implements Exception {
  const WalletRequestBlocked(this.message);
  final String message;
}
