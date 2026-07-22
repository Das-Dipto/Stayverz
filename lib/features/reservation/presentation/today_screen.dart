import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/components/your_reservations_component.dart';
import 'package:stayverz_flutter_app/controllers/profile_controller.dart';
import 'package:stayverz_flutter_app/core/constants/app_colors.dart';
import 'package:stayverz_flutter_app/features/reservation/controllers/reservation_controller.dart';
import 'package:stayverz_flutter_app/features/runsys/models/runsys_status_model.dart';
import 'package:stayverz_flutter_app/features/runsys/repositories/runsys_repository.dart';
import 'package:stayverz_flutter_app/widgets/own_app_bar.dart';
import '../../../components/your_assistance_component.dart';
import '../../../generated/assets.dart';
import '../../../widgets/your_reservation_components_shimmer_loading.dart';
import '../../assistance_service/presentation/views/create_assistance/create_assistance_service_screen.dart';
import '../../listing/presentation/create_listing/create_listing_screen.dart';
import 'view_all_reservations_screen.dart';
import '../../../main.dart';

class TodayScreen extends StatefulWidget {
  TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final ReservationController controller = Get.find<ReservationController>();
  final ProfileController profileController = Get.find<ProfileController>();
  bool _initialized = false;

  RunsysStatusModel? _runsysStatus;
  bool _runsysLoading = true;
  bool _runsysConnecting = false;

  @override
  void initState() {
    super.initState();
    profileController.fetchProfile();
    // Reset dialog flag so popup shows on each screen visit
    controller.hasShownReviewDialog.value = false;
    _fetchRunsysStatus();
  }

    Future<void> _fetchRunsysStatus() async {
    final userId = mainControl.userId.value;
    if (userId.isEmpty) {
      if (mounted) setState(() => _runsysLoading = false);
      return;
    }
    final status = await RunsysRepository().getIntegrationStatus(userId);
    if (mounted) {
      setState(() {
        _runsysStatus = status;
        _runsysLoading = false;
      });
    }
  }

  Future<void> _connectRunsys() async {
    final profile = profileController.profile.value;
    if (profile == null) return;

    String? email = profile.email;
    String? phone = profile.phoneNumber;
    final companyName = (profile.fullName?.trim().isNotEmpty ?? false)
        ? profile.fullName!.trim()
        : '${profile.firstName} ${profile.lastName}'.trim();

    if ((email == null || email.isEmpty) || (phone == null || phone.isEmpty)) {
      final result = await _askMissingInfo(email: email, phone: phone);
      if (result == null) return; // user cancelled
      email = result['email'];
      phone = result['phone'];
    }

    setState(() => _runsysConnecting = true);
    final status = await RunsysRepository().createIntegrationBridge(
      companyName: companyName,
      email: email!,
      phoneNumber: phone!,
      userId: profile.id.toString(),
    );
    if (!mounted) return;
    setState(() {
      _runsysConnecting = false;
      if (status != null) _runsysStatus = status;
    });

    Get.snackbar(
      'Runsys',
      status != null
          ? (status.message.isNotEmpty ? status.message : 'Request submitted successfully')
          : 'Failed to connect. Please try again.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: status != null ? Colors.green.shade600 : Colors.red.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  Future<Map<String, String>?> _askMissingInfo({String? email, String? phone}) {
    final emailController = TextEditingController(text: email ?? '');
    final phoneController = TextEditingController(text: phone ?? '');
    return showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Complete Your Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (emailController.text.trim().isEmpty || phoneController.text.trim().isEmpty) return;
              Navigator.pop(ctx, {
                'email': emailController.text.trim(),
                'phone': phoneController.text.trim(),
              });
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
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

 String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '';
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} • ${hour}:$minute $ampm';
  }

  Widget _buildRunsysStatusCard() {
    if (_runsysLoading || _runsysStatus == null) return const SizedBox.shrink();
    final s = _runsysStatus!;

    // Visual config per state
    late Color bg, border, badgeBg, badgeText, iconColor;
    late IconData icon;
    late String badgeLabel, description;

    if (s.isApproved) {
      bg = Colors.green.shade50; border = Colors.green.shade200;
      badgeBg = Colors.green.shade100; badgeText = Colors.green.shade700;
      iconColor = Colors.green.shade600; icon = Icons.check_circle;
      badgeLabel = 'Connected';
      description = 'Your account is successfully connected to Runsys! You can now enjoy advanced property management features.';
    } else if (s.isPending) {
      bg = Colors.blue.shade50; border = Colors.blue.shade200;
      badgeBg = Colors.blue.shade100; badgeText = Colors.blue.shade700;
      iconColor = Colors.blue.shade600; icon = Icons.hourglass_top;
      badgeLabel = 'Pending Approval';
      description = 'Your request is awaiting admin approval. You\'ll be notified once it\'s approved.';
    } else if (s.isRejected) {
      bg = Colors.red.shade50; border = Colors.red.shade200;
      badgeBg = Colors.red.shade100; badgeText = Colors.red.shade700;
      iconColor = Colors.red.shade600; icon = Icons.cancel;
      badgeLabel = 'Rejected';
      description = (s.rejectionReason?.isNotEmpty ?? false)
          ? 'Reason: ${s.rejectionReason}'
          : 'Your request was rejected. You can submit a new request.';
    } else {
      bg = Colors.orange.shade50; border = Colors.orange.shade200;
      badgeBg = Colors.orange.shade100; badgeText = Colors.orange.shade800;
      iconColor = Colors.orange.shade700; icon = Icons.error_outline;
      badgeLabel = 'Not Connected';
      description = 'Connect your account to Runsys to unlock advanced property management features.';
    }

    final dateLabel = s.isApproved
        ? _formatDate(s.approvedAt)
        : s.isRejected
            ? _formatDate(s.rejectedAt)
            : _formatDate(s.requestedAt);
    final dateCaption = s.isApproved
        ? 'Approved'
        : s.isRejected
            ? 'Rejected'
            : 'Requested';

    final showButton = !s.isApproved && !s.isPending; // not-connected or rejected → allow (re)submit

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: ShapeDecoration(
        color: bg,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: border),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Runsys', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        badgeLabel,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: badgeText),
                      ),
                    ),
                  ],
                ),
                const Gap(6),
                Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.4)),
                if (dateLabel.isNotEmpty) ...[
                  const Gap(6),
                  Text(
                    '$dateCaption: $dateLabel',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                  ),
                ],
                if (showButton) ...[
                  const Gap(10),
                  SizedBox(
                    height: 32,
                    child: ElevatedButton(
                      onPressed: _runsysConnecting ? null : _connectRunsys,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _runsysConnecting
                          ? const SizedBox(
                              height: 14, width: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(
                              s.isRejected ? 'Resubmit Request' : 'Connect Now',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
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
            _buildRunsysStatusCard(),
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
