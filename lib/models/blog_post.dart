import 'package:cloud_firestore/cloud_firestore.dart';

class BlogPost {
  final String id;
  final String title;
  final String content;
  final String author;
  final String authorId;
  final String? imageUrl;
  final List<String> tags;
  final List<String> likes;
  final DateTime createdAt;
  final DateTime updatedAt;

  BlogPost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.authorId,
    this.imageUrl,
    required this.tags,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'authorId': authorId,
      'imageUrl': imageUrl,
      'tags': tags,
      'likes': likes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory BlogPost.fromMap(Map<String, dynamic> map) {
    return BlogPost(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      author: map['author'] ?? '',
      authorId: map['authorId'] ?? '',
      imageUrl: map['imageUrl'],
      tags: List<String>.from(map['tags'] ?? []),
      likes: List<String>.from(map['likes'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  BlogPost copyWith({
    String? title,
    String? content,
    String? author,
    String? imageUrl,
    List<String>? tags,
    List<String>? likes,
    DateTime? updatedAt,
  }) {
    return BlogPost(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      author: author ?? this.author,
      authorId: authorId,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}