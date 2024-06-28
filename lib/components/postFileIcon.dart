import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/components/CONSTANTS.dart';
import 'package:reddit_app/components/postImagePreview.dart';
import 'package:reddit_app/components/videoViewer.dart';

import '../models/postFileModel.dart';

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
      return Center(child: PostImagePreview(url: model.url));
    }
    if(type=='video'){
      return Center(child: VideoViewer(url: model.url));
    }
    if(type=='file'){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.attach_file),
            Text(model.name.toString()),
          ],
        ),
      );
    }
    return const SizedBox();
  }
}
