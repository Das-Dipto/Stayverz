import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/presentation/views/calendar/tab_views/assistance_calendar_tab_view.dart';
import 'package:stayverz_flutter_app/features/listing/presentation/views/calendar/tab_views/co_host_calendar_tab_view.dart';
import 'package:stayverz_flutter_app/widgets/build_error_widget.dart';
import 'package:stayverz_flutter_app/widgets/own_app_bar.dart';
import '../../../controllers/listing_controller.dart';
import '../../../models/listing_model.dart';
import '../edit_listing_screen.dart';
import '../../../../../widgets/listing_card_widget.dart';
import 'host_calender_view.dart';
import 'tab_views/host_calendar_tab_view.dart';

class CalendarScreen extends GetView<ListingController> {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Fetch both for safety if needed
    // controller.fetchListings();
    // controller.fetchCoHostListings(listingStatus: 'published');
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: OwnAppBar(
          appHeight: 55,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
          child: Center(
            child: Text(
              'Calendar',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
          ),),
        backgroundColor: Colors.white,
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            Gap(10),
            CustomTabBarWidget(),
            Gap(10),

            Obx(() {

              if (controller.errorMessage.value.isNotEmpty) {
                return BuildErrorWidget(
                  errorMessage: controller.errorMessage.value,
                  onRetry: controller.refreshListings,
                );
              }

              switch(controller.onHostCalendarTabViewChangeValue.value) {
                case 0:
                  return HostCalendarTabView();
                case 1:
                  return CoHostCalendarTabView();
                case 2:
                  return AssistanceCalendarTabView();
                default:
                  return SizedBox();
              }
            }),
          ],
        ),
      ),
    );
  }
}

class CustomTabBarWidget extends GetView<ListingController> {
  const CustomTabBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Colors.orange,
            width: 1,
          ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        onTap: controller.onHostCalendarTabBarChange,
        tabs: [
          Tab(text: 'Host'),
          Tab(text: 'Co-host'),
          Tab(text: 'Assistance'),
        ],
      ),
    );
  }
}
// Hello I am Tamim