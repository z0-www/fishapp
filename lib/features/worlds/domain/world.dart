class World {
  const World({
    required this.id,
    required this.title,
    required this.genre,
    required this.summary,
    required this.createdAt,
  });
  final String id;
  final String title;
  final String genre;
  final String summary;
  final DateTime createdAt;
}
