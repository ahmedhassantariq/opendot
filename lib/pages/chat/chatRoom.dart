import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:reddit_app/components/messageTextField.dart';
import 'package:reddit_app/models/chatMessageModel.dart';
import 'package:reddit_app/models/userDataModel.dart';
import 'package:reddit_app/pages/chat/videoCall/videoCallReceive.dart';
import 'package:reddit_app/pages/chat/videoCall/videoCallSend.dart';
import 'package:reddit_app/services/chat/chat_services.dart';
import 'package:reddit_app/services/notifications/notification_services.dart';

class ChatRoom extends StatefulWidget {
  final String roomID;
  final String roomName;
  const ChatRoom({
    required this.roomID,
    String rooMName = "New Room",
    super.key}): roomName = rooMName;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController _commentEditingController = TextEditingController();
  final TextEditingController _messageEditingController = TextEditingController();
  final ScrollController _controller = ScrollController();
  final FocusNode focusNode = FocusNode();
  final NotificationServices notificationServices = NotificationServices();
  bool isAtBottom = false;

  @override
  void initState() {

    super.initState();


  }

  submitMessage(){
    if(_messageEditingController.text.isNotEmpty) {
      // notificationServices.sendNotification(NotificationsModel(
      //         to: widget.receiver.uid,
      //         priority: 'high',
      //         title: 'Message',
      //         body: _messageEditingController.text,
      //         type: 'chat',
      //         id: '1',
      //         payload: '0'
      //     ));

      _chatServices.sendMessage(widget.roomID, _messageEditingController.text).then((value) => _scrollDown());
      _messageEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !isAtBottom ? Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: IconButton(onPressed: (){_scrollDown();},icon: const Icon(Icons.arrow_drop_down, color: Colors.black,),),
      ):const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        leading: IconButton(icon:const Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {Navigator.pop(context);},),
        title: Text(widget.roomName),
        actions: const [
          // IconButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoCallSend(receiver: widget.receiver)));}, icon: const Icon(Icons.video_call, color: Colors.black,)),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
              child: _buildMessageList()),
          Column(
            children: [
              MessageTextField(
                onIconPress: (){submitMessage();},
                onSubmitted: (e){
                  submitMessage();
                  },
                  controller: _messageEditingController,
                focusNode: focusNode,
                icon: const Icon(Icons.send),
              ),

            ],
          )
        ],
      ),
    );
  }

  Widget _buildMessageList(){
    return StreamBuilder<List<ChatMessageModel>>(
        stream: _chatServices.getChatRoomMessages(widget.roomID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: LoadingAnimationWidget.beat(
                  color: const Color(0xFF000000),
                  size: 50,
                ));
          }
          return ListView.builder(
            key: const ValueKey('list_view'),
            controller: _controller,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return _buildMessageItem(context, snapshot.data![index]);
            },
          );
        },);
  }

  Widget _buildMessageItem(BuildContext context, ChatMessageModel data){

    Alignment alignment = (data.senderID == FirebaseAuth.instance.currentUser!.uid)
    ?
    Alignment.bottomRight
        :
    Alignment.centerLeft;
    Color color = (data.senderID == FirebaseAuth.instance.currentUser!.uid)
    ?
        Colors.blue.shade300
    :
        Colors.green.shade300;
    Timestamp timestamp = data.timestamp;
    final time = DateFormat('hh:mm');
    final difference = DateTime.now().difference(timestamp.toDate());
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 12.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: alignment,
      child: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
        // RichText(
        //     overflow: TextOverflow.ellipsis,
        //     strutStyle: const StrutStyle(fontSize: 12.0,fontWeight: FontWeight.w600),
        //     text: TextSpan(text: data.senderID, style: const TextStyle(fontWeight: FontWeight.w600))),
        Text(time.format(timestamp.toDate()), style: const TextStyle(fontWeight: FontWeight.w600)),
          GestureDetector(
            onTap: (){
              // Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoCallReceive(receiver: widget.receiver, roomId: data['message'], isVideo: true)));
            },
              onLongPress: (){
              (difference.inDays <= 1 && _firebaseAuth.currentUser!.uid == data.senderID) ?
              showMessageMenu(data.messageID, data.message) :();
              },
            child: Container(
              key: ValueKey(data.messageID),
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(5))
                ),
                child: Text(data.message,softWrap: true,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),)),
          )
        ]),
    );
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
    );
  }



  showMessageMenu(String messageID, String message) {
    showModalBottomSheet(
        enableDrag: false,
        context: context,
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                TextButton.icon(onPressed: (){
                  Navigator.pop(context);
                  showEditingMenu(messageID, message);
                }, icon: const Icon(Icons.edit), label: const Text("Edit Comment")),
                TextButton.icon(onPressed: (){
                  _chatServices.deleteMessage(widget.roomID, messageID);
                  Navigator.pop(context);
                }, icon: const Icon(Icons.delete), label: const Text("Delete Comment")),
              ],
            ),
          );
        });

  }

  showEditingMenu(String messageID, String message) {
    submitComment(){
    if(_commentEditingController.text.isNotEmpty) {
      _chatServices.editMessage(widget.roomID, messageID, _commentEditingController.text);
      Navigator.pop(context);
      _commentEditingController.clear();
    }
  }
    _commentEditingController.text = message;
    showModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: MessageTextField(
              onIconPress: (){submitComment();},
              controller: _commentEditingController,
              focusNode: FocusNode(),
              onSubmitted: (String e) {
                submitComment();
              },
              icon: const Icon(Icons.edit),
            ),
          );
        });
  }

}



