import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/booking/domain/repositories/booking_repository_interface.dart';
import 'package:stayverz_flutter_app/features/booking/controllers/booking_controller.dart';
import 'package:stayverz_flutter_app/features/booking/presentation/views/assitance_trip_details.dart';
import 'package:stayverz_flutter_app/widgets/own_clone_title_app_bar.dart';
import '../../../../generated/assets.dart';
import '../../bindings/booking_binding.dart';
import '../../data/models/assistance_book_model.dart';
import '../../data/models/booking_model.dart';
import '../../../../core/utils/main_utils.dart';
import '../../../../widgets/listing_card_widget.dart';
import 'trip_details.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> with AutomaticKeepAliveClientMixin {
  late final BookingController _bookingController;
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeController(); // ✅ only initialize once safely after first frame
    });
  }

  Future<void> _initializeController() async {
    try {
      // Ensure the controller is initialized
      if (!Get.isRegistered<BookingController>()) {
        await Get.putAsync<BookingController>(
              () async => BookingController(Get.find<BookingRepositoryInterface>()),
          permanent: true,
        );
      }
      _bookingController = Get.find<BookingController>();

      // Initialize coupon data only when this screen is accessed
      _bookingController.initializeCouponData();

      // Load initial data
      await _loadInitialBookings();

      // Attach scroll listener
      _scrollController.addListener(_onScroll);

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize booking data. Please try again.';
        });
      }
    }
  }

  Future<void> _loadInitialBookings() async {
    try {
      await _bookingController.fetchBookings(loadMore: false);
      await _bookingController.fetchAssistanceBookings();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load bookings. Please try again.';
      });
      rethrow;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreBookings();
    }
  }

  Future<void> _loadMoreBookings() async {
    if (!_isLoadingMore && _bookingController.hasMore.value) {
      setState(() {
        _isLoadingMore = true;
      });

      try {
        await _bookingController.fetchBookings(loadMore: true);
      } catch (e) {
      } finally {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeController,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: OwnTitleAppBar(
        title: 'My trips',
        backgroundColor: Colors.white,
        titleColor: Colors.black,
        titleFontSize: 18,
        borderRadius: BorderRadius.circular(16),
      ),
      body: Column(
        children: [
          // 🔸 Custom Tab Switcher (Property / Assistances)
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _bookingController.selectedReportType.value = 0,
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: _bookingController.selectedReportType.value == 0
                                  ? Colors.deepOrange
                                  : const Color(0xFFDCDEE3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            spacing: 4,
                            children: [
                              Image.asset(
                                Assets.assetsPP,
                                width: 50,
                                height: 50,
                              ),
                              const Text("Property"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => _bookingController.selectedReportType.value = 1,
                      child: Container(
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: _bookingController.selectedReportType.value == 1
                                  ? Colors.deepOrange
                                  : const Color(0xFFDCDEE3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            spacing: 4,
                            children: [
                              Image.asset(
                                Assets.assetsAsP,
                                width: 50,
                                height: 50,
                              ),
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

          // 🔸 Dynamic body below tabs
          Expanded(
            child: Obx(() {
              if (_bookingController.selectedReportType.value == 0) {
                // Property tab content (existing logic)
                return Obx(() {
                  if (_bookingController.isLoading.value &&
                      _bookingController.bookings.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_bookingController.errorMessage.value.isNotEmpty &&
                      _bookingController.bookings.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _bookingController.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  if (_bookingController.bookings.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No bookings found'),
                      ),
                    );
                  }

                  // your entire trip + coupon list section
                  return SingleChildScrollView(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ongoing',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(8),
                        _buildBookingList(_bookingController.ongoingTrips,
                            "false", "false"),
                        const Gap(16),
                        Text(
                          'Upcoming',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(8),
                        _buildBookingList(_bookingController.upcomingTrips,
                            "false", "true"),
                        const Gap(16),
                        Text(
                          'Past trip',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(8),
                        _buildBookingList(
                            _bookingController.pastTrips, "true", "false"),
                        const Gap(16),
                        Text(
                          'Canceled',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(8),
                        _buildBookingList(
                            _bookingController.canceledTrips, "false", "false"),
                        const Gap(16),
                        Divider(color: const Color(0xFFA9A9B0)),
                        const Gap(16),

                        /// your full coupon + referral section here
                        _buildReferralSection(context),
                        Obx(() {
                          final couponValue = _bookingController.userCouponBalance.value?.data?.currentPoints;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(width: 1, color: Color(0xFFF0F1F5)),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Referral Reward',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.50,
                                      ),
                                    ),
                                    Text(
                                      couponValue != null ? '৳ $couponValue' : ' ',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 1.33,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(16),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Coupon List ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 1.50,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '(Coupon is unique number)',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 44,
                                      alignment: Alignment.centerLeft,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        shadows: const [
                                          BoxShadow(
                                            color: Color(0x19000000),
                                            blurRadius: 10,
                                            offset: Offset(0, 0),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      child: Text(
                                        couponValue != null ? '$couponValue' : '0.00',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(15),
                                  OutlinedButton(
                                    onPressed: _bookingController.isClaimingCoupon.value
                                        ? null
                                        : () async {
                                      final couponValueString =
                                          _bookingController.userCouponBalance.value?.data?.currentPoints ?? '0.00';
                                      final couponValue = double.tryParse("$couponValueString") ?? 0.00;

                                      if (couponValue < 100.0) {
                                        Fluttertoast.showToast(
                                          msg: "You can claim only 100 points at a time",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          backgroundColor: Colors.redAccent,
                                          textColor: Colors.white,
                                          fontSize: 14.0,
                                        );
                                      } else {
                                        final success = await _bookingController.claimReferralCoupon();
                                        if (success) {
                                          await _bookingController.initializeCouponData();
                                        }
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                      side: const BorderSide(width: 0.8, color: Colors.black38),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: _bookingController.isClaimingCoupon.value
                                        ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                        : const Text(
                                      'Claim Coupon',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 1.50,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                        const Gap(10),
                        Obx(() {
                          if (_bookingController.isCouponListLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (_bookingController.userCoupons.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Text("No coupons available"),
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _bookingController.userCoupons.length,
                            padding: const EdgeInsets.all(16),
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final coupon = _bookingController.userCoupons[index];
                              return Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Code: ${coupon.code}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            coupon.status != "active"
                                                ? Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Colors.deepOrangeAccent,
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 2,
                                              ),
                                              child: const Text(
                                                "Used",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                                : InkWell(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(text: coupon.code));
                                                Get.snackbar(
                                                  'Copied',
                                                  'Coupon code copied to clipboard!',
                                                  snackPosition: SnackPosition.TOP,
                                                );
                                              },
                                              borderRadius: BorderRadius.circular(20),
                                              child: const Icon(
                                                Icons.copy,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text('Amount: ৳${coupon.amount}'),
                                        Text('Status: ${coupon.statusDisplay}'),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                        const Gap(20),

                      ],
                    ),
                  );
                });
              } else {
                // Assistances tab content
                return Obx(() {
                  if (_bookingController.isAssistanceLoading.value &&
                      _bookingController.bookingsAssistance.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (_bookingController.errorAssistanceMessage.value.isNotEmpty &&
                      _bookingController.bookingsAssistance.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _bookingController.errorAssistanceMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  if (_bookingController.bookingsAssistance.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No bookings found'),
                      ),
                    );
                  }

                  // your entire trip + coupon list section
                  return SingleChildScrollView(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ongoing',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(8),
                        _buildAssistancesTrips(_bookingController.ongoingAssistanceTrips,
                            "false", "false"),
                        const Gap(16),
                        Text(
                          'Upcoming',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(8),
                        _buildAssistancesTrips(_bookingController.upcomingAssistanceTrips,
                            "false", "true"),
                        const Gap(16),
                        Text(
                          'Past trip',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(8),
                        _buildAssistancesTrips(
                            _bookingController.pastAssistanceTrips, "true", "false"),
                        const Gap(16),
                        Text(
                          'Canceled',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Gap(8),
                        _buildAssistancesTrips(
                            _bookingController.canceledAssistanceTrips, "false", "false"),
                        const Gap(16),
                        Divider(color: const Color(0xFFA9A9B0)),
                        const Gap(16),

                        Obx(() {
                          final couponValue = _bookingController.userCouponBalance.value?.data?.currentPoints;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(width: 1, color: Color(0xFFF0F1F5)),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Referral Reward',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.50,
                                      ),
                                    ),
                                    Text(
                                      couponValue != null ? '৳ $couponValue' : ' ',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 1.33,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(16),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Coupon List ',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 1.50,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '(Coupon is unique number)',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        height: 1.50,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 44,
                                      alignment: Alignment.centerLeft,
                                      decoration: ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        shadows: const [
                                          BoxShadow(
                                            color: Color(0x19000000),
                                            blurRadius: 10,
                                            offset: Offset(0, 0),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      child: Text(
                                        couponValue != null ? '$couponValue' : '0.00',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.50,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(15),
                                  OutlinedButton(
                                    onPressed: _bookingController.isClaimingCoupon.value
                                        ? null
                                        : () async {
                                      final couponValueString =
                                          _bookingController.userCouponBalance.value?.data?.currentPoints ?? '0.00';
                                      final couponValue = double.tryParse("$couponValueString") ?? 0.00;

                                      if (couponValue < 100.0) {
                                        Fluttertoast.showToast(
                                          msg: "You can claim only 100 points at a time",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.TOP,
                                          backgroundColor: Colors.redAccent,
                                          textColor: Colors.white,
                                          fontSize: 14.0,
                                        );
                                      } else {
                                        final success = await _bookingController.claimReferralCoupon();
                                        if (success) {
                                          await _bookingController.initializeCouponData();
                                        }
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                      side: const BorderSide(width: 0.8, color: Colors.black38),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: _bookingController.isClaimingCoupon.value
                                        ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                        : const Text(
                                      'Claim Coupon',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                        height: 1.50,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                        const Gap(10),
                        Obx(() {
                          if (_bookingController.isCouponListLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (_bookingController.userCoupons.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Text("No coupons available"),
                              ),
                            );
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _bookingController.userCoupons.length,
                            padding: const EdgeInsets.all(16),
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final coupon = _bookingController.userCoupons[index];
                              return Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Code: ${coupon.code}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            coupon.status != "active"
                                                ? Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                                color: Colors.deepOrangeAccent,
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 2,
                                              ),
                                              child: const Text(
                                                "Used",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )
                                                : InkWell(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(text: coupon.code));
                                                Get.snackbar(
                                                  'Copied',
                                                  'Coupon code copied to clipboard!',
                                                  snackPosition: SnackPosition.TOP,
                                                );
                                              },
                                              borderRadius: BorderRadius.circular(20),
                                              child: const Icon(
                                                Icons.copy,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text('Amount: ৳${coupon.amount}'),
                                        Text('Status: ${coupon.statusDisplay}'),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }),
                        const Gap(20),

                      ],
                    ),
                  );
                });
              }
            }),
          ),
        ],
      ),
    );

  }

  Widget _buildBookingList(List<dynamic> bookings,String isPast,String isCancel) {
    if (bookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No bookings found'),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookings.length,
      separatorBuilder: (context, index) => const Gap(8),
      itemBuilder: (context, index) {
        BookingModel booking = bookings[index];
        return InkWell(
          onTap: (){
            Get.to(TripDetails(booking: booking,isRate: isPast=="false"?false:true,isCancel: isCancel=="true"?true:false,));
          },
          child: ListingCard(
            name: booking.listing.title,
            message: '${MainUtils.formatDate(timeStamp: booking.checkIn, formatPattern: "MMM dd yyyy")} - ${MainUtils.formatDate(timeStamp: booking.checkOut, formatPattern: "MMM dd yyyy")}',
            imageURL: booking.listing.coverPhoto,
          ),
        );
      },
    );
  }

  Widget _buildReferralSection(BuildContext context) {
    final couponValue = _bookingController.userCouponBalance.value?.data?.currentPoints;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Existing coupon UI code here...
      ],
    );
  }


  Widget _buildAssistancesTrips(List<dynamic> bookings,String isPast,String isCancel) {
    if (bookings.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No bookings found'),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: bookings.length,
      separatorBuilder: (context, index) => const Gap(8),
      itemBuilder: (context, index) {
        AssistanceTrip booking = bookings[index];
        return InkWell(
          onTap: (){
            Get.to(
                  () => TripAssistanceDetails(
                invId: booking.invoiceNo.toString(),
                isRate: isPast == "true",
                isCancel: isCancel == "true",
              ),
              binding: BookingBinding(),
            );
          },
          child: ListingCard(
            name: booking.listing?.title,
            message: '${MainUtils.formatDate(timeStamp: "${booking.checkIn}", formatPattern: "MMM dd yyyy")} - ${MainUtils.formatDate(timeStamp: "${booking.checkOut}", formatPattern: "MMM dd yyyy")}',
            imageURL: booking.listing?.coverPhoto,
          ),
        );
      },
    );
  }
}

// Hello I am Tamim