import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/widgets/shimmer_container_widget.dart';

class YourReservationComponentsShimmerLoading extends StatelessWidget {
  const YourReservationComponentsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.black.withAlpha(16),
        highlightColor: Colors.white10,
        child: Column(
          spacing: 8,
          children: [
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: tempContainer(
                    height: 30,
                  ),
                ),
                Expanded(
                  child: tempContainer(
                    height: 30,
                  ),
                ),
                Expanded(
                  child: tempContainer(
                    height: 30,
                  ),
                ),
              ],
            ),
            const Gap(6),
            tempContainer(
              height: 50,
            ),
            tempContainer(
              height: 50,
            ),
            tempContainer(
              height: 50,
            ),
            tempContainer(
              height: 50,
            )
          ],
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