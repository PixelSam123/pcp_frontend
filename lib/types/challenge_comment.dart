import 'user.dart';

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
