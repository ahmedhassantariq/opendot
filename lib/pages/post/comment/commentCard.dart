import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_app/models/commentModel.dart';
import 'package:reddit_app/services/posts/post_services.dart';
import '../../../components/CONSTANTS.dart';
import '../../profile/bottomProfileModal.dart';

class CommentCard extends StatefulWidget {
  final CommentModel commentModel;

  const CommentCard({
    required this.commentModel,
    super.key
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final PostServices _postServices = PostServices();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _postServices.getUser(widget.commentModel.uploadedBy),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return commentData();
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const SizedBox(height: 0);
        }
        return commentData(username: snapshot.data!.userName,imageUrl: snapshot.data!.imageUrl);
      }
    );
  }

  Widget commentData({String username="Deleted", String imageUrl="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcQaRhuEQm6mjc-kljLYsvJy3lg-7MbrolTZJ6GpScv7LD5g7uN6G-NPTzoPIHG3OrurivlQEduoDKPmUOtYss4"}) {
    return Container(
      color: Colors.grey[200],
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  showUserProfile();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          backgroundColor: Colors.transparent,
                          radius: 15
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        username,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        (Constants().toTime(widget.commentModel.uploadedOn)),
                        style: const TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                    ]),
                    IconButton(
                        onPressed: () {
                          showCommentPopUpMenu();
                        },
                        icon: const Icon(
                          Icons.more_horiz_outlined,
                          color: Colors.grey,
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Text(widget.commentModel.comment),
              const SizedBox(height: 8.0),
              // CommentActions(
              //     postID: widget.postID,
              //     commentID: widget.commentID,
              //     votes: widget.upVotes),
            ],
          ),
        ),
      ),
    );
  }

  showCommentPopUpMenu() {
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
                      widget.commentModel.uploadedBy == widget.commentModel.currentUser!.uid
                      ? TextButton.icon(
                          style: TextButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0)),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            _postServices.deleteComment(widget.commentModel.postID,
                                widget.commentModel.commentID, widget.commentModel.uploadedBy);
                            Provider.of<PostServices>(context, listen: false)
                                .notifyListeners();
                            Navigator.pop(context);
                          },
                          label: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.9),
                            child: const Text("Delete Comment",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                          ),
                        )
                      : const SizedBox(height: 0, width: 0)
                ],
              )),
            ],
          );
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
              child: BottomProfileModal(uploadedBy: widget.commentModel.uploadedBy));
        });
  }
}
