import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/models/postModel.dart';
import 'package:reddit_app/pages/post/postCard.dart';
import 'package:reddit_app/services/posts/post_services.dart';
class ScrollViewPage extends StatefulWidget {
  const ScrollViewPage({
    super.key
  });

  @override
  State<ScrollViewPage> createState() => _ScrollViewPageState();
}

class _ScrollViewPageState extends State<ScrollViewPage> {
  final PostServices _postServices = PostServices();
  final StreamController<List<PostModel>> streamController = StreamController.broadcast();
  final ScrollController _scrollController = ScrollController();


  Future<void> refreshScrollView() async {
    setState(() {

    });
  }



  Future<List<PostModel>> getStream(){
    final list = _postServices.getPostData().first;
    return list;
  }
  @override
  void initState() {
    streamController.addStream(_postServices.getPostData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshScrollView,
      child: FutureBuilder<List<PostModel>>(
        future: getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          return ListView.builder(
            // prototypeItem: Text(""),
            controller: _scrollController,
            key: const ValueKey('list_view'),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return PostCard(
                key: ValueKey(items[index].postID),
                postModel: items[index],
                isProfile: false,
              );
            },
          );
        },
      ),
    );
  }
}
