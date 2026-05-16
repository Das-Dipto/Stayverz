import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stayverz_flutter_app/widgets/profile_avatar_widget.dart';

import '../generated/assets.dart';

class RecommendedListingCard extends StatelessWidget {
  final String? name, message, imageURL, avatarImage;
  final bool isLarge, hasAddIcon;
  final bool isSelected, isCurrentUser;
  final double? height, width;
  const RecommendedListingCard({
    super.key,
    this.name,
    this.message,
    this.isLarge = false,
    this.imageURL,
    this.avatarImage,
    this.hasAddIcon = false,
    this.isSelected = false,
    this.isCurrentUser = false,
    this.height, this.width
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isCurrentUser) ...[
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: ProfileAvatarWidget(url: avatarImage ?? '', size: 18),
          ),
          const Gap(8),
        ],
        Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: isCurrentUser
                ? const Color(0xFFF15925)
                : const Color(0xFFFFFFFF),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.94,
                color: isSelected ? Colors.black87 : const Color(0xFFF0F1F5) /* Grey-10 */,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: IntrinsicHeight(child: Row(
            children: [
              if(isCurrentUser)Container(
                width: 90,
                height: 75,
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
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
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
                          color: isCurrentUser ? Colors.white : const Color(0xFF143328) /* Darkest-Variation */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        message ?? '',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: isCurrentUser ? Colors.white : const Color(0xFF507267) /* Dark-Variation */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if(!isCurrentUser)Container(
                width: 90,
                height: 75,
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
                  borderRadius: BorderRadius.horizontal(left: isCurrentUser ? Radius.circular(12) : Radius.zero, right: !isCurrentUser ? Radius.circular(12) : Radius.zero),
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
            ],
          )),
        ),
        if (isCurrentUser) ...[
          const Gap(8),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: ProfileAvatarWidget(
              url: avatarImage ?? '',
              size: 18,
            ),
          ),
        ],
      ],
    );
  }
}

// Hello I am Tamim