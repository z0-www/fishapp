import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../ai/application/ai_providers.dart';
import '../application/wallet_controller.dart';
import 'wallet_overlay_card.dart';

const walletLogoAsset = 'assets/branding/fish_logo.png';

/// The history viewport is already constrained by SafeArea and the composer.
class FloatingWalletBall extends ConsumerStatefulWidget {
  const FloatingWalletBall({
    super.key,
    required this.child,
    this.generating = false,
    this.upcomingNearBudget = false,
  });
  final Widget child;
  final bool generating, upcomingNearBudget;
  @override
  ConsumerState<FloatingWalletBall> createState() => _FloatingWalletBallState();
}

class _FloatingWalletBallState extends ConsumerState<FloatingWalletBall> {
  static const _diameter = 52.0;
  static const _margin = 5.0;
  bool _left = false;
  bool _positionReady = false;
  double _height = .78;
  Offset? _drag;
  final _reading = ValueNotifier(false);
  Timer? _readingTimer;

  @override
  void initState() {
    super.initState();
    unawaited(_restore());
  }

  @override
  void dispose() {
    _readingTimer?.cancel();
    _reading.dispose();
    super.dispose();
  }

  bool _trackReading(ScrollNotification notice) {
    if (notice.depth != 0) return false;
    if (notice is ScrollStartNotification) {
      _readingTimer?.cancel();
      _reading.value = true;
    }
    if (notice is ScrollEndNotification) {
      _readingTimer?.cancel();
      _readingTimer = Timer(const Duration(milliseconds: 1200), () {
        _reading.value = false;
      });
    }
    return false;
  }

  Future<void> _restore() async {
    try {
      final position = await ref.read(walletPreferencesProvider).position();
      if (!mounted) return;
      _left = position.left;
      _height = position.height;
    } catch (_) {
      // Keep the default position if local preferences cannot be read.
    }
    if (mounted) setState(() => _positionReady = true);
  }

  Future<void> _openCard() async {
    if (ref.read(apiKeyStatusProvider).asData?.value == true &&
        ref.read(deepSeekConfigProvider).permitsDirectCalls &&
        ref.read(walletBalanceProvider).asData?.value == null) {
      unawaited(ref.read(walletBalanceProvider.notifier).refresh());
    }
    await showDialog<void>(
      context: context,
      barrierColor: const Color(0x23061B32),
      builder: (dialog) => WalletOverlayCard(
        details: () {
          Navigator.pop(dialog);
          if (mounted) context.push('/usage');
        },
        plan: () {
          Navigator.pop(dialog);
          if (mounted) context.push('/wallet-plan');
        },
      ),
    );
  }

  void _dock(double width, double height) {
    final position = _drag;
    if (position == null) return;
    setState(() {
      _left = position.dx <= width / 2;
      _height = height == 0
          ? _height
          : (position.dy / height).clamp(0, 1).toDouble();
      _drag = null;
    });
    unawaited(_save());
  }

  Future<void> _save() async {
    try {
      await ref
          .read(walletPreferencesProvider)
          .setPosition(left: _left, height: _height);
    } catch (_) {
      // The active session still keeps its position.
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = ref.watch(walletVisibleProvider).asData?.value ?? false;
    return LayoutBuilder(
      builder: (context, size) {
        final show =
            visible &&
            _positionReady &&
            size.maxWidth >= _diameter + 2 * _margin &&
            size.maxHeight >= _diameter + 2 * _margin;
        final width = show ? size.maxWidth - _diameter - 2 * _margin : 0.0;
        final height = show ? size.maxHeight - _diameter - 2 * _margin : 0.0;
        final position = _drag ?? Offset(_left ? 0 : width, _height * height);
        final safe = Offset(
          position.dx.clamp(0, width).toDouble(),
          position.dy.clamp(0, height).toDouble(),
        );
        return Stack(
          fit: StackFit.expand,
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: _trackReading,
              child: widget.child,
            ),
            if (show)
              Positioned(
                left: safe.dx + _margin,
                top: safe.dy + _margin,
                width: _diameter,
                height: _diameter,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _reading,
                  builder: (context, reading, child) {
                    final active =
                        _drag != null ||
                        widget.generating ||
                        widget.upcomingNearBudget;
                    return IgnorePointer(
                      ignoring: reading && !active,
                      child: AnimatedOpacity(
                        opacity: active
                            ? 1
                            : reading
                            ? .22
                            : .8,
                        duration: MediaQuery.disableAnimationsOf(context)
                            ? Duration.zero
                            : const Duration(milliseconds: 160),
                        child: child,
                      ),
                    );
                  },
                  child: GestureDetector(
                    key: const Key('wallet-ball-drag'),
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (_) => setState(() => _drag = safe),
                    onPanUpdate: (event) =>
                        setState(() => _drag = (_drag ?? safe) + event.delta),
                    onPanEnd: (_) => _dock(width, height),
                    onPanCancel: () => setState(() => _drag = null),
                    child: _WalletButton(
                      generating: widget.generating,
                      upcomingNearBudget: widget.upcomingNearBudget,
                      onTap: _openCard,
                      onMenu: () => context.push('/wallet-plan'),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _WalletButton extends ConsumerStatefulWidget {
  const _WalletButton({
    required this.generating,
    required this.upcomingNearBudget,
    required this.onTap,
    required this.onMenu,
  });
  final bool generating, upcomingNearBudget;
  final VoidCallback onTap, onMenu;
  @override
  ConsumerState<_WalletButton> createState() => _WalletButtonState();
}

class _WalletButtonState extends ConsumerState<_WalletButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1150),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updatePulse();
  }

  @override
  void didUpdateWidget(covariant _WalletButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updatePulse();
  }

  void _updatePulse() {
    if (widget.generating &&
        !MediaQuery.disableAnimationsOf(context) &&
        TickerMode.valuesOf(context).enabled) {
      if (!pulse.isAnimating) pulse.repeat(reverse: true);
    } else {
      pulse.reset();
    }
  }

  @override
  void dispose() {
    pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plan = ref.watch(walletPlanProvider).asData?.value;
    final spending = ref.watch(walletTodayProvider).asData?.value;
    final balance = ref.watch(walletBalanceProvider);
    final daily = plan?.daily;
    final amount = spending?.usd ?? 0;
    final exhausted = daily != null && amount >= daily;
    final near =
        widget.upcomingNearBudget || (daily != null && amount >= daily * .8);
    final low = balance.asData?.value?.low ?? false;
    final (label, dot) = exhausted
        ? ('今日预算已用完', const Color(0xFFBA382E))
        : balance.hasError
        ? ('余额暂不可用', const Color(0xFF818B97))
        : low
        ? ('余额偏低', const Color(0xFFFFB66D))
        : ('', null);
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: pulse,
        child: Semantics(
          button: true,
          label: label.isEmpty ? '大肥鱼消费管家' : '大肥鱼消费管家，$label',
          child: Material(
            color: const Color(0xFFF0F7FF),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: widget.onTap,
              onLongPress: widget.onMenu,
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    walletLogoAsset,
                    width: 40,
                    height: 40,
                    cacheWidth: 160,
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
          ),
        ),
        builder: (context, child) => DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: near ? const Color(0xFFD5802B) : const Color(0xFFC3D8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1C5A91)
                    .withValues(alpha: .13 + pulse.value * .15),
                blurRadius: 5 + pulse.value * 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(padding: const EdgeInsets.all(1), child: child),
              if (dot != null)
                Positioned(
                  right: 2,
                  top: 2,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: dot,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const SizedBox(width: 10, height: 10),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
