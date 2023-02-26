import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/message_popup.dart';
import 'package:flutter_clone_instagram/src/controller/auth_controller.dart';
import 'package:flutter_clone_instagram/src/controller/home_contoller.dart';
import 'package:flutter_clone_instagram/src/controller/mypage_controller.dart';
import 'package:flutter_clone_instagram/src/model/post.dart';
import 'package:flutter_clone_instagram/src/pages/upload/upload_description.dart';
import 'package:flutter_clone_instagram/src/repository/post_repository.dart';
import 'package:flutter_clone_instagram/src/utils/data_util.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as image_lib;
import 'package:photofilters/photofilters.dart';

class UploadController extends GetxController {
  var albums = <AssetPathEntity>[];
  RxString headerTitle = "".obs;
  RxList<AssetEntity> imageList = <AssetEntity>[].obs;
  TextEditingController textEditingController = TextEditingController();
  Rx<AssetEntity> selectedImage = const AssetEntity(
    id: "",
    typeInt: 0,
    width: 0,
    height: 0,
  ).obs;
  File? filteredImage;
  Post? post;

  @override
  void onInit() {
    super.onInit();
    post = Post.init(AuthController.to.user.value);
    _loadPhotos();
  }

  @override
  void onClose() async {
    super.onClose();
    Get.put(HomeController()).loadFeedList();
    Get.put(MypageController()).loadMyPost();
  }

  void _loadPhotos() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        filterOption: FilterOptionGroup(
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(minHeight: 100, minWidth: 100),
          ),
          orders: [
            const OrderOption(type: OrderOptionType.createDate, asc: false),
          ],
        ),
      );
      _loadData();
    } else {
      // message
    }
  }

  void _loadData() async {
    changeAlbums(albums.first);
    // update();
  }

  Future<void> _pagingPhotos(AssetPathEntity album) async {
    imageList.clear();
    var photos = await album.getAssetListPaged(page: 0, size: 30);
    imageList.addAll(photos);
    changeSelectedImage(imageList.first);
  }

  changeSelectedImage(AssetEntity image) {
    selectedImage(image);
  }

  void changeAlbums(AssetPathEntity album) async {
    headerTitle(album.name);
    await _pagingPhotos(album);
  }

  void goToImageFilter() async {
    var file = await selectedImage.value.file;
    var fileName = basename(file!.path);

    var image = image_lib.decodeImage(file.readAsBytesSync());
    image = image_lib.copyResize(image!, width: 600);
    var imagefile = await Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => PhotoFilterSelector(
          title: const Text("Photo Filter Example"),
          image: image!,
          filters: presetFiltersList,
          filename: fileName,
          loader: const Center(child: CircularProgressIndicator()),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      filteredImage = imagefile['image_filtered'];
      Get.to(() => const UploadDescription());
    }
  }

  void unfocusKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void uploadPost() {
    unfocusKeyboard();
    String filename = DataUtil.makeFilePath();
    var task = uploadFile(
        filteredImage!, '${AuthController.to.user.value.uid}/$filename');
    if (task != null) {
      task.snapshotEvents.listen(
        (event) async {
          if (event.bytesTransferred == event.totalBytes &&
              event.state == TaskState.success) {
            var downloadUrl = await event.ref.getDownloadURL();
            var updatedPost = post!.copyWith(
              thumbnail: downloadUrl,
              description: textEditingController.text,
            );
            _submitPost(updatedPost);
          }
        },
      );
    }
  }

  UploadTask uploadFile(File file, String filename) {
    var ref = FirebaseStorage.instance.ref().child("posts").child(filename);
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );
    return ref.putFile(file, metadata);
  }

  void _submitPost(Post postData) async {
    await PostRepository.updatePost(postData);

    showDialog(
      context: Get.context!,
      builder: (context) => MessagePopup(
        title: 'Post',
        message: 'Post was successful!',
        okCallback: () {
          Get.until((route) => Get.currentRoute == '/');
        },
      ),
    );
  }
}
