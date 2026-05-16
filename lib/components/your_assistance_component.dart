import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../core/constants/app_colors.dart';
import '../features/assistance_service/models/assistance_reservation_model.dart';
import '../features/reservation/presentation/assistance_reservation_details_screen.dart';
import '../widgets/assistenace_reservation_card.dart';

class YourAssistanceReservationsComponent extends StatefulWidget {
  final bool enableScroll;
  final AlignmentGeometry? stackAlignment;
  final List<String> tabs;
  final List<AssistanceBookingData> currentlyHostingReservations;
  final List<AssistanceBookingData> upcomingReservations;
  final List<AssistanceBookingData> completedReservations;
  final List<AssistanceBookingData> checkingOutReservations;
  final List<AssistanceBookingData> arrivingSoonReservations;
  final List<AssistanceBookingData> pendingReviewReservations;
  final Function(int)? onTap;
  final int selectedTabIndex;

  const YourAssistanceReservationsComponent({
    super.key,
    this.tabs = const [],
    this.enableScroll = false,
    this.stackAlignment,
    this.currentlyHostingReservations = const [],
    this.upcomingReservations = const [],
    this.completedReservations = const [],
    this.checkingOutReservations = const [],
    this.arrivingSoonReservations = const [],
    this.pendingReviewReservations = const [],
    this.onTap,
    required this.selectedTabIndex,
  });

  @override
  State<YourAssistanceReservationsComponent> createState() => _YourAssistanceReservationsComponentState();
}

class _YourAssistanceReservationsComponentState extends State<YourAssistanceReservationsComponent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    if (widget.tabs.isNotEmpty) {
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.selectedTabIndex,
      );
      _tabController.addListener(_handleTabSelection);
    }
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      widget.onTap?.call(_tabController.index);
    }
  }

  @override
  void didUpdateWidget(covariant YourAssistanceReservationsComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabs.length != _tabController.length) {
      _tabController.removeListener(_handleTabSelection);
      _tabController.dispose();
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.selectedTabIndex,
      );
      _tabController.addListener(_handleTabSelection);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentEventType = widget.tabs[widget.selectedTabIndex];
    List<AssistanceBookingData> rList = [];
    if (currentEventType.contains('Currently Hosting')) {
      rList = widget.currentlyHostingReservations;
    } else if (currentEventType.contains('Check Out')) {
      rList = widget.checkingOutReservations;
    } else if (currentEventType.contains('Arriving Soon')) {
      rList = widget.arrivingSoonReservations;
    } else if (currentEventType.contains('Upcoming')) {
      rList = widget.upcomingReservations;
    } else if (currentEventType.contains('Pending Review')) {
      rList = widget.pendingReviewReservations;
    } else if (currentEventType.contains('Completed')) {
      rList = widget.completedReservations;
    }

    Widget listView = reservationList(currentEventType: currentEventType, list: rList);
    Widget wrapped = widget.enableScroll ? Expanded(child: listView) : listView;

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          labelColor: AppColors.primaryColor,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          tabs: widget.tabs.map((e) => Tab(text: e)).toList(),
        ),
        const Gap(20),
        wrapped,
      ],
    );
  }

  Widget reservationList({required String currentEventType, required List<AssistanceBookingData> list}) {
    if (list.isEmpty) return const Text("No Data Found!");

    return ListView.separated(
      shrinkWrap: true,
      physics: widget.enableScroll
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final reservation = list[index];
        return ReservationAssistanceCardItem(
          stackAlignment: widget.stackAlignment,
          bookingId: "${reservation.invoiceNo}",
          eventType: currentEventType,
          onPress: () => Get.to(
            ReservationAssistanceDetailsScreen(
              bookId: "${reservation.invoiceNo}",
              title: '${reservation.listing?.title}',
            ),
          ),
          title: reservation.listing?.title ?? '',
          guestName: reservation.guest?.fullName ?? '',
          date: reservation.checkIn != null
              ? DateFormat('MMM dd, yyyy').format(DateTime.parse(reservation.checkIn!))
              : '',
        );
      },
      separatorBuilder: (context, index) => const Gap(10),
      itemCount: list.length,
    );
  }
}




// Hello I am Tamim