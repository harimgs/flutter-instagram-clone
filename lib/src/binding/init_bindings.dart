import 'package:flutter_clone_instagram/src/controller/auth_controller.dart';
import 'package:flutter_clone_instagram/src/controller/bottom_nav_contoller.dart';
import 'package:flutter_clone_instagram/src/controller/home_contoller.dart';
import 'package:flutter_clone_instagram/src/controller/mypage_controller.dart';
import 'package:get/get.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavContoller(), permanent: true);
    Get.put(AuthController());
  }

  static additionalBinding() {
    Get.put(MypageController());
    Get.put(HomeController());
  }
}
