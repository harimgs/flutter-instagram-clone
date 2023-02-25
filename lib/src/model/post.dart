import 'package:flutter_clone_instagram/src/model/instagram_user.dart';

class Post {
  final String? id;
  final String? thumbnail;
  final String? description;
  final int? likeCount;
  final IUser? userInfo;
  final String? uid;
  final DateTime? createAt;
  final DateTime? updateAt;
  final DateTime? deletedAt;

  Post({
    this.id,
    this.thumbnail,
    this.description,
    this.likeCount,
    this.userInfo,
    this.uid,
    this.createAt,
    this.updateAt,
    this.deletedAt,
  });

  factory Post.init(IUser userInfo) {
    var Time = DateTime.now();
    return Post(
      thumbnail: '',
      userInfo: userInfo,
      uid: userInfo.uid,
      description: '',
      createAt: Time,
      updateAt: Time,
    );
  }

  factory Post.fromJson(String docId, Map<String, dynamic> json) {
    return Post(
      id: json['id'] == null ? '' : json['id'] as String,
      thumbnail: json['thumbnail'] == null ? '' : json['thumbnail'] as String,
      description:
          json['description'] == null ? '' : json['description'] as String,
      likeCount: json['likeCount'] == null ? 0 : json['likeCount'] as int,
      userInfo:
          json['userInfo'] == null ? null : IUser.fromJson(json['userInfo']),
      uid: json['uid'] == null ? '' : json['uid'] as String,
      createAt:
          json['createAt'] == null ? DateTime.now() : json['createAt'].toDate(),
      updateAt:
          json['updateAt'] == null ? DateTime.now() : json['updateAt'].toDate(),
      deletedAt: json['deletedAt'] == null ? null : json['deletedAt'].toDate(),
    );
  }

  Post copyWith({
    String? id,
    String? thumbnail,
    String? description,
    int? likeCount,
    IUser? userInfo,
    String? uid,
    DateTime? createAt,
    DateTime? updateAt,
    DateTime? deletedAt,
  }) {
    return Post(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      likeCount: likeCount ?? this.likeCount,
      userInfo: userInfo ?? this.userInfo,
      uid: uid ?? this.uid,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'description': description,
      'likeCount': likeCount,
      'userInfo': userInfo?.toMap(),
      'uid': uid,
      'createAt': createAt,
      'updateAt': updateAt,
      'deletedAt': deletedAt,
    };
  }
}
