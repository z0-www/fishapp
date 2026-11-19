import 'models.dart';

class RoleplayExpressionHints {
  Map<String, dynamic> build(CharacterProfile c, String action, int revision) =>
      {
        'speaker': c.id,
        'currentEmotion': c.data['emotionalState'],
        'relationship': c.data['relationshipToPlayer'],
        'interpretation': '结合玩家原话和既有关系理解潜台词，不诊断或替玩家确定内心。',
        'stance': '由价值观、目标、利益和经历决定态度；可以拒绝、怀疑或沉默，不为独立而无故反对。',
        'expression': '沿用此人的语言习惯，避免重复最近台词；无需每次解释动机或总结道理。',
        'emotionalCue':
            RegExp(
              r'难过|伤心|失落|哭|低落|sad|lonely',
              caseSensitive: false,
            ).hasMatch(action)
            ? '注意情绪线索，按此人性格回应；不强制安慰、接触或和解。'
            : RegExp(
                r'喜欢|想念|拥抱|爱你|kiss|miss you',
                caseSensitive: false,
              ).hasMatch(action)
            ? '结合关系与同意边界回应亲近；不能自动提升关系或替玩家确认感情。'
            : '根据当下情境自然回应，可简短，不必制造冲突。',
        'rhythm': '允许动作、停顿与留白，角色也有眼前事务。',
      };
}

/// Non-blocking local hints, never a paid retry or a substitute response.
class RoleplayQualityChecker {
  List<String> assess(DialoguePacket packet, List<Map<String, String>> recent) {
    final result = <String>[];
    final text = [
      packet.narration,
      ...packet.replies.map((r) => r['text'] as String),
    ].join('\n');
    if (RegExp(r'作为(?:一个)?AI|请问还有什么(?:可以|需要)帮助|祝你生活愉快').hasMatch(text)) {
      result.add('assistant-persona');
    }
    for (final reply in packet.replies) {
      final line = (reply['text'] as String).trim();
      if (line.length >= 8 &&
          recent
              .where((m) => m['role'] == 'assistant')
              .any((m) => m['content']!.contains(line))) {
        result.add('repeated-line');
        break;
      }
    }
    return result;
  }
}
