import 'dart:convert';

import '../../roleplay/domain/models.dart';

class DefinitionFailure implements Exception {
  const DefinitionFailure(this.message);
  final String message;
  @override
  String toString() => message;
}

class WorldDefinition {
  WorldDefinition(Map<String, dynamic> value)
    : data = jsonDecode(jsonEncode(value)) as Map<String, dynamic>;
  static const fields = [
    'id',
    'title',
    'description',
    'genreTags',
    'era',
    'calendarSystem',
    'worldDateTime',
    'startingLocation',
    'playerProfile',
    'worldRules',
    'characterProfiles',
    'locationProfiles',
    'relationships',
    'narrativePreferences',
    'openingScene',
    'customFields',
    'createdAt',
    'updatedAt',
    'schemaVersion',
  ];
  final Map<String, dynamic> data;
  String get id => data['id'] as String;
  String get title => data['title'] as String? ?? '';
  String? text(String key) => data[key] as String?;
  List<Map<String, dynamic>> entries(String key) => (data[key] as List? ?? [])
      .map((v) => Map<String, dynamic>.from(v as Map))
      .toList();
  List<CharacterProfile> get characterProfiles =>
      entries('characterProfiles').map(CharacterProfile.new).toList();
  Map<String, dynamic> toJson() => {
    for (final field in fields) field: data[field],
  };
  WorldDefinition copy() => WorldDefinition(toJson());
  factory WorldDefinition.empty(String id) => WorldDefinition({
    'id': id,
    'schemaVersion': 1,
    'title': '',
    for (final key in fields.where(
      (k) => !['id', 'schemaVersion', 'title'].contains(k),
    ))
      key: null,
  });
  void validate() {
    if (data['schemaVersion'] != 1 ||
        !RegExp(r'^[A-Za-z0-9-]{1,100}$').hasMatch(id)) {
      throw const DefinitionFailure('设定版本或编号无效。');
    }
    if (title.trim().isEmpty && (text('description') ?? '').trim().isEmpty) {
      throw const DefinitionFailure('请填写世界名称或背景。');
    }
    for (final key in [
      'title',
      'description',
      'era',
      'calendarSystem',
      'worldDateTime',
      'startingLocation',
      'openingScene',
    ]) {
      final v = data[key];
      if (v != null && (v is! String || v.length > 20000)) {
        throw const DefinitionFailure('文字设定格式或长度不合适。');
      }
    }
    for (final key in [
      'worldRules',
      'characterProfiles',
      'locationProfiles',
      'relationships',
    ]) {
      if (data[key] != null &&
          (data[key] is! List || (data[key] as List).length > 100)) {
        throw const DefinitionFailure('列表格式或数量超过限制。');
      }
    }
    for (final key in [
      'playerProfile',
      'customFields',
      'narrativePreferences',
    ]) {
      if (data[key] != null && data[key] is! Map) {
        throw const DefinitionFailure('补充设定格式无效。');
      }
    }
    if (data['genreTags'] != null &&
        (data['genreTags'] is! List ||
            (data['genreTags'] as List).any((t) => t is! String))) {
      throw const DefinitionFailure('世界类型标签格式无效。');
    }
    for (final key in ['characterProfiles', 'locationProfiles']) {
      final ids = <String>{};
      for (final item in entries(key)) {
        if (item['id'] is! String || !ids.add(item['id'] as String)) {
          throw const DefinitionFailure('人物或地点编号重复。');
        }
        if (item['name'] != null && item['name'] is! String) {
          throw const DefinitionFailure('人物或地点名称格式无效。');
        }
        if (key == 'characterProfiles') {
          if (item['relationshipToPlayer'] != null &&
              (item['relationshipToPlayer'] is! Map ||
                  ((item['relationshipToPlayer'] as Map)['trust'] != null &&
                      (item['relationshipToPlayer'] as Map)['trust']
                          is! int))) {
            throw const DefinitionFailure('人物关系格式无效。');
          }
          for (final flag in ['presentAtOpening', 'alive']) {
            if (item[flag] != null && item[flag] is! bool) {
              throw const DefinitionFailure('人物状态格式无效。');
            }
          }
          for (final k in [
            'personalityTraits',
            'values',
            'beliefs',
            'personalGoals',
            'fears',
            'desires',
            'likes',
            'dislikes',
            'speechExamples',
            'privateKnowledge',
            'publicKnowledge',
            'knownCharacters',
            'personalMemories',
          ]) {
            if (item[k] != null &&
                (item[k] is! List ||
                    (item[k] as List).any((s) => s is! String))) {
              throw const DefinitionFailure('人物列表设定格式无效。');
            }
          }
          for (final k in [
            'occupation',
            'background',
            'speechStyle',
            'emotionalState',
            'currentLocation',
            'currentActivity',
          ]) {
            if (item[k] != null && item[k] is! String) {
              throw const DefinitionFailure('人物文字设定格式无效。');
            }
          }
        }
      }
    }
    for (final r in entries('worldRules')) {
      if (!['fact', 'preference', 'open'].contains(r['kind']) ||
          r['text'] is! String) {
        throw const DefinitionFailure('世界规则需要分类和文字。');
      }
    }
    for (final l in entries('locationProfiles')) {
      if (l['connections'] != null &&
          (l['connections'] is! List ||
              (l['connections'] as List).any((v) => v is! String))) {
        throw const DefinitionFailure('地点关系格式无效。');
      }
    }
    if (WorldDefinitionExchange.containsCredential(data)) {
      throw const DefinitionFailure('请移除 API Key 或授权信息，世界设定不能包含这些凭据。');
    }
    if (utf8.encode(jsonEncode(toJson())).length > 512 * 1024) {
      throw const DefinitionFailure('设定超过大小限制，请精简后重试。');
    }
  }
}

class WorldDefinitionExchange {
  static bool containsCredential(Object? value) {
    if (value is Map) {
      return value.entries.any(
        (e) =>
            [
              'apikey',
              'api_key',
              'authorization',
              'access_token',
            ].contains(e.key.toString().toLowerCase()) ||
            containsCredential(e.value),
      );
    }
    if (value is List) return value.any(containsCredential);
    return value is String &&
        RegExp(r'(sk-[A-Za-z0-9_-]{20,}|Bearer\s+[A-Za-z0-9_-]{16,})')
            .hasMatch(value);
  }

  static String encode(WorldDefinition definition) {
    definition.validate();
    return jsonEncode({
      'format': 'fish-world-definition',
      'version': 1,
      'definition': definition.toJson(),
    });
  }

  static WorldDefinition decode(String encoded) {
    if (utf8.encode(encoded).length > 512 * 1024) {
      throw const DefinitionFailure('设定内容过大。');
    }
    try {
      final map = jsonDecode(encoded) as Map<String, dynamic>;
      if (map['format'] != 'fish-world-definition' || map['version'] != 1) {
        throw const FormatException();
      }
      final data = Map<String, dynamic>.from(map['definition'] as Map);
      if (data.keys.any((k) => !WorldDefinition.fields.contains(k))) {
        throw const FormatException();
      }
      final result = WorldDefinition(data);
      result.validate();
      return result;
    } on DefinitionFailure {
      rethrow;
    } catch (_) {
      throw const DefinitionFailure('这不是可识别的鱼者世界设定，原有世界未修改。');
    }
  }
}
