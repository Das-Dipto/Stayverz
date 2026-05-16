import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/views/home_root/menu_screen/referral_link.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';

import '../../../controllers/profile_controller.dart';
import '../../../widgets/own_app_bar.dart';
class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final ProfileController controller = Get.find<ProfileController>();


  @override
  void initState() {
    super.initState();
    // Schedule the API call after the current build frame is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getReferralLinksList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnAppBar(
        appHeight: 60,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.1),
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                color: Colors.black,
              ),
            ),
            Text(
              'Referral',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            Gap(40),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Gap(35),
          Row(
            children: [
              Spacer(),
              InkWell(
                onTap: ()async{
                  Get.to(ReferralLink());

                },
                child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: const Color(0xFFA9A9B0) /* Grey-50 */,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                        ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                Icon(OwnIcons.refer_host_icon),
                Gap(4),
                Text(
                  'Referral',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                        ],
                      ),
                      ),
              ),
              Spacer(),
            ],
          ),
          Gap(40),
          Text(
            'Refered Guest List',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.50,
            ),
          ),
          Gap(15),
         Obx(() {
           if (controller.isLoadingList.value) {
             return const Center(child: CircularProgressIndicator());
           }

           if (controller.errorListf.value.isNotEmpty) {
             return Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text(
                     'Error loading profile',
                     style: TextStyle(fontSize: 16, color: Colors.red),
                   ),

                 ],
               ),
             );
           }

           final filteredReferralLinks = controller.referralLinksList
               .where((link) => link.status != 'pending')
               .toList();

           return filteredReferralLinks.length==0?Center(child: Padding(
             padding: const EdgeInsets.only(top: 100),
             child: Text("No Refer Link Yet!"),
           )):
           ListView.separated(
               shrinkWrap: true,
               physics: NeverScrollableScrollPhysics(),
               itemBuilder: (context, index) =>  Container(
                 padding: EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                 decoration: ShapeDecoration(
                   color: Colors.white /* white */,
                   shape: RoundedRectangleBorder(
                     side: BorderSide(
                       width: 1,
                       color: const Color(0xFFF0F1F5) /* Grey-10 */,
                     ),
                     borderRadius: BorderRadius.circular(6),
                   ),
                 ),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Container(
                       width: 70,
                       height: 70,
                       alignment: Alignment.center,
                       decoration: ShapeDecoration(
                         color: const Color(0xFFD9D9D9),
                         shape: OvalBorder(),
                         shadows: [
                           BoxShadow(
                             color: Color(0x3F000000),
                             blurRadius: 4,
                             offset: Offset(0, 4),
                             spreadRadius: 0,
                           )
                         ],
                       ),
                       child:  Container(
                         width: 64,
                         height: 64,
                         alignment: Alignment.center,
                         decoration: ShapeDecoration(
                           image: DecorationImage(
                             image:filteredReferralLinks[index].referredUser?.image==""||filteredReferralLinks[index].referredUser?.image==null?AssetImage("assets/p1.png"):NetworkImage("${filteredReferralLinks[index].referredUser!.image}"),
                             fit: BoxFit.cover,
                           ),
                           shape: OvalBorder(),
                         ),
                       ),
                     ),
                     Gap(10),
                     Expanded(child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(
                           "${filteredReferralLinks[index].referredUser!.fullName}",
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                           style: TextStyle(
                             color: Colors.black,
                             fontSize: 16,
                             fontFamily: 'Inter',
                             fontWeight: FontWeight.w600,
                             height: 1.50,
                           ),
                         ),
                         Text(
                           "${filteredReferralLinks[index].referredUser!.uType}",
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                           style: TextStyle(
                             color: const Color(0xFF67666B) /* Grey-70 */,
                             fontSize: 12,
                             fontFamily: 'Inter',
                             fontWeight: FontWeight.w400,
                             height: 1.50,
                           ),
                         ),
                         Text(
                           'Total Booking : ${filteredReferralLinks[index].rewardedBookingCount}',
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                           style: TextStyle(
                             color: const Color(0xFF67666B) /* Grey-70 */,
                             fontSize: 12,
                             fontFamily: 'Inter',
                             fontWeight: FontWeight.w400,
                             height: 1.50,
                           ),
                         ),
                         Text(
                           'Total Earnings : ৳ ${filteredReferralLinks[index].rewardValueFromThisReferral}',
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                           style: TextStyle(
                             color: const Color(0xFF67666B) /* Grey-70 */,
                             fontSize: 12,
                             fontFamily: 'Inter',
                             fontWeight: FontWeight.w400,
                             height: 1.50,
                           ),
                         ),
                       ],
                     ))
                   ],
                 ),
               ),
               separatorBuilder: (context, index) => Gap(15), itemCount: filteredReferralLinks.length);
         },),
          Gap(20),
        ],
      ),
    );
  }
}

// Hello I am Tamim