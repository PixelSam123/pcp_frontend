import 'group.dart';

abstract class _UserBase {
  const _UserBase({required this.name});

  final String name;
}

class UserCreate extends _UserBase {
  const UserCreate({
    required super.name,
    required this.password,
  });

  final String password;
}

class UserReadBrief extends _UserBase {
  const UserReadBrief({
    required super.name,
    required this.id,
    required this.points,
    this.group,
  });

  final int id;
  final int points;
  final GroupReadBrief? group;

  factory UserReadBrief.fromJson(Map<String, dynamic> json) {
    return UserReadBrief(
      name: json['name'],
      id: json['id'],
      points: json['points'],
      group:
          json['group'] != null ? GroupReadBrief.fromJson(json['group']) : null,
    );
  }
}
