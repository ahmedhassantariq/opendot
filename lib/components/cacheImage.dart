import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheImage extends StatefulWidget {
  final String imageUrl;
  const CacheImage({
    required this.imageUrl,
    super.key
  });

  @override
  State<CacheImage> createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        imageUrl: widget.imageUrl,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.low,
        placeholder: (context, url) => const SizedBox(height: 0, width: 0,),
        errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined));
  }
}


