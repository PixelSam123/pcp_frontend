class AppSettings {
  AppSettings({
    required this.isDarkMode,
  });

  bool isDarkMode;
}

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
    required this.targetLink,
    required this.type,
  });

  final UserReadBrief user;
  final String targetLink;
  final String type;
}

class Challenge {
  const Challenge({
    required this.author,
    required this.title,
    required this.tier,
    required this.supportedLanguages,
  });

  final UserReadBrief author;
  final String title;
  final int tier;
  final List<String> supportedLanguages;
}
