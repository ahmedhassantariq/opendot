import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String messageID;
  final String senderID;
  final String message;
  final bool isEdited;
  final Timestamp timestamp;

  const ChatMessageModel({
    required this.messageID,
    required this.senderID,
    required this.message,
    required this.isEdited,
    required this.timestamp,});


  Map<String, dynamic> toMap() {
    return {
      'messageID': messageID,
      'senderID': senderID,
      'message': message,
      'timestamp': timestamp,
      'isEdited':isEdited,
    };
  }

  factory ChatMessageModel.fromJson(QueryDocumentSnapshot documentSnapshot){
    return (
        ChatMessageModel
          (
            messageID: documentSnapshot.get('messageID'),
            message:documentSnapshot.get('message'),
            timestamp:documentSnapshot.get('timestamp'),
            senderID:documentSnapshot.get('senderID'),
            isEdited: documentSnapshot.get('isEdited'),
    ));
  }
}