import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../worlds/application/world_providers.dart';
import '../data/world_definition_repository.dart';

final worldDefinitionRepositoryProvider = Provider(
  (ref) => WorldDefinitionRepository(ref.watch(databaseProvider)),
);
