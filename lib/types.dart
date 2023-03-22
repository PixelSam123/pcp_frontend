abstract class _UserBase {
  const _UserBase({required this.name});

  final String name;
}

class UserReadBrief extends _UserBase {
  const UserReadBrief({
    required String name,
    required this.group,
    required this.points,
  }) : super(name: name);

  final String group;
  final int points;
}

class UserCreate extends _UserBase {
  const UserCreate({
    required String name,
    required this.password,
  }) : super(name: name);

  final String password;
}

class Activity {
  const Activity({
    required this.user,
    required this.description,
  });

  final UserReadBrief user;
  final String description;
}
