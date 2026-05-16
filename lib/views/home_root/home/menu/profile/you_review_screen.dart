import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stayverz_flutter_app/core/utils/main_utils.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../widgets/own_title_app_bar.dart';
import '../../../../../widgets/profile_avatar_widget.dart';

class YourReviewScreen extends StatefulWidget {
  final dynamic data;
  const YourReviewScreen({super.key, this.data, });

  @override
  State<YourReviewScreen> createState() => _YourReviewScreenState();
}

class _YourReviewScreenState extends State<YourReviewScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Your Reviews',
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView.separated(
        padding: EdgeInsets.all(16),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(12),
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
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: ShapeDecoration(
                      color: Colors.white /* white */,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.94,
                          color: const Color(0xFFF0F1F5) /* Grey-10 */,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [

                          Container(
                            width: 79.10,
                            height: 79.10,
                            padding: const EdgeInsets.symmetric(horizontal: 10.36, vertical: 14.12),
                            decoration: ShapeDecoration(
                              image: DecorationImage(
                                image:widget.data[index].listing.coverPhoto==null?AssetImage('assets/default_image.jpg') :NetworkImage("${widget.data[index].listing.coverPhoto}"),
                                fit: BoxFit.cover,
                              ),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 0.94,
                                  color: const Color(0xFFA9A9B0) /* Grey-50 */,
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          VerticalDivider(indent: 4, endIndent: 4, color: AppColors.primaryColor, thickness: 5, width: 26,),
                          Expanded(
                            child: Text(
                              '${widget.data[index].listing.title}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.07,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Gap(14),
                  Row(
                    children: [
                      ProfileAvatarWidget(
                        url: widget.data[index].reviewBy.image??'',
                        radius: 20,
                      ),
                      const Gap(8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.data[index].reviewBy.fullName??''}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                StarRating(rating: double.parse("${widget.data[index].rating}"),),
                                Text(
                                  '${MainUtils.formatDateMonth(widget.data[index].createdAt)}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                )
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(14),
                  Text(
                    '${widget.data[index].review}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const Gap(24),
          itemCount: widget.data.length
      ),
    );
  }
}
class StarRating extends StatelessWidget {
  final double rating; // from 0.0 to 5.0
  final double size;

  const StarRating({
    Key? key,
    required this.rating,
    this.size = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const totalStars = 5;
    List<Widget> stars = [];

    for (int i = 0; i < totalStars; i++) {
      if (i < rating.floor()) {
        // Full star
        stars.add(Icon(Icons.star, color: Colors.orangeAccent, size: size));
      } else if (i < rating && rating - i >= 0.5) {
        // Half star
        stars.add(Icon(Icons.star_half, color: Colors.orangeAccent, size: size));
      } else {
        // Empty star
        stars.add(Icon(Icons.star_border, color: Colors.grey, size: size));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }
}

// Hello I am Tamim