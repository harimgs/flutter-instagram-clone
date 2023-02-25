import 'package:flutter_clone_instagram/src/model/post.dart';
import 'package:flutter_clone_instagram/src/repository/post_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<Post> postList = <Post>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFeedList();
  }

  void loadFeedList() async {
    postList.clear();
    var feedList = await PostRepository.loadFeedList();
    postList.addAll(feedList);
  }

  Future<void> requestNew() async {
    loadFeedList();
  }
}
