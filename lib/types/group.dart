abstract class _GroupBase {
  const _GroupBase({required this.name});

  final String name;
}

class GroupCreate extends _GroupBase {
  GroupCreate({required super.name});
}

class GroupReadBrief extends _GroupBase {
  GroupReadBrief({
    required super.name,
    required this.id,
  });

  final int id;

  factory GroupReadBrief.fromJson(Map<String, dynamic> json) {
    return GroupReadBrief(
      name: json['name'],
      id: json['id'],
    );
  }
}
