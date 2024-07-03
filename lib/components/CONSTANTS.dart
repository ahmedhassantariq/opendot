import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:reddit_app/pages/chat/chatRoom.dart';

class Constants {

  checkType(url){
    String postType = "post";
    if(url!=null) {

      switch (url.toLowerCase()) {
        case "png":
          postType = "image";
          break;
        case "jpg":
          postType = "image";
          break;
        case "jpeg":
          postType = "image";
          break;
        case "mp4":
          postType = "video";
          break;
        case "mov":
          postType = "video";
          break;
        case "mp3":
          postType = "video";
          break;
        case "wav":
          postType = "video";
          break;



        default:
          postType = "file";
      }
    }
    return postType;
  }


  toTime(Timestamp timestamp){
    final now = Timestamp.now();
    DateTime dateTime1 = DateTime.parse(now.toDate().toString());
    DateTime dateTime2 = DateTime.parse(timestamp.toDate().toString());
    final difference = dateTime1.difference(dateTime2); // or in whatever format you want.
    if(difference.inSeconds<60){
      return "${difference.inSeconds} s";
    }
    if(difference.inSeconds<3600){
      return "${difference.inMinutes} m";
    }
    if(difference.inSeconds<86400){
      return "${difference.inHours} h";
    }
    if(difference.inSeconds<2592000){
      return "${difference.inDays} d";
    }
    if(difference.inSeconds<=(31104000)){
      return "${(difference.inDays/30).floor() } months";
    }
    if(difference.inSeconds>(31104000)){
      return "${((difference.inDays/30).floor()/12).floor() } y";
    }
    return "";


  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }



}