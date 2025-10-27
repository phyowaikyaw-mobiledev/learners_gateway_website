import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String authorName;
  final String authorEmail;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.postId,
    required this.authorName,
    required this.authorEmail,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'authorName': authorName,
      'authorEmail': authorEmail,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      authorName: map['authorName'] ?? 'Anonymous User',
      authorEmail: map['authorEmail'] ?? '',
      content: map['content'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Comment copyWith({
    String? id,
    String? postId,
    String? authorName,
    String? authorEmail,
    String? content,
    DateTime? createdAt,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      authorName: authorName ?? this.authorName,
      authorEmail: authorEmail ?? this.authorEmail,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postId, authorName: $authorName, authorEmail: $authorEmail, content: $content, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.id == id &&
        other.postId == postId &&
        other.authorName == authorName &&
        other.authorEmail == authorEmail &&
        other.content == content &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    postId.hashCode ^
    authorName.hashCode ^
    authorEmail.hashCode ^
    content.hashCode ^
    createdAt.hashCode;
  }
}