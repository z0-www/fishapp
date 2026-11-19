import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../shared/widgets/content_frame.dart';
import '../../usage/price_schedule.dart';
import '../../usage/price_schedule_provider.dart';
import '../application/wallet_controller.dart';
import '../application/wallet_limits.dart';

class WalletPlanPage extends ConsumerWidget {
  const WalletPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('消费计划')),
    body: SafeArea(
      child: ContentFrame(
        child: ref
            .watch(walletPlanProvider)
            .when(
              data: (value) => _PlanForm(initial: value),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const Center(child: Text('消费计划暂时无法读取。')),
            ),
      ),
    ),
  );
}

class _PlanForm extends ConsumerStatefulWidget {
  const _PlanForm({required this.initial});
  final WalletPlan initial;
  @override
  ConsumerState<_PlanForm> createState() => _PlanFormState();
}

class _PlanFormState extends ConsumerState<_PlanForm> {
  late final daily = TextEditingController(
    text: widget.initial.daily?.toString(),
  );
  late final warning = TextEditingController(
    text: widget.initial.warning?.toString(),
  );
  late final auto = TextEditingController(
    text: widget.initial.automatic?.toString(),
  );
  bool _automatic = false;
  bool _busy = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _automatic = widget.initial.automatic != null;
  }

  @override
  void dispose() {
    daily.dispose();
    warning.dispose();
    auto.dispose();
    super.dispose();
  }

  double? _amount(TextEditingController field) {
    final input = field.text.trim();
    if (input.isEmpty) return null;
    if (!RegExp(r'^[0-9]{1,6}(?:\.[0-9]{1,6})?$').hasMatch(input)) {
      throw const FormatException();
    }
    final value = double.parse(input);
    if (value <= 0) throw const FormatException();
    return value;
  }

  Future<void> _save() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final limit = _amount(daily), alert = _amount(warning);
      final cap = _automatic ? _amount(auto) : null;
      final config = _automatic
          ? await ref.read(walletPriceProvider.future)
          : null;
      final clock = DateTime.now();
      final day = WalletPriceSchedule.dayStart(clock).toIso8601String();
      if (!mounted) return;
      if (_automatic && (limit == null || cap == null || cap > limit)) {
        setState(() => _message = '请先设置每日预算，免确认额度须为正数且不超过每日预算。');
        return;
      }
      if (_automatic) {
        if (config == null || config.period(clock) == PricePeriod.unknown) {
          setState(() => _message = '价格待核实，暂无法授权自动确认。');
          return;
        }
        final authorized = await showDialog<bool>(
          context: context,
          builder: (dialog) => AlertDialog(
            title: const Text('授权今天免逐轮确认？'),
            content: Text(
              '北京时间今天结束前，本机今日累计已估价消费加本次预计费用在 USD $cap 内、且未触发单轮提醒时，剧情请求可直接发送。可随时撤销。'
              '\n本机预算仅用于暂停请求。DeepSeek 按实际用量扣费，本机预算无法限制账单金额。',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialog, false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialog, true),
                child: const Text('授权今日免确认'),
              ),
            ],
          ),
        );
        if (authorized != true || !mounted) return;
      }
      await ref
          .read(walletPreferencesProvider)
          .savePlan(
            WalletPlan(
              daily: limit,
              warning: alert,
              automatic: cap,
              authorizedDay: cap == null ? null : day,
              authorizedVersion: cap == null ? null : config?.version,
            ),
          );
      if (mounted) {
        ref.invalidate(walletPlanProvider);
        Navigator.pop(context);
      }
    } on FormatException {
      if (mounted) setState(() => _message = '请输入大于 0 的美元金额，最多保留六位小数。');
    } catch (_) {
      if (mounted) setState(() => _message = '消费计划未保存，请重试。');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _revoke() async {
    setState(() => _busy = true);
    try {
      final repository = ref.read(walletPreferencesProvider);
      final saved = await repository.readPlan();
      await repository.savePlan(
        WalletPlan(daily: saved.daily, warning: saved.warning),
      );
      if (mounted) {
        setState(() {
          _automatic = false;
          _message = '已撤销免确认授权。';
        });
        ref.invalidate(walletPlanProvider);
      }
    } catch (_) {
      if (mounted) setState(() => _message = '授权状态未能更新，请重试。');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _field(String label, TextEditingController controller) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextField(
      controller: controller,
      enabled: !_busy,
      maxLength: 13,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixText: 'USD ',
        counterText: '',
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      const Text(
        '今日按北京时间计算。金额依据本机收到的实际 Token 用量估算，DeepSeek 按账单结算。设有每日预算时，无法核对价格或用量会暂停请求。每日预算留空时不设本机限额。',
      ),
      const SizedBox(height: 18),
      _field('每日预算', daily),
      _field('单轮提醒额度', warning),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('授权今天免逐轮确认'),
        value: _automatic,
        onChanged: _busy
            ? null
            : (value) {
                if (!value && widget.initial.automatic != null) {
                  _revoke();
                } else {
                  setState(() => _automatic = value);
                }
              },
      ),
      if (_automatic) _field('今日免确认累计额度', auto),
      if (_message != null) Text(_message!),
      FilledButton(
        onPressed: _busy ? null : _save,
        child: const Text('保存消费计划'),
      ),
      if (widget.initial.automatic != null)
        TextButton(
          onPressed: _busy ? null : _revoke,
          child: const Text('立即撤销授权'),
        ),
    ],
  );
}
