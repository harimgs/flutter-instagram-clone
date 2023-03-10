import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/binding/init_bindings.dart';
import 'package:flutter_clone_instagram/src/model/instagram_user.dart';
import 'package:flutter_clone_instagram/src/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController with StateMixin {
  static AuthController get to => Get.find();

  Rx<IUser> user = IUser().obs;

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      Get.deleteAll();
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {}
  }

  Future<IUser?> loginUser(String uid) async {
    //DB Query
    change(null, status: RxStatus.loading());
    var userData = await UserRepository.loginUserByUid(uid);
    if (userData != null) {
      user(userData);
      InitBinding.additionalBinding();
    }
    change(null, status: RxStatus.success());
    return userData;
  }

  void singup(IUser signupUser, XFile? thumbnail) async {
    if (thumbnail == null) {
      _submitSignup(signupUser);
    } else {
      // fil ext validation needed

      var task = uploadXFile(thumbnail,
          '${signupUser.uid}/profile.${thumbnail.path.split('.').last}');
      task.snapshotEvents.listen((event) async {
        if (event.bytesTransferred == event.totalBytes &&
            event.state == TaskState.success) {
          var downloadUrl = await event.ref.getDownloadURL();
          // signupUser.thumbnail = downloadUrl;
          var updatedUserData = signupUser.copyWith(thumbnail: downloadUrl);
          _submitSignup(updatedUserData);
        }
      });
    }
  }

  UploadTask uploadXFile(XFile file, String filename) {
    var f = File(file.path);
    var ref = FirebaseStorage.instance.ref().child("users").child(filename);
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': file.path},
    );
    return ref.putFile(f, metadata);

    //users/{uid}/prfoile.jpg or profile.png
  }

  void _submitSignup(IUser signupUser) async {
    var result = await UserRepository.singup(signupUser);
    if (result) {
      loginUser(signupUser.uid!);
    }
  }
}
