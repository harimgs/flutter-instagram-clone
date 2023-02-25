import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/controller/upload_controller.dart';
import 'package:get/get.dart';

class UploadDescription extends GetView<UploadController> {
  const UploadDescription({Key? key}) : super(key: key);

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: Image.file(
              controller.filteredImage!,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller.textEditingController,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintText: "문구 입력...",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoOnt(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }

  Widget get line => const Divider(
        color: Color.fromARGB(255, 180, 180, 180),
      );

  Widget snsInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Facebook",
                style: TextStyle(fontSize: 17),
              ),
              Switch(value: false, onChanged: (bool value) {})
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Twitter",
                style: TextStyle(fontSize: 17),
              ),
              Switch(value: false, onChanged: (bool value) {})
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tumblr",
                style: TextStyle(fontSize: 17),
              ),
              Switch(value: false, onChanged: (bool value) {})
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: Get.back,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: ImageData(
                IconsPath.backBtnIcon,
                width: 50,
              ),
            ),
          ),
          title: const Text(
            "새 게시물",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: controller.uploadPost,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ImageData(
                  IconsPath.uploadComplete,
                  width: 60,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  controller.unfocusKeyboard();
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _description(),
                      line,
                      _infoOnt("사람 태그하기"),
                      line,
                      _infoOnt("위치 추가"),
                      line,
                      _infoOnt("다른 미디어에도 게시"),
                      snsInfo(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
