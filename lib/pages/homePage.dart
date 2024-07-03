import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import 'package:reddit_app/pages/drawer/endDrawer.dart';
import 'package:reddit_app/pages/scrollView.dart';
import 'package:reddit_app/services/hub/hub_services.dart';
import 'package:reddit_app/services/notifications/notification_services.dart';
import 'package:reddit_app/services/posts/post_services.dart';
import '../services/firebase/firebase_services.dart';
import 'chat/chatPage.dart';
import 'chat/createNewChat.dart';
import 'post/createPostPage.dart';
import 'drawer/frontDrawer.dart';
import 'inboxPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationServices notificationServices = NotificationServices();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final HubServices _hubServices = HubServices();
  int currentIndex = 0;

  onTapped(int index){
    if(currentIndex==0&&index==0){
      setState(() {

      });
    }
    setState(() {
      if(index==2){
        showPostMenu();
      } else {
        currentIndex = index;
      }
    });
  }

  final List<String> _appbarHeading = [
    'PC',
    'Internet',
    '',
    'Chat',
    'Inbox'
  ];

  final List<Widget> _widgets = [
    const ScrollViewPage(),
    Container(),
    const CreatePostPage(),
    const ChatPage(),
    const Inbox(),
  ];

  @override
  void initState() {
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.getDeviceToken();
    notificationServices.isTokenRefresh();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
     appBar: _appBar(),
     drawer: const FrontDrawer(),
     endDrawer: const EndDrawer(),
     body: Stack(children:[
       IndexedStack(index: currentIndex,children: _widgets)]
     ),

     bottomNavigationBar: BottomNavigationBar(
         onTap: onTapped ,
         currentIndex: currentIndex,
         type: BottomNavigationBarType.fixed,
         selectedItemColor: Colors.black,
         unselectedItemColor: Colors.grey,
         showUnselectedLabels: true,
         items:  const [
           BottomNavigationBarItem(icon: Icon(Icons.home_outlined, color: Colors.grey,), label: "Home", activeIcon: Icon(Icons.home)),
           BottomNavigationBarItem(icon: Icon(CupertinoIcons.globe), label: "Internet", activeIcon: Icon(CupertinoIcons.globe)),
           BottomNavigationBarItem(icon: Icon(Icons.add_outlined), label: "Create", activeIcon: Icon(Icons.add)),
           BottomNavigationBarItem(icon: Icon(Icons.chat_outlined), label: "Chat", activeIcon: Icon(Icons.chat)),
           BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined, color: Colors.grey), label: "Inbox", activeIcon: Icon(Icons.notifications)),
         ]),

    );
  }

  showPostMenu() {
    showModalBottomSheet(
      isScrollControlled: true,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return const SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
              child: CreatePostPage());
        });
      }

  showNewChatMenu() {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: false,
        context: context,
        builder: (BuildContext context) {
          return const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: CreateNewChat());
        });
  }



  PreferredSizeWidget _appBar() {
    List<Widget> list = [
      const SizedBox(height: 0,width: 0,),
      const SizedBox(height: 0,width: 0,),
      const SizedBox(height: 0,width: 0,),
      IconButton(padding: const EdgeInsets.symmetric(horizontal: 18.0),onPressed: (){showNewChatMenu();}, icon: const Icon(Icons.chat)),
      IconButton(padding: const EdgeInsets.symmetric(horizontal: 18.0),onPressed: (){FirebaseServices().deleteAllNotifications();}, icon: const Icon(CupertinoIcons.back)),
    ];

    Widget _buildActions() {
      return list[currentIndex];
    }
    return AppBar(
      title: Text(_appbarHeading[currentIndex].toString(), style: const TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        _buildActions(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: (){_scaffoldKey.currentState!.openEndDrawer();},
            icon: const Icon(Icons.person),
          ),
        )
      ],
    );




  }
}




