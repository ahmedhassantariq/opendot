import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reddit_app/components/postViewer.dart';

class PostImagePreview extends StatefulWidget {
  final String _url;
  final double _width;
  final double _height;
  const PostImagePreview(
      {super.key, double width = 0, double height = 0, required String url}):
        _url= url, _width = width, _height=height;

  @override
  State<PostImagePreview> createState() => _PostImagePreviewState();
}

class _PostImagePreviewState extends State<PostImagePreview> {
  late String currentPage = "1/${widget._url.length}";
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => PostViewer(url: widget._url)));
      },
      child: SizedBox(
        width: widget._width!=0 ? widget._width : MediaQuery.of(context).size.width,
        height: widget._height!=0 ? widget._height : MediaQuery.of(context).size.height,
        child: PhotoView(
            backgroundDecoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8.0)),
            disableGestures: true,
            filterQuality: FilterQuality.low,
            wantKeepAlive: true,
            imageProvider: NetworkImage(
                widget._url
            )
        ),
      )

    );
  }
}
