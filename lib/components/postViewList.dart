import 'package:flutter/material.dart';

import 'postFileIcon.dart';


class PostViewList extends StatefulWidget {
  final List<dynamic> imageUrl;
  const PostViewList({super.key, required this.imageUrl});

  @override
  State<PostViewList> createState() => _PostViewListState();
}

class _PostViewListState extends State<PostViewList> {
  final PageController _controller = PageController(viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 200,
      child: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: widget.imageUrl.length,
        itemBuilder: (BuildContext context, int index) {
          return ListenableBuilder(
              listenable: _controller,
              builder: (context, child){
                double factor = 1;
                if (_controller.position.hasContentDimensions) {
                  factor = 1 - (_controller.page! - index).abs();
                }
                return PostFileIcon(url: widget.imageUrl[index]);

              } );
        }));
  }
}
