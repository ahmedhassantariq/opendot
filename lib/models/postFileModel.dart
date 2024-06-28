import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostFileModel {
  String url;
  String name;
  String extension;


  PostFileModel({
    required this.url,
    required this.name,
    required this.extension,
  });


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'extension': extension,
    };
  }

  factory PostFileModel.fromJson (Map<String, dynamic> parsedJson){
    return PostFileModel(
        url: parsedJson['url'].toString(),
        name : parsedJson['name'].toString(),
        extension: parsedJson['extension'].toString()
    );
  }
}