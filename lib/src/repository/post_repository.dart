import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_clone_instagram/src/controller/auth_controller.dart';
import 'package:flutter_clone_instagram/src/model/post.dart';

class PostRepository {
  static Future<void> updatePost(Post postData) async {
    await FirebaseFirestore.instance.collection("posts").add(postData.toMap());
  }

  static Future<List<Post>> loadFeedList() async {
    var document = FirebaseFirestore.instance
        .collection("posts")
        .orderBy('createAt', descending: true)
        .limit(30);
    var data = await document.get();
    return data.docs.map<Post>((e) => Post.fromJson(e.id, e.data())).toList();
  }

  static Future<List<Post>> loadMyPost() async {
    var document = FirebaseFirestore.instance
        .collection("posts")
        .orderBy('createAt', descending: true)
        .where("uid", isEqualTo: AuthController.to.user.value.uid);
    var data = await document.get();
    return data.docs.map<Post>((e) => Post.fromJson(e.id, e.data())).toList();
  }
}
