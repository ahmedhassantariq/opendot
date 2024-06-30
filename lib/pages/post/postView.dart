import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_app/components/commentTextfield.dart';
import 'package:reddit_app/components/shimmer.dart';
import 'package:reddit_app/models/commentModel.dart';
import 'package:reddit_app/models/postModel.dart';
import 'package:reddit_app/components/postViewList.dart';
import 'package:reddit_app/pages/post/comment/commentCard.dart';
import 'package:reddit_app/pages/drawer/endDrawer.dart';
import 'package:reddit_app/pages/post/postUpdatePage.dart';
import 'package:reddit_app/pages/post/sharePostPage.dart';
import 'package:reddit_app/services/posts/post_services.dart';
import '../../components/CONSTANTS.dart';
import '../profile/bottomProfileModal.dart';




class PostView extends StatefulWidget {
  final PostModel postModel;
  const PostView({
    super.key,
    required this.postModel,
  });

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final TextEditingController _searchQueryController = TextEditingController();
  final TextEditingController _commentTextFieldController = TextEditingController();

  final StreamController<Stream<List<CommentModel>>> streamController = StreamController();
  final PostServices _postServices = PostServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isSearching = false;
  String searchQuery = "Search query";
  @override
  void initState() {
    super.initState();
    _searchQueryController.addListener(() {searchComment();});
  }

  searchComment(){
    setState(() {
      streamController.add(_postServices.searchComment(widget.postModel.postID,_searchQueryController.text));
    });
  }

  Future<void> refreshPost() async{
    setState(() {

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      endDrawer: const EndDrawer(),
      appBar: AppBar(

        leading: _isSearching ? const BackButton() : IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back)),
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
      ),
      body: RefreshIndicator(
        onRefresh: refreshPost,
        child: FutureBuilder(
            future: _postServices.getUser(widget.postModel.uploadedBy) ,
            builder: (builder, snapshot){
              if(snapshot.hasError){
                return const Icon(Icons.error);
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return const SingleShimmer();
              }
              return GestureDetector(
                onLongPress: (){showPostPopUpMenu();},
                child: Column(
                  children: [
                    Flexible(
                      child: Container(
                        color: Colors.white,
                        child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              Container(
                                color: Colors.white,
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
                                            Row(
                                                children: [
                                                  CircleAvatar(
                                                      backgroundImage: NetworkImage(snapshot.data!.imageUrl),
                                                      foregroundColor: Colors.blue,
                                                      backgroundColor: Colors.transparent,
                                                      radius: 15
                                                  ),
                                                  const SizedBox(width: 8.0),
                                                  Text(snapshot.data!.userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                                                  const SizedBox(width: 8.0),
                                                  Text((Constants().toTime(widget.postModel.uploadedOn)), style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                                                ]),
                                            IconButton(
                                                onPressed: () {showPostPopUpMenu();  },
                                                icon: const Icon(Icons.more_horiz, color: Colors.grey,))

                                          ],
                                        ),
                                      ),
                                    ],),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(widget.postModel.postTitle.toString(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, letterSpacing: 0.5),),
                              ),
                              const SizedBox(height: 8.0),

                              PostViewList(imageUrl: widget.postModel.imageUrl),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                                child: Text(widget.postModel.postDescription.toString()),
                              ),
                              const SizedBox(height: 8.0),
                              StreamBuilder<List<CommentModel>>(
                                stream: _postServices.getCommentData(widget.postModel.postID),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return CommentCard(commentModel: snapshot.data![index],);
                                      },
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return const Align(alignment: Alignment.center, child: Text('Error Loading Comment'));
                                  } else {
                                    return const SizedBox(height: 0);
                                  }
                                },
                              ),
                            ]),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.all(8.0),
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        height: 50,
        notchMargin: 2.0,
        elevation: 0.5,
          child: CommentTextField(
            onTap: (){showCommentMenu();},
            readOnly: true,
            controller: _commentTextFieldController, hintText: 'Add a comment',)
          )
      );
  }

  showCommentMenu() {
    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        showDragHandle: true,
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CommentTextField(controller: _commentTextFieldController, hintText: "Add a comment", readOnly: false,),
                    ),
                    const Divider(color: Colors.grey,thickness: 0.2,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.keyboard, color: Colors.grey,),
                              const Icon(Icons.add_link, color: Colors.grey),
                              const Icon(Icons.gif_box_outlined, color: Colors.grey),
                              GestureDetector(
                                onTap: (){},
                                  child: const Icon(Icons.photo_outlined, color: Colors.grey))
                            ],
                          ),
                          TextButton(
                            onPressed: (){
                              if(_commentTextFieldController.text.isNotEmpty) {
                                _postServices.createComment(widget.postModel.postID,
                                    _commentTextFieldController.text,
                                );
                                Navigator.pop(context);
                                _commentTextFieldController.clear();
                               Provider.of<PostServices>(context, listen: false).notifyListeners();
                               setState(() {

                               });
                              }
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                                shape:RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )
                            ),
                            child: const Text("Reply", style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.grey,
              )
            ],
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
                                _postServices.deletePost(widget.postModel.postID, widget.postModel.uploadedBy).then((value)
                                {
                                  Provider.of<PostServices>(context, listen: false).notifyListeners();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });

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
                            ),
                          ]) : const SizedBox(height: 0,width: 0),
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
              child: UpdatePostPage(postModel: widget.postModel,));
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


  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  Widget _buildTitle(BuildContext context){
    return const Text("");
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      // IconButton(icon: const Icon(Icons.search), onPressed: _startSearch,),
      // IconButton(onPressed: (){showSharePostMenu();}, icon: const Icon(CupertinoIcons.share)),


    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        ?.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;

    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
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
}









