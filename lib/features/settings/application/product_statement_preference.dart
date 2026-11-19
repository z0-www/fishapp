import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../world_creator/application/providers.dart';

// A stable key for this statement, independent of build and app versions.
const productStatementPreferenceKey = 'pref-product-statement-seen';

final productStatementSeenProvider = FutureProvider<bool>((ref) async {
  final value = await ref
      .watch(worldDefinitionRepositoryProvider)
      .draft(productStatementPreferenceKey);
  return value?['seen'] == true;
});
