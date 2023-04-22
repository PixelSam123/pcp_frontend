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
    this.group,
  });

  final int id;
  final GroupReadBrief? group;

  factory UserReadBrief.fromJson(Map<String, dynamic> json) {
    return UserReadBrief(
      name: json['name'],
      id: json['id'],
      group:
          json['group'] != null ? GroupReadBrief.fromJson(json['group']) : null,
    );
  }
}

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

abstract class _SubmissionBase {
  const _SubmissionBase({
    required this.code,
    required this.result,
    required this.time,
    required this.memory,
  });

  final String code;
  final String result;
  final int time;
  final int memory;
}

class SubmissionCreate extends _SubmissionBase {
  const SubmissionCreate({
    required super.code,
    required super.result,
    required super.time,
    required super.memory,
    required this.userId,
    required this.challengeId,
  });

  final int userId;
  final int challengeId;
}

class SubmissionRead extends _SubmissionBase {
  const SubmissionRead({
    required super.code,
    required super.result,
    required super.time,
    required super.memory,
    required this.id,
    required this.challengeId,
    required this.user,
  });

  final int id;
  final int challengeId;
  final UserReadBrief user;

  factory SubmissionRead.fromJson(Map<String, dynamic> json) {
    return SubmissionRead(
      code: json['code'],
      result: json['result'],
      time: json['time'],
      memory: json['memory'],
      id: json['id'],
      challengeId: json['challenge_id'],
      user: UserReadBrief.fromJson(json['user']),
    );
  }
}

abstract class _SubmissionCommentBase {
  const _SubmissionCommentBase({required this.content});

  final String content;
}

class SubmissionCommentCreate extends _SubmissionCommentBase {
  const SubmissionCommentCreate({
    required super.content,
    required this.userId,
    required this.submissionId,
  });

  final int userId;
  final int submissionId;
}

class SubmissionCommentRead extends _SubmissionCommentBase {
  const SubmissionCommentRead({
    required super.content,
    required this.id,
    required this.submissionId,
    required this.user,
  });

  final int id;
  final int submissionId;
  final UserReadBrief user;

  factory SubmissionCommentRead.fromJson(Map<String, dynamic> json) {
    return SubmissionCommentRead(
      content: json['content'],
      id: json['id'],
      submissionId: json['submission_id'],
      user: UserReadBrief.fromJson(json['user']),
    );
  }
}

abstract class _SubmissionVoteBase {
  const _SubmissionVoteBase({required this.isUpvote});

  final bool isUpvote;
}

class SubmissionVoteCreate extends _SubmissionVoteBase {
  const SubmissionVoteCreate({
    required super.isUpvote,
    required this.userId,
    required this.submissionId,
  });

  final int userId;
  final int submissionId;
}

class SubmissionVoteRead extends _SubmissionVoteBase {
  const SubmissionVoteRead({
    required super.isUpvote,
    required this.id,
    required this.submissionId,
    required this.user,
  });

  final int id;
  final int submissionId;
  final UserReadBrief user;

  factory SubmissionVoteRead.fromJson(Map<String, dynamic> json) {
    return SubmissionVoteRead(
      isUpvote: json['is_upvote'],
      id: json['id'],
      submissionId: json['submission_id'],
      user: UserReadBrief.fromJson(json['user']),
    );
  }
}
