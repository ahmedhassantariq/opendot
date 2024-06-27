import 'package:flutter/material.dart';
import 'package:reddit_app/components/postImagePreview.dart';
import 'package:reddit_app/components/videoViewer.dart';

import 'cacheImage.dart';

class PostFileIcon extends StatelessWidget {
  final List<dynamic> url;

  const PostFileIcon({
    super.key,
    required this.url});

  checkType(){
    String postType = "post";
    if(url.isNotEmpty) {
      String s = url.first;
      String one = s.substring(s.indexOf("/images%"), s.indexOf("?"));
      String two = one.substring(one.indexOf("."));
      switch (two) {
        case ".png":
          postType = "image";
          break;
        case ".jpg":
          postType = "image";
          break;
        case ".jpeg":
          postType = "image";
          break;
        case ".mp4":
          postType = "video";
          break;
        case ".mov":
          postType = "video";
          break;
        case ".mp3":
          postType = "video";
          break;
        case ".wav":
          postType = "video";
          break;
        default:
          postType = "file";
      }
    }
    return postType;
  }



  @override
  Widget build(BuildContext context) {
    if(checkType()=='image'){
      return PostImagePreview(url: url);
    }
    if(checkType()=='video'){
      return VideoViewer(url: url.first);
    }
    if(checkType()=='file'){
      return const Icon(Icons.file_copy_rounded);
    }
    return const SizedBox();
  }
}
