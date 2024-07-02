import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:reddit_app/models/chatRoomModel.dart';
import '../../models/chatMessageModel.dart';

class ChatServices extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<List<ChatRoomModel>> getChatRooms() {
    String currentUserID = _firebaseAuth.currentUser!.uid;
    Stream<QuerySnapshot> snaps = _firestore.collection("users").doc(currentUserID).collection("chats").snapshots();
    Stream<List<ChatRoomModel>> model = snaps.map((event) => event.docs.map((e) => ChatRoomModel.fromJson(e)).toList());
    return model;
  }

  Stream<List<ChatMessageModel>> getChatRoomMessages(String roomID){
    Stream<QuerySnapshot> snaps = _firestore.collection('chats').doc(roomID).collection("chats").orderBy('timestamp', descending: false).snapshots();
    Stream<List<ChatMessageModel>> model = snaps.map((event) => event.docs.map((e) => ChatMessageModel.fromJson(e)).toList());
    return model;
  }


  Future<String> getNewChatRoom() async{
    String roomID = _firestore.collection('chats').doc().id;
    return roomID;
  }

  Future<void> sendChatInvite(List<String> inviteesList, String roomID) async {
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    inviteesList.add(currentUserID);
    final roomModel = ChatRoomModel(imageUrl: "", members: inviteesList, roomName: "New Chat", roomID: roomID, adminUID: currentUserID, createdAt: Timestamp.now());
    if (inviteesList.isNotEmpty) {
      _firestore.collection('chats').doc(roomID).set(roomModel.toMap());

      for (int i = 0; i < inviteesList.length; i++) {
        _firestore.collection("users").doc(inviteesList[i])
            .collection("chats")
            .doc(roomID)
            .set(roomModel.toMap());
      }
    }
  }

  Future<void> deleteChat(String roomID) async{
    await _firestore.collection('users').doc(_firebaseAuth.currentUser!.uid).collection("chats").doc(roomID).delete();
  }

  Future<void> sendMessage(String roomID, String message) async{
    final String currentUserID = _firebaseAuth.currentUser!.uid;

    String docID =  _firestore.collection("chats").doc(roomID).collection("chats").doc().id;
    ChatMessageModel messageModel = ChatMessageModel(messageID: docID,senderID: currentUserID,message:  message, isEdited: false,timestamp:  Timestamp.now(),);
    await _firestore.collection("chats").doc(roomID).collection("chats").doc(docID).set(messageModel.toMap());
  }



  Future<void> deleteMessage(String roomID, String messageID) async{
    await _firestore.collection('chats').doc(roomID).collection("chats").doc(messageID).delete();
  }

  Future<void> editMessage(String roomID, String messageID, String message) async{
    await _firestore.collection('chats').doc(roomID).collection("chats").doc(messageID).update({
          "message":message,
          "isEdited":true
        })
        .then((value) {
    });

  }

  Stream<QuerySnapshot> searchUserName(String userName) {
    return _firestore
        .collection('users')
        .where('userName', isLessThanOrEqualTo: userName)
        .snapshots();
  }

}
