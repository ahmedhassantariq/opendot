import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reddit_app/pages/post/comment/commentCard.dart';

class CommentModel {

  final String postID;
  final String commentID;
  final String comment;
  final String uploadedBy;
  final Timestamp uploadedOn;
  final int upVotes;
  final int downVotes;
  final User? currentUser;

  const CommentModel({
   required this.postID,
   required this.commentID,
   required this.comment,
   required this.uploadedBy,
   required this.uploadedOn,
   required this.upVotes,
   required this.downVotes,
   required this.currentUser,
});


  factory CommentModel.fromJson(QueryDocumentSnapshot documentSnapshot){
    return (CommentModel(
      postID: documentSnapshot.get('postID'),
      commentID: documentSnapshot.get('commentID'),
      comment: documentSnapshot.get('comment'),
      uploadedBy: documentSnapshot.get('uploadedBy'),
      uploadedOn: documentSnapshot.get('uploadedOn'),
      upVotes: documentSnapshot.get('upVotes'),
      downVotes: documentSnapshot.get('downVotes'),
      currentUser: documentSnapshot.get('currentUser'),
    ));
  }
}