import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reddit_app/components/postViewer.dart';

class PostImagePreview extends StatefulWidget {
  final String url;
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
            builder: (context) => PostViewer(url: widget.url)));
      },
      child: SizedBox(
        width: 200,
        height: 200,
        child: PhotoView(

          backgroundDecoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
            disableGestures: true,
            filterQuality: FilterQuality.low,
            wantKeepAlive: true,
            imageProvider: NetworkImage(
                widget.url
            )
        ),
      )

    );
  }
}
