import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Records an initialization stage in the HTML boot trace.
///
/// Only stage names/timings are recorded. Callers must never pass API keys,
/// chat text or world content here.
void bootStage(String name, [String detail = '']) {
  try {
    final boot = globalContext.getProperty<JSObject?>('fishBoot'.toJS);
    if (boot == null) return;
    boot.callMethod<JSAny?>('stage'.toJS, name.toJS, detail.toJS);
  } catch (_) {
    // Diagnostics must never make startup fail.
  }
}
