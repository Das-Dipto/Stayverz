import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/co_host_option_controller.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';
import '../../../../../features/listing/controllers/listing_controller.dart';
import '../../../../../features/listing/models/map_suggestions_response_model.dart';
import '../../../../../widgets/own_title_app_bar.dart';
import 'co_host_view_screen.dart';

class CoHostOptionScreen extends StatefulWidget {
  const CoHostOptionScreen({super.key});

  @override
  State<CoHostOptionScreen> createState() => _CoHostOptionScreenState();
}

class _CoHostOptionScreenState extends State<CoHostOptionScreen> {
  final CoHostController _controller = Get.put(CoHostController());
  final ListingController listingController = Get.find<ListingController>();

  late TextEditingController searchController;
  final RxList<PlaceSuggestion> placeSuggestions = <PlaceSuggestion>[].obs;
  final RxString searchText = ''.obs;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _controller.getCurrentLocation();

    // Listen to text changes and update reactive variable
    searchController.addListener(() {
      searchText.value = searchController.text;
    });

    // Debounce search input to avoid spamming API calls
    debounce(
      searchText,
          (String? query) async {
        final trimmedQuery = query?.trim() ?? '';
        if (trimmedQuery.isNotEmpty) {
          listingController.isHostListingLoading.value = true;
          final result = await listingController.onPlaceSearchChange(trimmedQuery);
          listingController.isHostListingLoading.value = false;

          // Debug print

          placeSuggestions.assignAll(result);
        } else {
          placeSuggestions.clear();
        }
      },
      time: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: OwnTitleAppBar(
          appBarText: _controller.showHosts.value ? 'Available Hosts' : 'Host Assist option',
          fontColor: Colors.black,
          backgroundColor: Colors.white,
          // onPressed: () {
          //   _controller.goBackToLocation();
          // },
        ),
        backgroundColor: Colors.white,
        body: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!_controller.showHosts.value)
                  Center(
                    child: Text(
                      'Where\'s your home?',
                      style: const TextStyle(
                        color: Color(0xFFF15925), // Brand color
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ),
                if (!_controller.showHosts.value) const Gap(24),
                if (_controller.showHosts.value) ...[
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _controller.selectedLocation.value,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(24),
                ],

                // Search + location section (only when not showing hosts)
                if (!_controller.showHosts.value) ...[
                  CustomInputText(
                    controller: searchController,
                    helperText: 'Search location...',
                    prefixIcon: const Icon(Icons.search, size: 28),
                    onChange: (_) {},
                  ),
                  const Gap(16),

                  Obx(() => Row(
                    children: [
                      _controller.isLoading.value
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 1.5),
                      )
                          : const Icon(Icons.location_on, color: Colors.black54, size: 18),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          _controller.isLoading.value
                              ? 'Getting your location...'
                              : _controller.currentLocation.value,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        ),
                      ),
                      if (!_controller.isLoading.value) ...[
                        const Gap(8),
                        SizedBox(
                          height: 20,
                          child: TextButton(
                            onPressed: _controller.getCurrentLocation,
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(EdgeInsets.zero),
                              minimumSize: MaterialStateProperty.all(Size.zero),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Refresh',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  )),
                  const Gap(16),

                  const Text(
                    'Suggested locations',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Gap(12),

                  Obx(() {
                    if (listingController.isHostListingLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Avoid showing "No suggestions found" if input is empty
                    if (searchController.text.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    if (placeSuggestions.isEmpty) {
                      return const Text("No suggestions found.");
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: placeSuggestions.length,
                      separatorBuilder: (_, __) => const Gap(12),
                      itemBuilder: (context, index) {
                        final suggestion = placeSuggestions[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          leading: Container(
                            width: 40,
                            height: 40,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 0.8, color: Colors.grey.shade300),
                            ),
                            child: const Icon(Icons.location_on, size: 18, color: Colors.black54),
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          title: Text(
                            suggestion.address ?? "",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            suggestion.city ?? '',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onTap: () {
                            Get.to(CoHostViewScreen(
                              lat: "${suggestion.latitude}",
                              long: "${suggestion.longitude}",

                            ));
                            // _controller.loadHostsForLocation(suggestion.address ?? "");
                            // _controller.selectedLocation.value = suggestion.city ?? "";
                            // _controller.showHosts.value = true;
                          },
                        );
                      },
                    );
                  }),
                ],
              ],
            ),
          );
        }),
      );
    });
  }
}

// Hello I am Tamim