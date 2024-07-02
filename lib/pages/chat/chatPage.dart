import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:reddit_app/models/chatRoomModel.dart';
import 'package:reddit_app/services/chat/chat_services.dart';
import 'package:reddit_app/services/posts/post_services.dart';
import 'package:universal_html/html.dart';

import 'chatRoom.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool flag = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Expanded(child: _buildUserList())],
    );
  }


  Widget _buildUserList() {
    return StreamBuilder<List<ChatRoomModel>>(
      stream: _chatServices.getChatRooms(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
              child: Icon(Icons.error));
        }
        if (snapshot.connectionState==ConnectionState.waiting) {
          return Center(
              child: LoadingAnimationWidget.dotsTriangle(
                color: const Color(0xFF000000),
                size: 50,
              ));
        }
        return ListView.builder(
          key: const ValueKey('list_view'),
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return _buildUserListItem(snapshot.data![index]);
          },
        );
      },);
  }

  Widget _buildUserListItem(ChatRoomModel document) {

    return ListTile(
      leading: CircleAvatar(
          backgroundImage: document.imageUrl.isNotEmpty ?
          NetworkImage(document.imageUrl) :
          const NetworkImage("https://media.istockphoto.com/id/1288385045/photo/snowcapped-k2-peak.jpg?b=1&s=612x612&w=0&k=20&c=e1AiD8S8C5tvF8ZA24I2Q_5myDSgLdxwU385j_yzG-0="),
          foregroundColor: Colors.blue,
          backgroundColor: Colors.transparent,
          radius: 25
      ),
      minVerticalPadding: 20,
      title: Text(document.roomName,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
      onTap: () {
        if(document.members.contains(_firebaseAuth.currentUser!.uid)) {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              ChatRoom(roomID: document.roomID, rooMName: document.roomName,)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(duration: Duration(seconds: 1), content: Text("Cannot Access Chat Room")));
        }
      },
      onLongPress: () {
        showChatDeletionMenu(context, document.roomID);
      },
    );
  }
  showChatDeletionMenu(BuildContext context, String roomID) {
    showModalBottomSheet(
        enableDrag: false,
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextButton.icon(onPressed: () {
              _chatServices.deleteChat(roomID);
              Navigator.pop(context);
            }, icon: const Icon(Icons.delete), label: const Text("Leave Room")),
          );
        });
  }


}