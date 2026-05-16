import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/components/your_reservations_component.dart';
import 'package:stayverz_flutter_app/controllers/profile_controller.dart';
import 'package:stayverz_flutter_app/core/constants/app_colors.dart';
import 'package:stayverz_flutter_app/features/reservation/controllers/reservation_controller.dart';
import 'package:stayverz_flutter_app/widgets/own_app_bar.dart';
import '../../../components/your_assistance_component.dart';
import '../../../generated/assets.dart';
import '../../../widgets/your_reservation_components_shimmer_loading.dart';
import '../../assistance_service/presentation/views/create_assistance/create_assistance_service_screen.dart';
import '../../listing/presentation/create_listing/create_listing_screen.dart';
import 'view_all_reservations_screen.dart';

class TodayScreen extends StatefulWidget {
  TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final ReservationController controller = Get.find<ReservationController>();
  final ProfileController profileController = Get.find<ProfileController>();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    profileController.fetchProfile();
    // Reset dialog flag so popup shows on each screen visit
    controller.hasShownReviewDialog.value = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      // Fetch pending_review first with error handling
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await controller.fetchPendingReview();

          final pendingReviewCount =
              controller.reservationStats.value?.pendingReviewCount ?? 0;

          if (pendingReviewCount > 0 &&
              controller.hasShownReviewDialog.value == false) {
            controller.hasShownReviewDialog.value = true;
            controller.selectedTabIndex.value = 4;

            if (mounted) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.bottomSlide,
                title: 'Pending Reviews',
                desc:
                    'You have $pendingReviewCount reservation(s) pending review. Would you like to review them now?',
                btnCancelOnPress: () {},
                btnCancelText: 'Later',
                btnOkText: 'Review Now',
                btnOkOnPress: () {
                  controller.selectedTabIndex.value = 4;
                  controller.fetchReservationByType('pending_review');
                },
              ).show();
            }
          }
        } catch (e) {
          // Silently handle error - don't block UI
          debugPrint('Error fetching pending review in TodayScreen: $e');
        }
      });
    }
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Gap(13),
            Text(
              'Welcome Back',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.selectedReportAssistanceType.value = 0,
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: controller.selectedReportAssistanceType.value == 0
                                    ? Colors.deepOrange
                                    : const Color(0xFFDCDEE3),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  Assets.assetsPP,
                                  width: 60,
                                  height: 60,
                                ),
                                const SizedBox(height: 6),
                                const Text("Property"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => controller.selectedReportAssistanceType.value = 1,
                        child: Container(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: controller.selectedReportAssistanceType.value == 1
                                    ? Colors.deepOrange
                                    : const Color(0xFFDCDEE3),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  Assets.assetsAsP,
                                  width: 60,
                                  height: 60,
                                ),
                                const SizedBox(height: 6),
                                const Text("Assistances"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const Gap(20),
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final rating = profileController.profile.value?.avgRating
                            ?.toStringAsFixed(1) ??
                        '0.0';
                    final totalRatings =
                        profileController.profile.value?.totalRatingCount ?? 0;
                    final imageUrl =
                        profileController.profile.value?.image ?? '';

                    return OutlinedButton(
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          animType: AnimType.rightSlide,
                          btnOkText: "Close",
                          btnOkColor: Colors.redAccent,
                          btnOkOnPress: () {},
                          body: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 3,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    imageUrl,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child,
                                        loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                        Container(
                                          height: 90,
                                          width: 90,
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.person,
                                              size: 50, color: Colors.grey),
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Average Rating',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  final numericRating =
                                      double.tryParse(rating) ?? 0.0;
                                  return Icon(
                                    Icons.star,
                                    color: index < numericRating.floor()
                                        ? Colors.amber
                                        : Colors.grey.shade300,
                                    size: 26,
                                  );
                                }),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$rating / 5.0',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '$totalRatings people have rated',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ).show();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                        side: const BorderSide(width: 0.7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            radius: 14,
                            child: Text(
                              rating,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Gap(5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final userRating = profileController
                                      .profile.value?.avgRating ??
                                  0.0;
                              return Icon(
                                Icons.star,
                                size: 18,
                                color: index < userRating.floor()
                                    ? Colors.yellow.shade700
                                    : Colors.grey.shade400,
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const Gap(15),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              const Text(
                                "What kind of event would you like to host?",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                                    side: const BorderSide(width: 1.5, color: Colors.black12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)
                                    ),
                                    foregroundColor: Colors.black87
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Get.toNamed(CreateListingScreen.route);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/property-icon.png', height: 50, width: 50),
                                      const SizedBox(width: 16),
                                      const Text(
                                          "Property",
                                        style: TextStyle(
                                          fontSize: 16
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                                      side: const BorderSide(width: 1.5, color: Colors.black12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16)
                                      ),
                                      foregroundColor: Colors.black87
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Get.toNamed(CreateAssistanceServiceScreen.route);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset('assets/assistances-icon.png', height: 50, width: 50),
                                      const SizedBox(width: 16),
                                      const Text(
                                        "Assistances",
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Gap(kBottomNavigationBarHeight),
                            ],
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(8.5),
                        side: const BorderSide(width: 0.7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_circle_outline, color: Colors.black),
                        Gap(5),
                        Text(
                          'Create Listing',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Gap(40),
            const Text(
              'Your reservations',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
            Obx(() {
              if (controller.isLoading.value) {
                return YourReservationComponentsShimmerLoading();
              }

              return YourReservationsComponent(
                tabs: [
                  'Currently Hosting (${controller.currentlyHostingReservations.length})',
                  'Check Out (${controller.reservationStats.value?.checkingOutCount ?? 0})',
                  'Arriving Soon (${controller.reservationStats.value?.arrivingSoonCount ?? 0})',
                  'Upcoming (${controller.reservationStats.value?.upcomingCount ?? 0})',
                  'Pending Review (${controller.reservationStats.value?.pendingReviewCount ?? 0})',
                ],
                currentlyHostingReservations: controller.currentlyHostingReservations.value,
                checkingOutReservations: controller.checkingOutReservations.value,
                arrivingSoonReservations: controller.arrivingSoonReservations.value,
                upcomingReservations: controller.upcomingReservations.value,
                pendingReviewReservations: controller.pendingReviewReservations.value,
                selectedTabIndex: controller.selectedTabIndex.value,
                onTap: (index) {
                  controller.onTabSelected(index);
                },
              );
            }),
            const Gap(10),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 20,
                child: Obx(() {
                    return TextButton(
                      onPressed: () {
                        Get.to(ViewAllReservationsScreen());
                      },
                      style:
                      TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10)),
                      child: Text(
                        'All Reservations (${(controller.reservationStats.value?.currentlyHostingCount ?? 0)+(controller.reservationStats.value?.checkingOutCount ?? 0)+(controller.reservationStats.value?.arrivingSoonCount ?? 0)+(controller.reservationStats.value?.upcomingCount ?? 0)+(controller.reservationStats.value?.pendingReviewCount ?? 0)})',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    );
                  }
                ),
              ),
            ),
            const Gap(10),
            const Text(
              "We're here to help",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
            const Gap(22),
            Container(
              width: 359,
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFDCDEE3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 6,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/SUPPORT.gif',
                      height: 50, width: 50, fit: BoxFit.contain),
                  const Gap(16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact specialized support',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            height: 1.50,
                          ),
                        ),
                        Gap(16),
                        Text(
                          'As a new Host, you get one-tap access to a specially trained support team.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.50,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Gap(44),
          ],
        ),
      ),
    );
  }
}
