import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class AssistanceCategoryShimmerLoading extends StatelessWidget {
  const AssistanceCategoryShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.black.withAlpha(16),
        highlightColor: Colors.white10,
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return tempContainer(
                width: double.infinity,
                height: 80
              );
            },
            separatorBuilder: (context, index) => const Gap(16),
            itemCount: 5
        ),
      ),
    );
  }


  Widget tempContainer({double? height, double? width, double? radius}) {
    return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(radius ?? 8)
        )
    );
  }
}

// Hello I am Tamim