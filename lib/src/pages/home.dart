import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/avatar_widget.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/components/post_widget.dart';
import 'package:flutter_clone_instagram/src/controller/auth_controller.dart';
import 'package:flutter_clone_instagram/src/controller/home_contoller.dart';
import 'package:get/get.dart';

class Home extends GetView<HomeController> {
  const Home({Key? key}) : super(key: key);

  Widget _myStory() {
    return Column(
      children: [
        Stack(
          children: [
            AvatarWidget(
              type: AvatarType.TYPE2,
              thumbPath: AuthController.to.user.value.thumbnail!,
              size: 70,
            ),
            Positioned(
                right: 5,
                bottom: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                      border: Border.all(color: Colors.white, width: 2)),
                  child: const Center(
                    child: Text("+",
                        style: TextStyle(
                            fontSize: 14, color: Colors.white, height: 1.2)),
                  ),
                ))
          ],
        ),
        const SizedBox(height: 3),
        const Text(
          "Your story",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _storyBoardList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        const SizedBox(
          width: 20,
        ),
        _myStory(),
        const SizedBox(
          width: 5,
        ),
        ...List.generate(
            100,
            (index) => Column(
                  children: [
                    AvatarWidget(
                      thumbPath:
                          'https://thumbnails.production.thenounproject.com/Be3jJLCiGLUhX-jrVaFa0hIvfd8=/fit-in/1000x1000/photos.production.thenounproject.com/photos/6DA7172D-BF23-4022-BFE1-50E704DB30F7.jpg',
                      type: AvatarType.TYPE1,
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      "kitty",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ))
      ]),
    );
  }

  Widget _postList() {
    return Obx(
      () => Column(
        children: List.generate(controller.postList.length,
            (index) => PostWidget(post: controller.postList[index])).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: ImageData(
          IconsPath.logo,
          width: 270,
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ImageData(
                IconsPath.directMessage,
                width: 50,
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.requestNew,
        edgeOffset: 100,
        displacement: 0,
        child: ListView(
          children: [
            const SizedBox(height: 3),
            _storyBoardList(),
            _postList(),
          ],
        ),
      ),
    );
  }
}
