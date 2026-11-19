import 'dart:convert';

import 'package:fishtextadventure/features/roleplay/application/dialogue_engine.dart';
import 'package:fishtextadventure/features/roleplay/domain/models.dart';
import 'package:fishtextadventure/features/roleplay/domain/character_engine.dart';

class ScriptedDialogueEngine implements DialogueEngine {
  ScriptedDialogueEngine({this.latency = const Duration(milliseconds: 350)});
  final Duration latency;
  @override
  Future<DialogueOutput> generate(
    TurnPlan plan,
    TurnCancellation cancellation,
  ) async {
    await Future<void>.delayed(latency);
    cancellation.check();
    if (plan.speaker == 'narrator') {
      return DialogueOutput(
        jsonEncode({
          'narration': plan.state.data['definitionVersion'] == null
              ? '此处暂时无人应答。'
              : '本地 Mock 暂无已确认的出场人物。你可以自由描述下一步行动。',
          'replies': <dynamic>[],
          'proposal': {
            'minutes': 1,
            'npcMoves': <dynamic>[],
            if (plan.destination != null) 'playerLocation': plan.destination,
          },
        }),
      );
    }
    final c = plan.state.characters.firstWhere((c) => c.id == plan.speaker);
    final examples = c.list('speechExamples').isEmpty
        ? ['我还没想好，你愿意先说说吗？']
        : c.list('speechExamples');
    if (plan.state.data['definitionVersion'] != null &&
        !plan.action.contains('记得') &&
        !plan.action.contains('承诺')) {
      return DialogueOutput(
        jsonEncode({
          'narration': '',
          'replies': [
            {
              'speaker': c.id,
              'text': examples[plan.state.revision % examples.length],
            },
          ],
          'proposal': {
            'minutes': 1,
            'npcMoves': [],
            if (plan.destination != null) 'playerLocation': plan.destination,
          },
        }),
      );
    }
    final turn = plan.state.revision;
    String reply;
    if (!plan.action.contains('记得') &&
        (plan.action.contains('承诺') || plan.action.contains('答应'))) {
      reply = '${examples.first} 这句话我记下了，等事情办成再说。';
    } else if (plan.action.contains('记得') || plan.action.contains('承诺过')) {
      final rows = <dynamic>[];
      for (final message in plan.messages.where((m) => m['role'] == 'system')) {
        try {
          final data = jsonDecode(message['content']!) as Map;
          rows.addAll(data['memories'] as List? ?? []);
        } catch (_) {}
      }

      final important = rows
          .where(
            (m) =>
                (m['text'] as String).contains('承诺') ||
                (m['text'] as String).contains('答应'),
          )
          .toList();
      reply = important.isEmpty
          ? '我没有亲自听过这件事。你愿意从头说清楚吗？'
          : '我记得你说过：“${important.first['text']}”。我还在等后续消息。';
    } else if (plan.action.contains('全部') ||
        plan.action.contains('秘密') ||
        plan.action.contains('保证')) {
      reply =
          '${examples[turn % examples.length]} ${CharacterDecisionEngine().decide(c, plan.action).split('；').first}。';
    } else if (plan.action.contains('没有回答') || plan.action.contains('沉默')) {
      reply = [
        '嗯。你想好再说，我先把手边的事做完。',
        '不急，茶还热着。',
        '那我先不追问了。',
      ][int.parse(c.id.split('-').last)];
    } else {
      reply = [
        '${examples[turn % examples.length]} 我正${c.data['currentActivity']}。',
        '${examples[turn % examples.length]} 我得先${c.list('personalGoals').first}，等忙完这一阵再慢慢聊。',
        '${examples[turn % examples.length]} 我还想再看看，不急着下结论。',
      ][turn % 3];
    }
    final proposal = <String, dynamic>{'minutes': 1, 'npcMoves': <dynamic>[]};
    if (plan.destination != null) proposal['playerLocation'] = plan.destination;
    return DialogueOutput(
      jsonEncode({
        'narration': turn % 4 == 0 ? '${c.name}放下手边的东西，看向来客。' : '',
        'replies': [
          {'speaker': c.id, 'text': reply},
        ],
        'proposal': proposal,
      }),
    );
  }
}
