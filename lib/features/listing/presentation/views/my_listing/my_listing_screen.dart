import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/bindings/listing_binding.dart';
import 'package:stayverz_flutter_app/features/listing/presentation/views/my_listing/tab_views/assistance_listing_tab_view.dart';
import 'package:stayverz_flutter_app/features/listing/presentation/views/my_listing/tab_views/co_host_listing_tab_view.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';
import '../../../../../widgets/listing_card_widget.dart';
import '../../../../../widgets/own_title_app_bar.dart';
import '../../../controllers/listing_controller.dart';
import '../edit_listing_screen.dart';
import 'tab_views/host_tab_listing_view.dart';

class MyListingScreen extends StatelessWidget {
  const MyListingScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Initialize binding to inject dependencies
    ListingBinding().dependencies();
    
    // Get the controller
    final ListingController controller = Get.find<ListingController>();
    
    return _MyListingScreenContent(controller: controller);
  }
}

class _MyListingScreenContent extends GetView<ListingController> {
  const _MyListingScreenContent({Key? key, required this.controller}) : super(key: key);
  
  final ListingController controller;



  @override
  Widget build(BuildContext context) {
    // Refresh listings when screen is shown
    // controller.refreshListings();
    // Always reset to Host tab when entering screen
    controller.onHostMyListingTabViewChangeValue.value = 0;

    // Load Host listings initially
    controller.refreshListings();


    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: OwnTitleAppBar(
          appBarText: 'My Listing',
          fontColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Obx(() {

          if (controller.hasError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${controller.errorMessage.value}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.refreshListings,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => controller.refreshListings(),
            child: SingleChildScrollView(
              controller: controller.myListingScrollController,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: CustomInputText(
                            controller: controller.searchController,
                            helperText: 'Search',
                            prefixIcon: const Icon(Icons.search, size: 26),
                            onChange: controller.searchListings,
                          ),
                        ),
                      ),
                      const Gap(8),
                      Obx(() {
                          return IconButton(
                              onPressed: controller.toggleViewMode,
                              style: IconButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)
                                ),
                                side: BorderSide(width: 1.2, color: Colors.grey.shade500)
                              ),
                              icon: Icon(controller.isGridView.value ? Icons.grid_view_rounded : Icons.list)
                          );
                        }
                      )
                    ],
                  ),
                  const Gap(15),
                  // if (controller.isLoading.value && controller.listings.isNotEmpty)
                  //   const LinearProgressIndicator(),
                  CustomTabBarWidget(),
                  const Gap(15),

                  Obx(() {

                    switch(controller.onHostMyListingTabViewChangeValue.value) {
                      case 0:
                        return HostTabListingView();
                      case 1:
                        return CoHostListingTabView();
                      case 2:
                        return AssistanceListingTabView();
                      default:
                        return SizedBox();
                    }

                  }),
                  //
                  // if ((controller.currentPage.value < controller.totalPages.value) || (controller.coHostCurrentPage.value < controller.coHostTotalPages.value))
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 16),
                  //     child: ElevatedButton(
                  //       onPressed: controller.loadNextPage,
                  //       child: const Text('Load More'),
                  //     ),
                  //   ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class CustomTabBarWidget extends GetView<ListingController> {
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
        onTap: controller.onHostCoHostChangeMyList,
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