import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../generated/assets.dart';

class CurvedGallery extends StatefulWidget {
  final List<String> containerColors;
  final Function(int)? onImageClick;
  final VoidCallback? onSeeAllTab;

  const CurvedGallery({super.key, required this.containerColors, this.onImageClick, this.onSeeAllTab});
  @override
  _CurvedGalleryState createState() => _CurvedGalleryState();
}

class _CurvedGalleryState extends State<CurvedGallery> {
  // Use a list of colors to represent your gallery items

  // viewportFraction determines the size of the *main* item relative to the PageView's width.
  // 0.7 means 70% of the viewport width is taken by the current page, leaving 30% for others.
  final PageController _pageController = PageController(viewportFraction: 0.4);

  Widget _buildItem(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double diff = 0.0;

        if (_pageController.position.haveDimensions) {
          // Calculate the position difference relative to the center page
          // This will be 0 for the center item, -1 for the item to its left, 1 for its right.
          diff = index - (_pageController.page ?? 0);
        }

        // Clamp the difference so transformations stop growing infinitely once the card is far off-screen.
        // This ensures items that are way off-screen don't have extreme values that cause glitches.
        final t = diff.clamp(-1.0, 1.0);

        // 1. Scale: Item scales down as it moves away from the center
        // 1.0 at center, 0.8 at the edge (t.abs() is 0 for center, 1 for edge)
        final scale = 0.8 - (t.abs() * 0.1);

        // 2. Rotation: Item rotates as it moves away from the center
        // Using t * -0.1 radians for a subtle tilt (~5.7 degrees) which creates the "curved" look.
        // Negative for items to the left, positive for items to the right.
        final rotation = t * 0.2;

        // You can also add a vertical offset for a more pronounced curve effect
        // final double offsetY = t.abs() * 20.0; // Pushes side items slightly down

        return Padding(
          // Use symmetric padding for consistent spacing
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: rotation,
              child: InkWell(
                onTap: () => widget.onImageClick == null ? null : widget.onImageClick!(index),
                child: Container(
                  // CRITICAL ADJUSTMENT: Change the aspect ratio from square/wide to tall
                  height: 150, // Making the height significantly larger
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8, // Increased blur for a softer shadow
                        offset: const Offset(0, 5), // Slight vertical shift
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                      widget.containerColors[index % widget.containerColors.length],
                    fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  8),
                            ),
                          ),
                        );
                      },
                    errorBuilder: (context, data, stack) {
                        return Image.asset(
                          Assets.assetsDefaultImage,
                          fit: BoxFit.cover,
                        );
                    },
                  ),
                  // ... (rest of the Container content) ...
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: Stack(
        children: [
          SizedBox(
            height: 250,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.containerColors.length * 2, // Use more items to show continuous sliding
              clipBehavior: Clip.none,
              itemBuilder: (context, index) {
                return _buildItem(index);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 130,
              height: 35,
              child: ElevatedButton(
                onPressed: widget.onSeeAllTab,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange, // Background color of the button
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners for the button
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min, // Make the row fit its content
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
// Hello I am Tamim