import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/models/userDataModel.dart';


import 'package:reddit_app/services/chat/chat_services.dart';
import 'package:reddit_app/services/posts/post_services.dart';

import 'chatRoom.dart';

class CreateNewChat extends StatefulWidget {
  const CreateNewChat({super.key});

  @override
  State<CreateNewChat> createState() => _CreateNewChatState();
}

class _CreateNewChatState extends State<CreateNewChat> {
  final TextEditingController _searchController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final StreamController<Stream<QuerySnapshot>> streamController = StreamController();
  final List<String> userList = [];

  @override
  void initState() {
    _searchController.addListener(() {searchUserName();});
    super.initState();
  }

  searchUserName(){
    setState(() {
      streamController.add(_chatServices.searchUserName(_searchController.text));
    });
  }

  createNewChat() async {
    final roomID = await _chatServices.getNewChatRoom();
    _chatServices.sendChatInvite(userList, roomID);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(roomID: roomID,)));
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height-76,
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.close_outlined)),
                  ],
                ),
              ),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: IconButton(onPressed: (){_searchController.clear();},icon: const Icon(Icons.search_off_outlined),),
                    suffixIcon: IconButton(onPressed: (){
                      if(userList.isNotEmpty) {
                        createNewChat();
                      }
                    }, icon: const Icon(Icons.send))
                )
              ),
              _buildUserList(),
              for(int i =0; i<userList.length; i++)
                FutureBuilder(
                    future: PostServices().getUser(userList[i]),
                    builder: (context, snapshot){
                      if(snapshot.hasError){
                        return const Icon(Icons.error_outline);
                      }
                      if(snapshot.connectionState==ConnectionState.waiting){
                        return const LinearProgressIndicator();
                      }
                      return ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(snapshot.data!.imageUrl)),
                        title: Text(snapshot.data!.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
                        trailing: IconButton(
                            onPressed: (){
                              setState(() {
                                userList.removeWhere((element) => element == snapshot.data!.uid);
                              });
                            },
                            icon: const Icon(Icons.close)
                        ),
                      );
                    })
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream:  _chatServices.searchUserName(_searchController.text),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("User not Found");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 0,);
        }
        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    if(userList.any((element) => element == document['uid']) || document['uid'] == _firebaseAuth.currentUser!.uid){
      return const SizedBox();
    }
    UserCredentialsModel model = UserCredentialsModel.fromMap(document as DocumentSnapshot<Map<String, dynamic>>);
    return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage("${document['photoUrl']}")),
        title: Text(document['userName']),
        onTap: () {
          if(userList.any((element) => element == document['uid']) || document['uid'] == _firebaseAuth.currentUser!.uid){
          } else {
            setState(() {
              userList.add(document['uid']);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(receiver: model,)));
              setState(() {

              });
            });
          }
        },
      );

  }
}
