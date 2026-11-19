import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../world_creator/application/providers.dart';

const globalNarrativePreferenceKey = 'preferences/narrative-v1';

final globalNarrativePreferencesProvider = FutureProvider<Map<String, dynamic>>(
  (ref) async =>
      await ref
          .watch(worldDefinitionRepositoryProvider)
          .draft(globalNarrativePreferenceKey) ??
      {},
);
