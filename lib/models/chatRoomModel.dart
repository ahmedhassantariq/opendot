import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  final String roomID;
  final String adminUID;
  final String imageUrl;
  final List<String> members;
  final String roomName;
  final Timestamp createdAt;

  const ChatRoomModel({
    required this.imageUrl,
    required this.members,
    required this.roomName,
    required this.roomID,
    required this.adminUID,
    required this.createdAt
  });

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'members': members,
      'roomName': roomName,
      'roomID': roomID,
      'adminUID': adminUID,
      'createdAt': createdAt,
    };
  }

  factory ChatRoomModel.fromJson(QueryDocumentSnapshot documentSnapshot){
    return (
        ChatRoomModel
          (
            imageUrl: documentSnapshot.get('imageUrl'),
            members:List<String>.from(documentSnapshot.get('members').map((x) => x)),
            roomName:documentSnapshot.get('roomName'),
            roomID:documentSnapshot.get('roomID'),
            adminUID: documentSnapshot.get('adminUID'),
            createdAt:documentSnapshot.get("createdAt")
        ));
  }

  factory ChatRoomModel.fromDoc(DocumentSnapshot documentSnapshot){
    return (
        ChatRoomModel
          (
            imageUrl: documentSnapshot.get('imageUrl'),
            members:List<String>.from(documentSnapshot.get('members').map((x) => x)),
            roomName:documentSnapshot.get('roomName'),
            roomID:documentSnapshot.get('roomID'),
            adminUID: documentSnapshot.get('adminUID'),
            createdAt:documentSnapshot.get("createdAt")
        ));
  }
}