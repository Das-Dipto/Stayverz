import 'package:flutter/material.dart';

class ImageCanvasWidget extends StatelessWidget {
  final String url;
  final double? radius, size;
  const ImageCanvasWidget({super.key, required this.url, this.radius, this.size});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 15,
      backgroundImage: NetworkImage(
        url,
        // fit: BoxFit.contain,
      ),
      onBackgroundImageError: (a,b) {

      },
      child: url.isEmpty ? Icon(
        Icons.person,
        size: size ?? 20,
      ): null,
    );
  }
}

// Hello I am Tamim