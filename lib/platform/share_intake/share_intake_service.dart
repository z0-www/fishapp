import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../features/import_center/domain/import_models.dart';

class ShareIntakeService {
  ShareIntakeService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('fish/share_intake');
  final MethodChannel _channel;
  final _events = StreamController<void>.broadcast();
  Stream<void> get events => _events.stream;

  /// Browsers have no system share inbox. The coordinator still drains the
  /// durable local queue, so this returns an empty list instead of failing.
  bool get supported => !kIsWeb;

  void start() {
    if (!supported) return;
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'changed') _events.add(null);
    });
  }

  Future<List<IncomingShare>> pending() async {
    if (!supported) return const [];
    try {
      final rows = await _channel.invokeListMethod<dynamic>('pending') ?? [];
      return rows
          .map(
            (r) => IncomingShare.fromJson(Map<String, dynamic>.from(r as Map)),
          )
          .toList();
    } on MissingPluginException {
      throw const ImportFailure('系统分享组件不可用。');
    } on PlatformException {
      throw const ImportFailure('无法读取系统暂存区，请重试。');
    }
  }

  Future<void> acknowledge(String id, {bool keepFiles = true}) async {
    if (!supported) return;
    try {
      await _channel.invokeMethod<void>('ack', {
        'id': id,
        'keepFiles': keepFiles,
      });
    } on MissingPluginException {
      throw const ImportFailure('系统分享回执组件不可用，暂存未确认。');
    } on PlatformException {
      throw const ImportFailure('暂存交接未完成，稍后将安全重试。');
    }
  }

  void refresh() => _events.add(null);
  Future<void> dispose() async {
    if (supported) _channel.setMethodCallHandler(null);
    await _events.close();
  }
}
