import 'package:flutter/material.dart';
import 'package:flutter_clone_instagram/src/components/image_data.dart';
import 'package:flutter_clone_instagram/src/components/post_widget.dart';
import 'package:flutter_clone_instagram/src/controller/bottom_nav_contoller.dart';
import 'package:flutter_clone_instagram/src/model/post.dart';

class MyPostPage extends StatefulWidget {
  final List<Post> post;
  final int currentIndex;
  const MyPostPage({Key? key, required this.post, required this.currentIndex})
      : super(key: key);

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  final ScrollController _controller = ScrollController();
  final GlobalKey itemKey = GlobalKey();
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox itemRenderBox =
          itemKey.currentContext!.findRenderObject() as RenderBox;
      final appBarHeight = MediaQuery.of(context).padding.top + kToolbarHeight;
      final position = itemRenderBox.localToGlobal(Offset(0, -appBarHeight));
      _controller.animateTo(position.dy,
          duration: const Duration(microseconds: 1), curve: Curves.easeIn);
      _controller.addListener(() {
        setState(() {
          opacity = 1;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: BottomNavContoller.to.willPopAction,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ImageData(IconsPath.backBtnIcon),
          ),
        ),
        title: const Text(
          "Posts",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Opacity(
        opacity: opacity,
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.post.length,
                itemBuilder: (BuildContext context, int index) {
                  return PostWidget(
                    post: widget.post[index],
                    key: index == widget.currentIndex
                        ? itemKey
                        : null, // Replace 50 with the desired index
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
