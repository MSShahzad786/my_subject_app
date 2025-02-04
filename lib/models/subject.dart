class Subject {
  final String id;
  final String name;
  bool isPinned;

  Subject({
    required this.id,
    required this.name,
    this.isPinned = false,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        id: json['id'],
        name: json['name'],
        isPinned: json['isPinned'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'isPinned': isPinned,
      };
}
