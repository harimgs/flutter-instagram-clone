import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/controller/auth_controller.dart';
import 'package:flutter_clone_instagram/src/model/instagram_user.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatefulWidget {
  final String uid;
  const SignupPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? thumbnailXFile;

  void update() => setState(() {});

  Widget _avatar() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: SizedBox(
            width: 100,
            height: 100,
            child: thumbnailXFile != null
                ? Image.file(File(thumbnailXFile!.path), fit: BoxFit.cover)
                : Image.asset("assets/images/default_image.png",
                    fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () async {
            thumbnailXFile = await _picker.pickImage(
              source: ImageSource.gallery,
              imageQuality: 50,
            );
            update();
          },
          child: const Text("Change Image"),
        )
      ],
    );
  }

  Widget _nickname() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        controller: nicknameController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          hintText: "Nickname",
        ),
      ),
    );
  }

  Widget _description() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        controller: descriptionController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          hintText: "Description",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Sing Up",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            _avatar(),
            const SizedBox(height: 30),
            _nickname(),
            const SizedBox(height: 30),
            _description(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          child: ElevatedButton(
            onPressed: () {
              //validation required
              var signupUser = IUser(
                uid: widget.uid,
                nickname: nicknameController.text,
                description: descriptionController.text,
              );
              AuthController.to.singup(signupUser, thumbnailXFile);
            },
            child: const Text("Sign Up"),
          )),
    );
  }
}
