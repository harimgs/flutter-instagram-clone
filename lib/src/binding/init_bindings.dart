import 'package:flutter_clone_instagram/src/controller/auth_controller.dart';
import 'package:flutter_clone_instagram/src/controller/bottom_nav_contoller.dart';
import 'package:flutter_clone_instagram/src/controller/home_contoller.dart';
import 'package:flutter_clone_instagram/src/controller/mypage_controller.dart';
import 'package:get/get.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(BottomNavContoller(), permanent: true);
  }

  static additionalBinding() {
    Get.put(MypageController(), permanent: true);
    Get.put(HomeController(), permanent: true);
  }
}
