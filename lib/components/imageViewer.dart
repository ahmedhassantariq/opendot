import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:reddit_app/components/cacheImage.dart';

class ImageViewer extends StatefulWidget {
  final String url;
  const ImageViewer({
    required this.url,
    super.key
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
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
        child: PhotoView(imageProvider: NetworkImage(widget.url))
      ),
    );
  }
}
