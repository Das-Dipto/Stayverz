import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerContainerWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  const ShimmerContainerWidget({super.key, this.height, this.width, this.radius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: Colors.white10,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(radius ?? 8)
        )
      ),
    );
  }
}

// Hello I am Tamim