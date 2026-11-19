enum NarrativePerspective {
  first('第一人称 · 我', '旁白以玩家视角用“我”描述已确定的感官信息和所见场景'),
  second('第二人称 · 你', '旁白用“你”称呼玩家角色'),
  third('第三人称 · 他／她／角色名', '旁白用他、她或玩家角色名称指称玩家');

  const NarrativePerspective(this.label, this.instruction);
  final String label, instruction;
}

enum NarrativeStyle {
  novel('小说模式', '用自然的小说段落铺陈场景，细节服务剧情'),
  immersive('沉浸模式', '优先呈现当下可见的环境、感官与互动'),
  brisk('快节奏模式', '把主要进展写在前面，减少重复铺垫，长篇幅用来推进剧情');

  const NarrativeStyle(this.label, this.instruction);
  final String label, instruction;
}

class NarrativePreferences {
  const NarrativePreferences({
    this.targetWords = 800,
    this.perspective = NarrativePerspective.second,
    this.style = NarrativeStyle.novel,
  });

  static const minWords = 100;
  static const maxWords = 3000;
  static const keys = ['targetWords', 'pointOfView', 'narrationStyle'];
  final int targetWords;
  final NarrativePerspective perspective;
  final NarrativeStyle style;

  static NarrativePreferences resolve(Iterable<Map> levels) {
    var result = const NarrativePreferences();
    for (final value in levels) {
      final words = value['targetWords'];
      result = NarrativePreferences(
        targetWords: words is int
            ? words.clamp(minWords, maxWords)
            : result.targetWords,
        perspective:
            NarrativePerspective.values
                .where((v) => v.name == value['pointOfView'])
                .firstOrNull ??
            result.perspective,
        style:
            NarrativeStyle.values
                .where((v) => v.name == value['narrationStyle'])
                .firstOrNull ??
            result.style,
      );
    }
    return result;
  }

  Map<String, dynamic> toJson() => {
    'targetWords': targetWords,
    'pointOfView': perspective.name,
    'narrationStyle': style.name,
  };

  // A generous output allocation for prose, escaped characters, and the JSON
  // envelope. The budget sheet uses this same cap for the actual request.
  int get maxOutputTokens => targetWords * 2 + 512;

  String get prompt =>
      '本轮旁白与 NPC 正文合计目标约 $targetWords 字，按情节自然收束。'
      '汉字和标点各计一字，连续英文单词或数字各计一字，空白与换行不计，'
      'JSON 字段和状态提案不计。预留空间输出闭合的 JSON。'
      '${perspective.instruction}。${style.instruction}。'
      '人称仅用于旁白。NPC 台词沿用自身说话习惯和自然人称。'
      '不替玩家决定思想、感情或行动。上述本轮叙事设置优先于旧文中的篇幅、视角和风格。';

  static final _units = RegExp(
    r"[\p{Script=Latin}\p{Nd}]+(?:['’\-][\p{Script=Latin}\p{Nd}]+)*|[^\s]",
    unicode: true,
  );

  static int countWords(String text) => _units.allMatches(text).length;
}
