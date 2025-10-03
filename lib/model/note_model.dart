class NotesModel {
  String id;
  String title;
  String content;
  String category;
  DateTime createdAt;
  DateTime modifiedAt;
  List<String> tags;

  NotesModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    DateTime? createdAt,
    DateTime? modifiedAt,
    List<String>? tags,
  })  : createdAt = createdAt ?? DateTime.now(),
        modifiedAt = modifiedAt ?? (createdAt ?? DateTime.now()),
        tags = tags ?? [];

  factory NotesModel.fromJson(Map<String, dynamic> j) {
    return NotesModel(
      id: j['id'] as String,
      title: j['title'] as String,
      content: j['content'] as String,
      category: j['category'] as String,
      createdAt: DateTime.parse(j['createdAt'] as String),
      modifiedAt: DateTime.parse(j['modifiedAt'] as String),
      tags: (j['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'category': category,
        'createdAt': createdAt.toIso8601String(),
        'modifiedAt': modifiedAt.toIso8601String(),
        'tags': tags,
      };
}
