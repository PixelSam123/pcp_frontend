class AppSettings {
  const AppSettings({
    required this.isDarkMode,
    required this.serverUrl,
  });

  final bool isDarkMode;
  final String serverUrl;
}

abstract class _UserBase {
  const _UserBase({required this.name});

  final String name;
}

class UserReadBrief extends _UserBase {
  const UserReadBrief({
    required super.name,
    required this.group,
    required this.points,
  });

  final String group;
  final int points;
}

class UserRead extends UserReadBrief {
  UserRead({
    required super.name,
    required super.group,
    required super.points,
    required this.completedChallengesCount,
    required this.rank,
  });

  final int completedChallengesCount;
  final int rank;
}

class UserCreate extends _UserBase {
  const UserCreate({
    required super.name,
    required this.password,
  });

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
