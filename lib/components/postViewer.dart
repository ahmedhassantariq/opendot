import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:reddit_app/components/cacheImage.dart';

class PostViewer extends StatefulWidget {
  final List<dynamic> url;
  const PostViewer({
    required this.url,
    super.key
  });

  @override
  State<PostViewer> createState() => _PostViewerState();
}

class _PostViewerState extends State<PostViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.close,color: Colors.white,)),
        actions: const [Icon(Icons.bookmark_border_outlined)],
      ),
      body: Center(
          child: PhotoViewGallery.builder(
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
    );
  }
}