import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/views/home_root/home/menu/co_host/select_co_host_screen.dart';
import '../../../../../controllers/profile_controller.dart';
import '../../../../../widgets/own_title_app_bar.dart';

class CoHostViewScreen extends StatefulWidget {
  final String lat, long;
  const CoHostViewScreen({super.key, required this.lat, required this.long});

  @override
  State<CoHostViewScreen> createState() => _CoHostViewScreenState();
}

class _CoHostViewScreenState extends State<CoHostViewScreen> {
  final ProfileController listingController = Get.find<ProfileController>();
  @override
  void initState() {
    super.initState();
    // Schedule the API calls after the current build frame is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      listingController.fetchProfile();
      listingController.getHostsInRadius(
        latitude: double.parse(widget.lat),
        longitude: double.parse(widget.long),
        // latitude: double.parse('0'),
        // longitude: double.parse('0'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Co-Host option',
        buttonIconColor: Colors.black,
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        if (listingController.isLoadingHostsData.value) {
          return Center(child: Text("Loading..."));
        }

        if (listingController.errorHostsData.isNotEmpty) {
          return Text(listingController.errorHostsData.value);
        }
        if (listingController.coHostData.isEmpty) {
          return Center(child: const Text("No nearby Co-Host found."));
        }

        return ListView.separated(
          padding: EdgeInsets.only(top: 10, right: 20, left: 20, bottom: 16),
          itemBuilder: (context, index) {
            return listingController.profile.value!.id==listingController.coHostData.value[index].id ?SizedBox(

            ):InkWell(
              onTap: (){
                Get.to(SelectCoHostScreen(
                  iamge: listingController.coHostData.value[index].image??"",
                  id:  "${listingController.coHostData.value[index].id}",
                ));
              },
              child: Container(
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 133,
                      height: 113,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image:
                              listingController.coHostData.value[index].image == null || listingController.coHostData.value[index].image == ""
                                  ? AssetImage('assets/default_image.jpg')
                                  : NetworkImage(
                                    "${listingController.coHostData.value[index].image}",
                                  ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Gap(10),
                    Padding(
                      padding: const EdgeInsets.only(right: 10,bottom: 10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width-195,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Gap(4),
                            Text(
                              listingController.coHostData[index].fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(
                                  0xFF143328,
                                ) /* Darkest-Variation */,
                                fontSize: 16.84,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            Text(
                              listingController.coHostData.value[index].bio,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF67666B) /* Grey-70 */,
                                fontSize: 12.63,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                            Gap(5),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${listingController.coHostData.value[index].totalActiveListings}',
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
                                        fontWeight: FontWeight.w400,
                                        height: 1.80,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 32,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        strokeAlign: BorderSide.strokeAlignCenter,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      listingController.coHostData.value[index].avgRating.toStringAsFixed(2),
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
                                      'Guest ratings',
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
                                ),
                                Container(
                                  height: 32,
                                  decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        strokeAlign: BorderSide.strokeAlignCenter,
                                      ),
                                    ),
                                  ),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${listingController.coHostData.value[index].yearsHosting}',
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
                                      'years hostings',
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
                            )

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => Gap(16),
          itemCount: listingController.coHostData.length,
        );

        //   Column(
        //   children: [
        //     const Gap(16),
        //     Container(
        //       width: 114.17,
        //       height: 107.26,
        //       decoration: BoxDecoration(
        //           image: widget.imageUrl != null ? DecorationImage(
        //             image: NetworkImage(widget.imageUrl!),
        //             fit: BoxFit.cover,
        //           ) : DecorationImage(
        //             image: AssetImage(Assets.assetsDefaultAvatar),
        //             fit: BoxFit.cover,
        //           ),
        //           borderRadius: BorderRadius.circular(10)
        //       ),
        //       clipBehavior: Clip.hardEdge,
        //     ),
        //     const Gap(16),
        //     Text(
        //       "${widget.name}",
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //         color: const Color(0xFF143328) /* Darkest-Variation */,
        //         fontSize: 16.84,
        //         fontFamily: 'Inter',
        //         fontWeight: FontWeight.w500,
        //         height: 1.50,
        //       ),
        //     ),
        //     Text(
        //       "${widget.bio}",
        //       textAlign: TextAlign.center,
        //       style: TextStyle(
        //         color: const Color(0xFF67666B) /* Grey-70 */,
        //         fontSize: 12.63,
        //         fontFamily: 'Inter',
        //         fontWeight: FontWeight.w400,
        //       ),
        //     ),
        //     const Gap(16),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       spacing: 12,
        //       children: [
        //         Expanded(
        //           child: Container(
        //             padding: EdgeInsets.symmetric(vertical: 8),
        //             decoration: ShapeDecoration(
        //               color: Colors.white /* white */,
        //               shape: RoundedRectangleBorder(
        //                 side: BorderSide(
        //                   width: 1,
        //                   color: const Color(0xFFF0F1F5) /* Grey-10 */,
        //                 ),
        //                 borderRadius: BorderRadius.circular(8),
        //               ),
        //             ),
        //             child: Column(
        //               spacing: 4,
        //               children: [
        //                 Text(
        //                   '${widget.my_listing}',
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                     color: Colors.black /* Black */,
        //                     fontSize: 12.82,
        //                     fontFamily: 'Inter',
        //                     fontWeight: FontWeight.w500,
        //                     height: 1.50,
        //                   ),
        //                 ),
        //                 Text(
        //                   'listings',
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                       color: Colors.black /* Black */,
        //                       fontSize: 8.01,
        //                       fontFamily: 'Inter',
        //                       fontWeight: FontWeight.w400
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //         Expanded(
        //           child: Container(
        //             padding: EdgeInsets.symmetric(vertical: 8),
        //             decoration: ShapeDecoration(
        //               color: Colors.white /* white */,
        //               shape: RoundedRectangleBorder(
        //                 side: BorderSide(
        //                   width: 1,
        //                   color: const Color(0xFFF0F1F5) /* Grey-10 */,
        //                 ),
        //                 borderRadius: BorderRadius.circular(8),
        //               ),
        //             ),
        //             child: Column(
        //               spacing: 4,
        //               children: [
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Icon(
        //                       Icons.star,
        //                       color: Colors.black,
        //                       size: 14,
        //                     ),
        //                     const Gap(2),
        //                     Text(
        //                       "${widget.guestRating}",
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                         color: Colors.black /* Black */,
        //                         fontSize: 12.82,
        //                         fontFamily: 'Inter',
        //                         fontWeight: FontWeight.w500,
        //                         height: 1.50,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 Text(
        //                   'Guest ratings',
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                     color: Colors.black /* Black */,
        //                     fontSize: 8.01,
        //                     fontFamily: 'Inter',
        //                     fontWeight: FontWeight.w400,
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //         Expanded(
        //           child: Container(
        //             padding: EdgeInsets.symmetric(vertical: 8),
        //             decoration: ShapeDecoration(
        //               color: Colors.white /* white */,
        //               shape: RoundedRectangleBorder(
        //                 side: BorderSide(
        //                   width: 1,
        //                   color: const Color(0xFFF0F1F5) /* Grey-10 */,
        //                 ),
        //                 borderRadius: BorderRadius.circular(8),
        //               ),
        //             ),
        //             child: Column(
        //               spacing: 4,
        //               children: [
        //                 Text(
        //                   "${widget.yearsHosting}",
        //                   style: const TextStyle(
        //                     fontWeight: FontWeight.w600,
        //                     fontSize: 14,
        //                   ),
        //                 ),
        //                 Text(
        //                   'years hosting',
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                     color: Colors.black /* Black */,
        //                     fontSize: 8.01,
        //                     fontFamily: 'Inter',
        //                     fontWeight: FontWeight.w400,
        //                     height: 1.80,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 32.0),
        //       child: Row(
        //         children: [
        //           Text(
        //             'Co-host\'s commission',
        //             style: TextStyle(
        //               color: Colors.black,
        //               fontSize: 18.60,
        //               fontFamily: 'Inter',
        //               fontWeight: FontWeight.w400,
        //               height: 1.72,
        //             ),
        //           ),
        //           const Gap(16),
        //           Expanded(
        //             child: Stack(
        //               alignment: Alignment.center,
        //               children: [
        //                 LinearProgressIndicator(
        //                   semanticsLabel: "ashgdjas",
        //                   semanticsValue: "sahdfhas",
        //                   borderRadius: BorderRadius.circular(6),
        //                   backgroundColor: Colors.grey.shade200,
        //                   minHeight: 40,
        //                   value: 0.03,
        //                 ),
        //                 Text(
        //                   '3%',
        //                   style: TextStyle(
        //                     color: Colors.black,
        //                     fontSize: 16,
        //                     fontFamily: 'Inter',
        //                     fontWeight: FontWeight.w400,
        //                     height: 1.50,
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     const Gap(16),
        //     Row(
        //       spacing: 16,
        //       children: [
        //         Expanded(
        //           child: OutlinedButton(
        //             onPressed: () {
        //               Get.to(SelectCoHostScreen(lat: '', long: '',));
        //             },
        //             style: OutlinedButton.styleFrom(
        //                 padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        //                 side: BorderSide(width: 0.8, color: Colors.black38),
        //                 shape: RoundedRectangleBorder(
        //                   borderRadius: BorderRadius.circular(8),
        //                 )
        //             ),
        //             child: Text(
        //               'Select Co-host',
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                 color: Colors.black /* Black */,
        //                 fontSize: 16,
        //                 fontFamily: 'Inter',
        //                 fontWeight: FontWeight.w600,
        //                 height: 1.50,
        //               ),
        //             ),
        //           ),
        //         ),
        //         Expanded(
        //             child: OutlinedButton.icon(
        //               onPressed: () {
        //
        //               },
        //               style: OutlinedButton.styleFrom(
        //                   padding: EdgeInsets.symmetric(
        //                       horizontal: 18, vertical: 8),
        //                   side: BorderSide(width: 0.8, color: Colors.black38),
        //                   shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(8),
        //                   ),
        //                   elevation: 6
        //               ),
        //               icon: Icon(
        //                 OwnIcons.message_2_icon, color: Colors.black,),
        //               label: Text(
        //                 'Message',
        //                 textAlign: TextAlign.center,
        //                 style: TextStyle(
        //                   color: Colors.black /* Black */,
        //                   fontSize: 16,
        //                   fontFamily: 'Inter',
        //                   fontWeight: FontWeight.w600,
        //                   height: 1.50,
        //                 ),
        //               ),
        //             )
        //         )
        //       ],
        //     )
        //   ],
        // );
      }),
    );
  }
}

// Hello I am Tamim