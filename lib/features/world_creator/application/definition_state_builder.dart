import '../../roleplay/domain/models.dart';
import '../data/world_definition_repository.dart';

class DefinitionStateBuilder {
  WorldState build(DefinitionVersion version) {
    final d = version.definition;
    final location = d.text('startingLocation') ?? '';
    final characters = d.characterProfiles.map((c) {
      final data = c.toJson();
      final specified = data['currentLocation'] as String?;
      final present = data['presentAtOpening'] == true;
      data['currentLocation'] = specified ?? (present ? location : '');
      data['locationUnspecified'] = specified == null && !present;
      return data;
    }).toList();
    final graph = <String, List<String>>{};
    for (final l in d.entries('locationProfiles')) {
      final name = l['name'] as String? ?? '';
      if (name.isNotEmpty) {
        graph[name] = (l['connections'] as List? ?? []).cast<String>();
      }
    }
    if (location.isNotEmpty) graph.putIfAbsent(location, () => []);
    return WorldState({
      'worldId': d.id,
      'revision': 0,
      'definitionVersion': version.version,
      'definitionSnapshot': d.toJson(),
      'currentTime': DateTime.utc(1970).toIso8601String(),
      'elapsedMinutes': 0,
      'worldDateTimeLabel': d.text('worldDateTime'),
      'calendarSystem': d.text('calendarSystem'),
      'currentLocation': location,
      'playerLocation': location,
      'playerProfile': d.data['playerProfile'],
      'characters': characters,
      'presentCharacters': characters
          .where(
            (c) =>
                c['locationUnspecified'] != true &&
                c['currentLocation'] == location,
          )
          .map((c) => c['id'])
          .toList(),
      'knownLocations': graph,
      'knownItems': <String, dynamic>{},
      'importantEvents': <String>[],
      'activePlotThreads': <String>[],
      'worldRules': d.entries('worldRules'),
      'openingScene': d.text('openingScene'),
    });
  }
}
