import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:reddit_app/components/CONSTANTS.dart';
import 'package:reddit_app/components/cacheImage.dart';
import 'package:reddit_app/components/postFileIcon.dart';
import 'package:reddit_app/models/postModel.dart';
import 'package:reddit_app/components/postViewList.dart';
import 'package:reddit_app/pages/post/postUpdatePage.dart';
import 'package:reddit_app/pages/post/postView.dart';
import 'package:reddit_app/pages/post/sharePostPage.dart';
import 'package:reddit_app/pages/profile/bottomProfileModal.dart';
import 'package:reddit_app/services/posts/post_services.dart';
import '../../components/postActions.dart';




class PostCard extends StatefulWidget {
  final PostModel postModel;
  final bool isProfile;
  const PostCard({
    super.key,
    required this.isProfile,
    required this.postModel,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with AutomaticKeepAliveClientMixin{
  final PostServices _postServices = PostServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _postServices.getUser(widget.postModel.uploadedBy),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const SizedBox(height: 0);
        }
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(child: Text(""));
        }
      return GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context)=> PostView(
              postModel: widget.postModel,

        )));},
        child: Card(
          key: widget.key,
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              GestureDetector(
                onTap: (){showUserProfile();},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !widget.isProfile ?
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundImage: snapshot.data!.imageUrl !=null ?
                            NetworkImage(snapshot.data!.imageUrl) :
                            const NetworkImage("https://media.istockphoto.com/id/1288385045/photo/snowcapped-k2-peak.jpg?b=1&s=612x612&w=0&k=20&c=e1AiD8S8C5tvF8ZA24I2Q_5myDSgLdxwU385j_yzG-0="),
                            foregroundColor: Colors.blue,
                            backgroundColor: Colors.transparent,
                            radius: 15
                        ),
                        const SizedBox(width: 8.0),
                        snapshot.data!.userName != null ?
                        Text(snapshot.data!.userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))
                        :
                        const SizedBox(),
                        const SizedBox(width: 8.0),
                        Text((Constants().toTime(widget.postModel.uploadedOn)), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),

                      ],
                    ): const SizedBox(),
                    IconButton(
                        onPressed: () {showPostPopUpMenu();  },
                        icon: const Icon(Icons.more_horiz, color: Colors.grey,))
                  ],
                ),
              ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0),
                    Text(widget.postModel.postTitle.toString(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, letterSpacing: 0.5),),
                    const SizedBox(height: 8.0),
                    widget.postModel.imageUrl.isNotEmpty ?
                    PostViewList(imageUrl: widget.postModel.imageUrl)
                    :
                    const SizedBox(),
                    const SizedBox(height: 8.0),
                    Text(widget.postModel.postDescription.toString()),
                    const SizedBox(height: 8.0),
                  ],
                ),

                // PostActions(postID: widget.postModel.postID),

        ],),
          ),
        ),
      );
  });
  }


  showPostPopUpMenu() {
    showModalBottomSheet(
        enableDrag: true,
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: [
                    widget.postModel.uploadedBy==_firebaseAuth.currentUser!.uid ?
                        Column(
                          children: [
                          TextButton.icon(
                            style: TextButton.styleFrom(alignment: Alignment.centerLeft,padding: const EdgeInsets.symmetric(vertical: 15.0)),
                            icon: const Icon(Icons.delete_outline, color: Colors.black,),
                            onPressed: (){
                              _postServices.deletePost(widget.postModel.postID, widget.postModel.uploadedBy);
                              Provider.of<PostServices>(context, listen: false).notifyListeners();
                              Navigator.pop(context);
                            },
                            label: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.9),
                              child: const Text("Delete Post", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(alignment: Alignment.centerLeft,padding: const EdgeInsets.symmetric(vertical: 15.0)),
                            icon: const Icon(Icons.update_outlined, color: Colors.black,),
                            onPressed: (){
                              Navigator.pop(context);
                              showPostUpdateMenu();
                            },
                            label: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.9),
                              child: const Text("Update Post", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                            ),
                          )
                        ],) : const SizedBox(height: 0,width: 0),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(alignment: Alignment.centerLeft,padding: const EdgeInsets.symmetric(vertical: 15.0)),
                        icon: const Icon(Icons.share, color: Colors.black,),
                        onPressed: (){
                          Navigator.pop(context);
                          showSharePostMenu();
                        },
                        label: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.9),
                          child: const Text("Share Post", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    )
                  ],
                )
              ),
            ],
          );
        });
  }

  showPostUpdateMenu() {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              child: UpdatePostPage(postModel: widget.postModel));
        });
  }

  showUserProfile() {
    showModalBottomSheet<dynamic>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(8.0),
              physics: const ScrollPhysics(),
              child: BottomProfileModal(uploadedBy: widget.postModel.uploadedBy));
        });
  }

  showSharePostMenu() {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const ScrollPhysics(),
              child: SharePost(postModel: widget.postModel));
        });
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

