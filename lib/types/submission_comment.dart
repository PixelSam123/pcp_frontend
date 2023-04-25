import 'user.dart';

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
