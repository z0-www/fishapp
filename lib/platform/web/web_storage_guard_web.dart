import 'dart:js_interop';

import 'package:web/web.dart' as web;

bool get available => true;

bool get isSecureContext => web.window.isSecureContext;

Future<bool> isPersisted() async {
  try {
    final storage = web.window.navigator.storage;
    return (await storage.persisted().toDart).toDart;
  } catch (_) {
    return false;
  }
}

Future<bool> requestPersist() async {
  try {
    return (await web.window.navigator.storage.persist().toDart).toDart;
  } catch (_) {
    return false;
  }
}

Future<int?> quotaBytes() async {
  try {
    final estimate = await web.window.navigator.storage.estimate().toDart;
    return estimate.quota;
  } catch (_) {
    return null;
  }
}

Future<int?> usageBytes() async {
  try {
    final estimate = await web.window.navigator.storage.estimate().toDart;
    return estimate.usage;
  } catch (_) {
    return null;
  }
}
