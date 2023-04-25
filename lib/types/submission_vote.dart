import 'user.dart';

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
