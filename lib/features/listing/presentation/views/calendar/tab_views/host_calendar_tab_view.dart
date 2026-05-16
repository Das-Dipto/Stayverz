import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/features/listing/models/listing_model.dart';
import 'package:stayverz_flutter_app/widgets/build_empty_state_widget.dart';
import '../host_calender_view.dart';

class HostCalendarTabView extends GetView<ListingController> {
  const HostCalendarTabView({super.key});

  void _share(BuildContext context, String url) async {
    await Share.share(
      url,
      subject: 'Check this out!',
    );
  }
  @override
  Widget build(BuildContext context) {

    return Obx(() {

      if(controller.isCalendarTabLoading.value && controller.calendarListings.isEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              ),
            ],
          ),
        );
      }

      List<ListingModel> listItems = controller.calendarListings.toList(growable: true);

      if (listItems.isEmpty) {
        return BuildEmptyStateWidget(
          onRetry: controller.refreshCalendarListings,
        );
      }

      return ListView.separated(
        controller: controller.calendarScrollController,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          // Show loading indicator at the bottom when loading more
          if (index == listItems.length && controller.isCalendarTabLoading.value) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          final isFirst = index == 0;
          final isLast = index == listItems.length - 1;
          return InkWell(
            onTap: (){
              Get.to(HostCalenderView(
               image:listItems[index].cover_photo,
               id: "${listItems[index].id}",
               title: listItems[index].title)
              );
            },
            child: Container(
              margin: EdgeInsets.only(
                top: isFirst ? 16 : 0,
                bottom: isLast ? 16 : 0,
              ),
              padding: EdgeInsets.all(6),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 0.94,
                    color: Color(0xFFF0F1F5),
                  ),
                  borderRadius: BorderRadius.circular(7.53),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 10.36, vertical: 14.12),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: listItems[index].cover_photo.isEmpty
                                ? const AssetImage('assets/default_image.jpg') as ImageProvider
                                : NetworkImage(listItems[index].cover_photo),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(4)
                        // shape: RoundedRectangleBorder(
                        //   side: const BorderSide(
                        //     width: 0.94,
                        //     color: Color(0xFFA9A9B0),
                        //   ),
                        //   borderRadius: BorderRadius.circular(7.53),
                        // ),
                      ),
                    ),
                    const Gap(6),
                    Container(
                      width: 4,
                      margin: EdgeInsets.symmetric(vertical: 2),
                      decoration: ShapeDecoration(
                        color: const Color(0x84F15925),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9415.72),
                        ),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listItems[index].title,
                            style: const TextStyle(
                              color: Color(0xFF004E70),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            listItems[index].status=="in_progress"?"In progress":listItems[index].status,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ...List.generate(
                                        5, (i) {
                                        return Icon(Icons.star, size: 16, color: i < listItems[index].avg_rating ? Colors.yellow : Colors.grey);
                                      },
                                      ),
                                      const Gap(3),
                                      Text(
                                        "(${listItems[index].avg_rating})",
                                        style: const TextStyle(
                                          color: Color(0xFF67666B),
                                          fontSize: 12,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Price: ${listItems[index].price}/- night',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.50,
                                    ),
                                  ),
                                ],
                              ),

                              GestureDetector(
                                onTap: () {
                                  _share(
                                    context,
                                    'https://stayverz.com/rooms/${listItems[index].unique_id}',
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF2F2F2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.share,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
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
          );
        },
        separatorBuilder: (context, index) => const Gap(10),
        itemCount: listItems.length + (controller.isCalendarTabLoading.value ? 1 : 0),
      );
    });
  }
}

// Hello I am Tamim