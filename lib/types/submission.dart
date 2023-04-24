import 'user.dart';

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
