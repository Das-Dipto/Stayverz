import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HostListItem extends StatelessWidget {
  final String name;
  final String bio;
  final String imageUrl;
  final double rating;
  final int listings;
  final String price;
  final bool isSuperhost;
  final VoidCallback? onTap;

  const HostListItem({
    Key? key,
    required this.name,
    required this.bio,
    required this.imageUrl,
    required this.rating,
    required this.listings,
    required this.price,
    this.isSuperhost = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: ShapeDecoration(
        color: Colors.white /* white */,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFFF0F1F5) /* Grey-10 */,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Host image
              Container(
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Gap(12),
              // Host details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(4),
                      // Host name
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(4),
                      // Location
                      Text(
                        bio,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(10),
                      // Rating and price
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '$listings',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black /* Black */,
                                    fontSize: 12.82,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                                Text(
                                  'listings',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black /* Black */,
                                      fontSize: 8.01,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400
                                  ),
                                )
                              ],
                            ),
                            VerticalDivider(),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.black,
                                      size: 14,
                                    ),
                                    const Gap(2),
                                    Text(
                                      rating.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black /* Black */,
                                        fontSize: 12.82,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 1.50,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Guest ratings',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black /* Black */,
                                    fontSize: 8.01,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            VerticalDivider(),
                            Column(
                              children: [
                                Text(
                                  price,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'years hosting',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black /* Black */,
                                    fontSize: 8.01,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.80,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Hello I am Tamim