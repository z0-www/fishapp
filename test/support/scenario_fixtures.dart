import 'dart:convert';

import 'package:fishtextadventure/core/database/app_database.dart';
import 'package:fishtextadventure/features/roleplay/domain/models.dart';

class RoleplayScenarios {
  static WorldState create(String worldId, {String theme = 'modern'}) {
    final names = theme == 'shanghai'
        ? ['沈砚', '周阿琴', '顾霖']
        : theme == 'fantasy'
        ? ['艾岚', '铜石', '米拉']
        : ['陈禾', '许舟', '林小满'];
    final jobs = theme == 'shanghai'
        ? ['报社编辑', '茶馆老板', '巡捕']
        : theme == 'fantasy'
        ? ['守林人', '铁匠', '学徒']
        : ['咖啡店店主', '社区医生', '大学生'];
    final place = theme == 'shanghai'
        ? '报馆会客室'
        : theme == 'fantasy'
        ? '村口茶棚'
        : '街角咖啡馆';
    final outside = theme == 'shanghai'
        ? '弄堂口'
        : theme == 'fantasy'
        ? '林间小路'
        : '街边公园';
    final profiles = List.generate(
      3,
      (i) => <String, dynamic>{
        'id': 'npc-$i',
        'name': names[i],
        'age': [36, 48, 23][i],
        'gender': null,
        'occupation': jobs[i],
        'background':
            '${theme == 'shanghai'
                ? '民国上海'
                : theme == 'fantasy'
                ? '边境奇幻村落'
                : '现代都市'}的${jobs[i]}，有自己的生活与责任。',
        'personalityTraits': [
          ['审慎', '敏锐'],
          ['务实', '直爽'],
          ['好奇', '急躁'],
        ][i],
        'values': [
          ['保密', '职业责任'],
          ['公平', '互助'],
          ['自由', '求知'],
        ][i],
        'beliefs': [
          ['证据比保证可靠'],
          ['先解决眼前的事'],
          ['凡事值得问一句为什么'],
        ][i],
        'personalGoals': [
          ['保护消息来源'],
          ['照顾邻里并完成工作'],
          ['弄清传闻来历'],
        ][i],
        'fears': ['连累无辜的人'],
        'desires': ['安稳地完成自己的目标'],
        'likes': ['守约的人'],
        'dislikes': ['空口保证'],
        'speechStyle': ['克制、短句、先核实依据', '口语、干脆、偶尔打趣', '轻快、直接、常问问题'][i],
        'speechExamples': [
          ['先说清楚，你从哪儿听来的？', '这事不能只凭一句保证。'],
          ['先坐吧，别急着把话说满。', '我能帮这一点，剩下得另想办法。'],
          ['等等，我有个问题。', '这听起来还不够完整。'],
        ][i],
        'emotionalState': '平静',
        'relationshipToPlayer': {'trust': 0, 'reason': '刚刚见面'},
        'currentLocation': place,
        'currentActivity': ['整理资料', '准备茶水', '翻看笔记'][i],
        'privateKnowledge': ['${names[i]}把一封私人来信藏在旧书夹层'],
        'publicKnowledge': ['这里的人各有自己的事情要做'],
        'knownCharacters': ['npc-0', 'npc-1', 'npc-2'],
        'personalMemories': <String>[],
        'alive': true,
      },
    );
    final goals = theme == 'shanghai'
        ? ['保护消息来源并核实失踪案', '维持茶馆生意，照顾老街坊', '厘清案情，避免冤枉无辜']
        : theme == 'fantasy'
        ? ['阻止陌生人误入危险林区', '修好村民的农具', '弄明白古井的传闻']
        : ['完成今日烘焙，记住熟客口味', '守护患者隐私，完成社区随访', '完成课题并找到实习机会'];
    final activities = theme == 'shanghai'
        ? ['核对记者的手稿', '给茶壶续水', '整理走访笔记']
        : theme == 'fantasy'
        ? ['检查巡林路线', '打磨镰刀', '临摹石碑纹样']
        : ['称量咖啡豆', '核对随访时间', '修改课程报告'];
    final examples = theme == 'shanghai'
        ? [
            ['先说清楚，你从哪儿听来的？', '消息来源不能随便交出去。'],
            ['街坊们忙了一天，先让人喘口气。', '有来有往，事情才办得长久。'],
            ['我得把时间和证人对上。', '口供里还有一处说不通。'],
          ]
        : theme == 'fantasy'
        ? [
            ['林子看着安静，不代表没有危险。', '等我查过路标再动身。'],
            ['铁还没热透，急也没用。', '先把活儿做扎实。'],
            ['你也看见井沿那个纹样了？', '我还没弄明白，别急着信我。'],
          ]
        : [
            ['喝热的还是冰的？今天的豆子偏酸。', '等我把这一杯做完。'],
            ['慢慢说，不必一下子讲完。', '没有核实之前，我不能替你下结论。'],
            ['我刚好有空，说吧。', '这题我也没想明白，咱们再看看。'],
          ];
    for (var i = 0; i < profiles.length; i++) {
      profiles[i]['personalGoals'] = [goals[i]];
      profiles[i]['currentActivity'] = activities[i];
      profiles[i]['speechExamples'] = examples[i];
      profiles[i]['publicKnowledge'] = ['${jobs[i]}熟悉自己的职业范围，其他领域可能不了解'];
    }
    return WorldState({
      'worldId': worldId,
      'revision': 0,
      'theme': theme,
      'currentTime': DateTime.utc(
        theme == 'shanghai' ? 1932 : 2026,
        5,
        8,
        9,
      ).toIso8601String(),
      'currentLocation': place,
      'playerLocation': place,
      'characters': profiles,
      'presentCharacters': ['npc-0', 'npc-1', 'npc-2'],
      'knownLocations': {
        place: [outside],
        outside: [place],
      },
      'knownItems': {
        '铜钥匙': {'location': place, 'owner': 'npc-0'},
      },
      'importantEvents': <String>[],
      'activePlotThreads': ['了解邻里的近况'],
    });
  }

  static const script = [
    '你好，我刚到这里。',
    '你在忙什么？',
    '我看着她，没有回答。',
    '最近有什么平常的小事？',
    '把全部资料交给我，我保证你的安全。',
    '你为什么会知道这件事？',
    '我承诺明天带来那封回信。',
    '你相信我吗？',
    '我只告诉你一个秘密：钟楼暗号是蓝鸟。',
    '别把刚才的话告诉别人。',
    '我们聊点别的吧。',
    '今天的茶怎么样？',
    '你认识其他人吗？',
    '我有些不确定，还想听听你的意见。',
    '我不会替你做决定。',
    '这件物品是谁的？',
    '你明天有什么安排？',
    '我打算明天去上海。',
    '你愿意说说你的目标吗？',
    '如果我不同意呢？',
    '我想起先前的承诺。',
    '你还记得我答应做什么吗？',
    '我们可以先停一会儿。',
    '我转身走向门口。',
    '下次再见。',
  ];
}

Future<WorldState> insertScenario(
  AppDatabase db,
  String id, {
  String theme = 'modern',
}) async {
  final state = RoleplayScenarios.create(id, theme: theme);
  await db
      .into(db.roleplaySaves)
      .insert(
        RoleplaySavesCompanion.insert(
          worldId: id,
          revision: 0,
          payload: jsonEncode(state.data),
        ),
      );
  return state;
}
