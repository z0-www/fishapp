/// Small, local lexical expansion. Not an embedding/semantic model.
/// No service calls, vectors, extra fees or cross-owner retrieval.
abstract final class LocalRelevance {
  static Set<String> terms(String value) {
    final source = value.toLowerCase();
    final result = <String>{
      ...RegExp(r'[a-z0-9]{2,}').allMatches(source).map((m) => m[0]!),
    };
    for (final run in RegExp(r'[\u4e00-\u9fff]+').allMatches(source)) {
      final text = run[0]!;
      for (var i = 0; i + 1 < text.length; i++) {
        result.add(text.substring(i, i + 2));
      }
    }
    for (final group in [
      ['承诺', '答应', '约定', '守约'],
      ['书信', '回信', '来信', '信件'],
      ['失踪', '下落', '去向'],
      ['码头', '港口', '雾港'],
      ['恐惧', '害怕', '担心'],
      ['愤怒', '生气', '气愤'],
      ['喜欢', '爱慕', '倾心'],
    ]) {
      if (group.any(source.contains)) result.addAll(group);
    }
    return result;
  }

  static double score(String text, String query) {
    final a = terms(text), b = terms(query);
    if (a.isEmpty || b.isEmpty) return 0;
    return a.intersection(b).length / b.length;
  }
}
