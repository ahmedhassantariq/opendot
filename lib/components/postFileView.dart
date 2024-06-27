

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:reddit_app/components/postImagePreview.dart';

import 'package:reddit_app/components/postViewer.dart';
import 'package:reddit_app/components/videoViewer.dart';
import 'cacheImage.dart';

class PostFileView extends StatefulWidget {
  final List<dynamic> url;
  const PostFileView({
    super.key,
    required this.url});

  @override
  State<PostFileView> createState() => _PostFileViewState();
}

class _PostFileViewState extends State<PostFileView> with TickerProviderStateMixin{



  checkType(){
    String postType = "post";
    if(widget.url.isNotEmpty) {
      String s = widget.url.first;
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.url.isNotEmpty) {
      if (checkType() == 'image') {
        return PostImagePreview(url: widget.url);
      }
      if (checkType() == 'video') {
        return VideoViewer(url: widget.url.first);
      }
      if (checkType() == 'file') {
        return IconButton(
            onPressed: () {
              // AnchorElement anchor = AnchorElement(href: widget.url.first);
              // AnchorElement
              //     .created()
              //     .download = 'File';
              // anchor.click();
            },
            icon: const Icon(Icons.download)
        );
      }
      return const SizedBox();
    }
    return const SizedBox();
  }
}
