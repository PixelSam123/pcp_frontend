import 'user.dart';

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
