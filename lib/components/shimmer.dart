import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SingleShimmer extends StatelessWidget {

  const SingleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child:  Column(
        children: [
          Flexible(
            child: Container(
              color: Colors.white,
              child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: GestureDetector(
                                        child: const Icon(Icons.menu_outlined, color: Colors.grey,)),
                                  )

                                ],
                              ),
                            ),
                          ],),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, letterSpacing: 0.5),),
                    ),
                    const SizedBox(height: 8.0),

                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(""),
                    ),
                    const SizedBox(height: 8.0),

                  ]),
            ),
          )
        ],
      )

    );
  }
}