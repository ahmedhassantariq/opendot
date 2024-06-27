import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:reddit_app/components/cacheImage.dart';

class PostViewer extends StatefulWidget {
  final List<dynamic> url;
  final int currentPageIndex;
  const PostViewer({
    required this.url,
    required this.currentPageIndex,
    super.key
  });

  @override
  State<PostViewer> createState() => _PostViewerState();
}

class _PostViewerState extends State<PostViewer> {
  late String currentPage = "${widget.currentPageIndex+1}/${widget.url.length}";
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
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                pageController: PageController(initialPage: widget.currentPageIndex),
                onPageChanged: (i){setState(() {
                  currentPage = "${i+1}/${widget.url.length}";
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

            ),
              (widget.url.length>1) ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(alignment: Alignment.topRight,child: Text(currentPage,style: const TextStyle(color: Colors.white),),),
              ):const SizedBox(),

            ])
      ),
    );
  }
}
