import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:reddit_app/components/postViewer.dart';

class PostImagePreview extends StatefulWidget {
  final List<dynamic> url;
  const PostImagePreview({
    super.key,
    required this.url});

  @override
  State<PostImagePreview> createState() => _PostImagePreviewState();
}

class _PostImagePreviewState extends State<PostImagePreview> {
  late String currentPage = "1/${widget.url.length}";
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => PostViewer(url: widget.url, currentPageIndex: currentPageIndex)));
      },
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: MediaQuery
                .of(context)
                .size
                .width * 9.0 / 16.0,
            child: PhotoViewGallery.builder(
                onPageChanged: (i){setState(() {
                  currentPage = "${i+1}/${widget.url.length}";
                  currentPageIndex = i;
                });},
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (context, index){
                  return PhotoViewGalleryPageOptions(
                      imageProvider: NetworkImage(widget.url[index]),
                      initialScale: PhotoViewComputedScale.contained,
                      errorBuilder: (context, obj, trace) => const Icon(Icons.error_outline)
                  );
                },
                itemCount: widget.url.length,
                loadingBuilder: (context, event) => const Center(
                  child: CircularProgressIndicator(),
                )
            )
        ),
          (widget.url.length>1) ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(alignment: Alignment.topRight,child: Text(currentPage,style: const TextStyle(color: Colors.white),),),
          ):const SizedBox()
      ]),
    );
  }
}
