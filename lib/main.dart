import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'platform/web/boot_trace_stub.dart'
    if (dart.library.js_interop) 'platform/web/boot_trace_web.dart';

void main() {
  bootStage('dart-main-start');
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    bootStage('flutter-error', details.exception.runtimeType.toString());
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    bootStage('platform-error', error.runtimeType.toString());
    return false;
  };
  runApp(const ProviderScope(child: FishApp()));
  bootStage('runapp-called');
}
