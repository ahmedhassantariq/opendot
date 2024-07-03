
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:reddit_app/models/hubModel.dart';

class HubServices extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late List<HubModel> hubList = [];


  Future<List<HubModel>> loadHubs() async{
    Stream<QuerySnapshot> stream = _firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).collection("userHubs").snapshots();
    Stream<List<HubModel>> model = stream.map((event) => event.docs.map((e) => HubModel.fromJson(e)).toList());
    print("Hubs Loaded");
    return model.first;
  }



  List<HubModel> getHubs() {
    // Stream<QuerySnapshot> stream = _firestore.collection('posts').orderBy('uploadedOn', descending: true).snapshots();
    // Stream<List<HubModel>> model = stream.map((event) => event.docs.map((e) => HubModel.fromJson(e)).toList());
    //_firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).collection("joinedHubs").snapshots();
    print("Catching");
    if(hubList.isEmpty){
      loadHubs().then((value) => hubList = value);
      return hubList;
    } else {
      return hubList;
    }
  }

  Stream<QuerySnapshot> getUserHubs() {
    return _firestore.collection("users").doc(_firebaseAuth.currentUser!.uid).collection("userHubs")
        .snapshots();
  }

  Future<void> createHub(String hubTitle,bool isPublic) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String docID = _firestore.collection('users').doc(currentUserId).collection("userHubs").doc().id;
     _firestore.collection("users").doc(currentUserId).collection("userHubs").doc(docID).set({
      "hubID":docID,
      "createdBy":currentUserId,
      "createdOn":Timestamp.now(),
      "hubTitle":hubTitle,
      "isPublic":isPublic
    });
    notifyListeners();
  }


}