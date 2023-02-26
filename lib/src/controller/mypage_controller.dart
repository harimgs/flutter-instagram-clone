import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/auth_controller.dart';
import 'package:flutter_clone_instagram/src/model/instagram_user.dart';
import 'package:flutter_clone_instagram/src/repository/post_repository.dart';
import 'package:get/get.dart';

import '../model/post.dart';

class MypageController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  Rx<IUser> targetUser = IUser().obs;
  RxList<Post> myPostList = <Post>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  void setTargetUser() {
    var uid = Get.parameters['targetUid'];
    if (uid == null) {
      targetUser(AuthController.to.user.value);
    } else {
      // TODO get other users collection using others uid
    }
  }

  void loadMyPost() async {
    myPostList.clear();
    var myFeedList = await PostRepository.loadMyPost();
    myPostList.addAll(myFeedList);
  }

  void _loadData() {
    setTargetUser();
    loadMyPost();
    // Load Account Info
  }
}
