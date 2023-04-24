import 'user.dart';

abstract class _ChallengeBase {
  const _ChallengeBase({
    required this.name,
    required this.tier,
  });

  final String name;
  final int tier;
}

class ChallengeCreate extends _ChallengeBase {
  const ChallengeCreate({
    required super.name,
    required super.tier,
    required this.userId,
    required this.description,
    required this.initialCode,
    required this.testCase,
  });

  final int userId;
  final String description;
  final String initialCode;
  final String testCase;
}

class ChallengeReadBrief extends _ChallengeBase {
  const ChallengeReadBrief({
    required super.name,
    required super.tier,
    required this.id,
    required this.user,
  });

  final int id;
  final UserReadBrief user;

  factory ChallengeReadBrief.fromJson(Map<String, dynamic> json) {
    return ChallengeReadBrief(
      name: json['name'],
      tier: json['tier'],
      id: json['id'],
      user: UserReadBrief.fromJson(json['user']),
    );
  }
}

class ChallengeRead extends ChallengeReadBrief {
  const ChallengeRead({
    required super.name,
    required super.tier,
    required super.id,
    required super.user,
    required this.description,
    required this.initialCode,
  });

  final String description;
  final String initialCode;

  factory ChallengeRead.fromJson(Map<String, dynamic> json) {
    return ChallengeRead(
      name: json['name'],
      tier: json['tier'],
      id: json['id'],
      user: UserReadBrief.fromJson(json['user']),
      description: json['description'],
      initialCode: json['initial_code'],
    );
  }
}

abstract class _ChallengeCommentBase {
  const _ChallengeCommentBase({required this.content});

  final String content;
}

class ChallengeCommentCreate extends _ChallengeCommentBase {
  const ChallengeCommentCreate({
    required super.content,
    required this.userId,
    required this.challengeId,
  });

  final int userId;
  final int challengeId;
}

class ChallengeCommentRead extends _ChallengeCommentBase {
  const ChallengeCommentRead({
    required super.content,
    required this.id,
    required this.challengeId,
    required this.user,
  });

  final int id;
  final int challengeId;
  final UserReadBrief user;

  factory ChallengeCommentRead.fromJson(Map<String, dynamic> json) {
    return ChallengeCommentRead(
      content: json['content'],
      id: json['id'],
      challengeId: json['challenge_id'],
      user: UserReadBrief.fromJson(json['user']),
    );
  }
}

abstract class _ChallengeVoteBase {
  const _ChallengeVoteBase({required this.isUpvote});

  final bool isUpvote;
}

class ChallengeVoteCreate extends _ChallengeVoteBase {
  const ChallengeVoteCreate({
    required super.isUpvote,
    required this.userId,
    required this.challengeId,
  });

  final int userId;
  final int challengeId;
}

class ChallengeVoteRead extends _ChallengeVoteBase {
  const ChallengeVoteRead({
    required super.isUpvote,
    required this.id,
    required this.challengeId,
    required this.user,
  });

  final int id;
  final int challengeId;
  final UserReadBrief user;

  factory ChallengeVoteRead.fromJson(Map<String, dynamic> json) {
    return ChallengeVoteRead(
      isUpvote: json['is_upvote'],
      id: json['id'],
      challengeId: json['challenge_id'],
      user: UserReadBrief.fromJson(json['user']),
    );
  }
}
