import 'models.dart';
import 'local_relevance.dart';

class MemoryEngine {
  List<PersonalMemory> retrieve(
    List<PersonalMemory> rows,
    String owner,
    String topic,
    int turn, {
    int limit = 6,
  }) {
    double score(PersonalMemory m) =>
        m.importance * 3 +
        LocalRelevance.score(m.text, topic) * 40 +
        4 / (1 + (turn - m.turn).abs()) -
        (turn - m.lastUsed < 3 ? 15 : 0);
    final eligible = rows.where((m) => m.owner == owner).toList()
      ..sort((a, b) => score(b).compareTo(score(a)));
    return eligible.take(limit).toList();
  }
}
