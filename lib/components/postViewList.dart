import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'postFileIcon.dart';


class PostViewList extends StatefulWidget {
  final List<dynamic> imageUrl;
  const PostViewList({super.key, required this.imageUrl});

  @override
  State<PostViewList> createState() => _PostViewListState();
}

class _PostViewListState extends State<PostViewList> {
  final PageController _controller = PageController(viewportFraction: 1, keepPage: true);
  double paginationOpacity = 1.0;

  setPaginationOpacity(){
    paginationOpacity = 1.0;
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          paginationOpacity = 0.0;
        });
      });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
    });
  }
  @override
  void dispose() {
    _controller.notifyListeners();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
      height: widget.imageUrl.isNotEmpty? 200:0,
      child: PageView.builder(
        pageSnapping: true,
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
                return Stack(
                    children: [
                      PostFileIcon(url: widget.imageUrl[index]),
                      widget.imageUrl.length>1 ?
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          child: AnimatedOpacity(
                              opacity: paginationOpacity,
                              duration: const Duration(seconds: 1),
                              child: Text("${index+1}/${widget.imageUrl.length}",style: const TextStyle(color: Colors.white),)),
                        ),) :  const SizedBox()
                    ]);

              } );
        }));
  }
}
