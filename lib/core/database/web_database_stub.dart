import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// Native builds keep using drift_flutter's normal database path.
QueryExecutor openFishDatabase() => driftDatabase(
  name: 'fish_text_adventure',
  web: DriftWebOptions(
    sqlite3Wasm: Uri.parse('sqlite3.wasm'),
    driftWorker: Uri.parse('drift_worker.js'),
  ),
);
