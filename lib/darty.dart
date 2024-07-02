
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  store() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<User> users = [];
    for (int i = 0;i<20;i++){
      users.add(User(name: "$i", age: Timestamp.now().toString()));
    }
    final String encoded = User.encode(users);
    print(encoded);
    await preferences.setString("users", encoded);
    print("Stored");

  }
  get() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? usersString = await preferences.getString('users');

    print("got");
    final List<User> usersList = User.decode(usersString!);
    for (var element in usersList) {print(element.age);}

  }

  @override
  initState()  {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            TextButton.icon(onPressed: (){store();}, icon: const Icon(Icons.save), label: const Text("Save")),
            TextButton.icon(onPressed: (){get();}, icon: const Icon(Icons.download), label: const Text("Load")),
          ],
        )));
  }
}



class User {
  final String name;
  final String age;

  User({required this.name, required this.age});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        name: parsedJson['name'] ?? "",
        age: parsedJson['age'] ?? ""
    );}
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "age": age
    };
  }

  static Map<String, dynamic> toMap(User user) => {
    'name': user.name,
    'age': user.age,
  };

  static String encode(List<User> users) => json.encode(
    users.map<Map<String, dynamic>>((user) => User.toMap(user)).toList(),
  );

  static List<User> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<User>((item) => User.fromJson(item))
          .toList();

}