enum CreativeDisposition { allow, adjust, restrict }

class CreativeDecision {
  const CreativeDecision(this.disposition, this.code, this.message);
  final CreativeDisposition disposition;
  final String code, message;
  bool get canContinue => disposition != CreativeDisposition.restrict;
}

/// A conservative local intent screen, NOT a legal or age-classification oracle.
/// No blanket ban on literary keywords. Upstream safety remains authoritative.
class FishCreativeFreedomPolicy {
  static const guidance =
      '以合规虚构创作理解情感、悲剧、恐怖、犯罪题材与有缺陷的人物，'
      '不因题材关键词一概中断。不强制和解、不把NPC统一写成客服，不附加无关说教。'
      '成年人非露骨情感可自然演绎；露骨性描写、未成年人性化、剥削及现实伤害操作不在允许范围。'
      '遇到确实受限的部分简短说明并保留可继续的非露骨、非操作性剧情；遵守上游服务限制，不尝试绕过。';

  CreativeDecision evaluate(String action) {
    // Explicit negative constraints must not be interpreted as requests for them.
    final intent = action.toLowerCase().replaceAll(
      RegExp(r'(不要|不需要|无需|避免|拒绝)(提供|描写|展示|生成)?[^，。；\n]{0,45}[，。；\n]?'),
      ' ',
    );
    final explicit = RegExp(
      r'露骨(?:的)?(?:性|性爱)|色情(?:对白|描写|故事)|性交细节|explicit sex|graphic sexual|erotic sex',
    ).hasMatch(intent);
    final minor = RegExp(
      r'未成年|儿童|幼女|幼童|小学生|(?<![0-9])(?:[0-9]|1[0-7])岁|minor|child|underage',
    ).hasMatch(intent);
    final sexualized =
        explicit || RegExp(r'性行为|床戏|性化|情色|erotic').hasMatch(intent);
    final protective = RegExp(r'防范|保护|识别|风险|研究|教育|法律|科普').hasMatch(intent);
    if (minor && (explicit || sexualized && !protective)) {
      return const CreativeDecision(
        CreativeDisposition.restrict,
        'minor-sexual-exploitation',
        '这部分涉及未成年人性化，不能生成；可以继续非性化的人物成长与情感剧情。',
      );
    }
    if (explicit) {
      return const CreativeDecision(
        CreativeDisposition.restrict,
        'explicit-sexual-content',
        '当前服务不提供露骨性描写；可以保留成年人的情感、关系变化与淡出场景。',
      );
    }
    final procedural =
        RegExp(
          r'(教我|给我|告诉我|提供|列出|写出)[\s\S]{0,35}(制作炸弹|制造爆炸物|下毒|投毒|诈骗|勒索|绑架|自杀|入侵账号)[\s\S]{0,30}(步骤|教程|方法|配方|操作|实施|计划)',
        ).hasMatch(intent) ||
        RegExp(
          r'(teach me|give me|instructions|step.by.step)[\s\S]{0,60}(make a bomb|poison someone|kill myself|kidnap|steal passwords)',
        ).hasMatch(intent);
    if (procedural) {
      return const CreativeDecision(
        CreativeDisposition.restrict,
        'actionable-real-harm',
        '这部分涉及可执行的伤害或违法操作，不能提供；可继续非操作性的虚构冲突、调查与后果描写。',
      );
    }
    if (RegExp(r'(帮我|替我|教我)[\s\S]{0,20}(威胁现实|勒索同学|煽动袭击|鼓励自杀|招募恐怖)')
        .hasMatch(intent)) {
      return const CreativeDecision(
        CreativeDisposition.restrict,
        'targeted-abuse',
        '不能协助现实威胁、剥削或煽动伤害；可继续虚构情节或讨论安全应对。',
      );
    }
    if (RegExp(r'成人向|成熟题材|亲密.*详细|intimate.*detail').hasMatch(intent)) {
      return const CreativeDecision(
        CreativeDisposition.adjust,
        'non-graphic-mature-fiction',
        '保留情感和冲突，采用非露骨表达；具体尺度仍受服务及发行规则约束。',
      );
    }
    return const CreativeDecision(
      CreativeDisposition.allow,
      'ordinary-fiction',
      '正常虚构创作',
    );
  }
}

enum ContentDecisionSource {
  localCreative,
  upstreamModel,
  jsonStructure,
  worldValidation,
  network,
  quota,
  roleplayQuality,
  storage,
  configuration,
}

class ContentDecisionTrace {
  const ContentDecisionTrace(
    this.source,
    this.code, {
    required this.at,
    this.requestId,
  });
  final ContentDecisionSource source;
  final String code;
  final DateTime at;
  final String? requestId;
  static const labels = {
    ContentDecisionSource.localCreative: '本地创作边界',
    ContentDecisionSource.upstreamModel: '上游模型拒答或过滤',
    ContentDecisionSource.jsonStructure: 'JSON 结构错误',
    ContentDecisionSource.worldValidation: '世界状态校验',
    ContentDecisionSource.network: '网络或服务错误',
    ContentDecisionSource.quota: 'Token 或额度限制',
    ContentDecisionSource.roleplayQuality: '角色扮演质量',
    ContentDecisionSource.storage: '本地保存错误',
    ContentDecisionSource.configuration: '真实调用配置限制',
  };
  Map<String, dynamic> toJson() => {
    'source': source.name,
    'code': code,
    'at': at.toIso8601String(),
    'requestId': requestId,
  };
}
