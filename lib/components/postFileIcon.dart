import 'package:flutter/material.dart';
import 'package:reddit_app/components/CONSTANTS.dart';
import 'package:reddit_app/components/postImagePreview.dart';
import 'package:reddit_app/components/videoViewer.dart';

import '../models/postFileModel.dart';
import 'cacheImage.dart';

class PostFileIcon extends StatelessWidget {
  final Map<String, dynamic> url;

  const PostFileIcon({
    super.key,
    required this.url});




  @override
  Widget build(BuildContext context) {
      final model  = PostFileModel.fromJson(url);
      final type = Constants().checkType(model.extension);
    if(type=='image'){
      return PostImagePreview(url: model.url);
    }
    if(type=='video'){
      return VideoViewer(url: model.url);
    }
    if(type=='file'){
      return const Icon(Icons.file_copy_rounded);
    }
    return const SizedBox();
  }
}
