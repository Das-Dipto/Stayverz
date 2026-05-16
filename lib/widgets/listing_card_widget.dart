import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../generated/assets.dart';

class ListingCard extends StatelessWidget {
  final String? name, message, imageURL;
  final bool isLarge, hasAddIcon;
  final bool isSelected;
  const ListingCard({
    super.key,
    this.name,
    this.message,
    this.isLarge = false,
    this.imageURL,
    this.hasAddIcon = false,
    this.isSelected = false
  });

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry borderRadius =
        isLarge
            ? BorderRadius.vertical(top: Radius.circular(12))
            : BorderRadius.horizontal(left: Radius.circular(12));

    List<Widget> children = [
      Container(
        width: isLarge ? double.infinity : 120,
        height: isLarge ? 160 : null,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                imageURL != null && imageURL!.isNotEmpty
                    ? NetworkImage(imageURL!)
                    : AssetImage(Assets.assetsDefaultImage)
                        as ImageProvider,
            fit: BoxFit.cover,
          ),
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasAddIcon)
              CircleAvatar(
                radius: 13,
                backgroundColor: Colors.black,
                child: Icon(Icons.add_circle, color: Colors.white, size: 28),
              ),
          ],
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? '',
                style: TextStyle(
                  color: const Color(0xFF143328) /* Darkest-Variation */,
                  fontSize: 16.84,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.50,
                ),
              ),
              const Gap(10),
              Text(
                message ?? '',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: const Color(0xFF507267) /* Dark-Variation */,
                  fontSize: 12.63,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    Widget child =
        isLarge
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )
            : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            );

    return Container(
      decoration: ShapeDecoration(
        color: Colors.white /* white */,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.94,
            color: isSelected ? Colors.black87 : const Color(0xFFF0F1F5) /* Grey-10 */,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: IntrinsicHeight(child: child),
    );
  }
}

// Hello I am Tamim