import 'user.dart';

abstract class _SubmissionBase {
  const _SubmissionBase({
    required this.code,
  });

  final String code;
}

class SubmissionCreate extends _SubmissionBase {
  const SubmissionCreate({
    required super.code,
    required this.userId,
    required this.challengeId,
  });

  final int userId;
  final int challengeId;
}

class SubmissionRead extends _SubmissionBase {
  const SubmissionRead({
    required super.code,
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
      id: json['id'],
      challengeId: json['challenge_id'],
      user: UserReadBrief.fromJson(json['user']),
    );
  }
}
