import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../core/constants/app_colors.dart';
import '../features/reservation/models/reservation_stats_model.dart';
import '../features/reservation/presentation/reservation_details_screen.dart';
import '../widgets/reservation_card_item.dart';

class YourReservationsComponent extends StatefulWidget {
  final bool enableScroll;
  final AlignmentGeometry? stackAlignment;
  final List<String> tabs;
  final List<Reservation> currentlyHostingReservations;
  final List<Reservation> checkingOutReservations;
  final List<Reservation> arrivingSoonReservations;
  final List<Reservation> pendingReviewReservations;
  final List<Reservation> upcomingReservations;
  final List<Reservation> completedReservations;
  final Function(int)? onTap;
  final int selectedTabIndex;

  const YourReservationsComponent({
    super.key,
    this.tabs = const [],
    this.enableScroll = false,
    this.stackAlignment,
    this.currentlyHostingReservations = const [],
    this.checkingOutReservations = const [],
    this.arrivingSoonReservations = const [],
    this.upcomingReservations = const [],
    this.pendingReviewReservations = const [],
    this.completedReservations = const [],
    this.onTap,
    required this.selectedTabIndex,
  });

  @override
  State<YourReservationsComponent> createState() =>
      _YourReservationsComponentState();
}

class _YourReservationsComponentState extends State<YourReservationsComponent>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedTabIndex;
    if (widget.tabs.isNotEmpty) {
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.selectedTabIndex.clamp(0, widget.tabs.length - 1),
      );
      _tabController!.addListener(_handleTabSelection);
    }
  }

  @override
  void didUpdateWidget(covariant YourReservationsComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.tabs.length != oldWidget.tabs.length) {
      _tabController?.removeListener(_handleTabSelection);
      _tabController?.dispose();

      final newIndex = widget.selectedTabIndex.clamp(0, widget.tabs.length - 1);
      _tabController = TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: newIndex,
      );
      _currentIndex = newIndex;
      _tabController!.addListener(_handleTabSelection);
    } else if (oldWidget.selectedTabIndex != widget.selectedTabIndex) {
      // Tab index changed from parent - sync the TabController
      final newIndex = widget.selectedTabIndex.clamp(0, widget.tabs.length - 1);
      if (_currentIndex != newIndex) {
        _currentIndex = newIndex;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _tabController != null) {
            if (_tabController!.index != newIndex) {
              _tabController!.index = newIndex;
            }
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController != null && !_tabController!.indexIsChanging) {
      final index = _tabController!.index;
      if (_currentIndex != index) {
        _currentIndex = index;
        widget.onTap?.call(index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController == null || widget.tabs.isEmpty) {
      return const SizedBox();
    }

    // Ensure current index is valid
    final safeIndex = widget.selectedTabIndex.clamp(0, widget.tabs.length - 1);
    final currentEventType = widget.tabs[safeIndex];
    List<Reservation> rList = [];

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

    final listView = reservationList(currentEventType: currentEventType, list: rList);

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryColor,
          labelColor: AppColors.primaryColor,
          isScrollable: true,
          tabs: widget.tabs.map((t) => Tab(text: t)).toList(),
        ),
        const Gap(20),
        widget.enableScroll
            ? Expanded(child: listView)
            : listView,
      ],
    );
  }

  Widget reservationList({
    required String currentEventType,
    required List<Reservation> list,
  }) {
    if (list.isEmpty) {
      return const Center(child: Text("No Data Found!"));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: widget.enableScroll
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final reservation = list[index];
        return ReservationCardItem(
          stackAlignment: widget.stackAlignment,
          bookingId: "${reservation.invoiceNo}",
          eventType: currentEventType,
          onPress: () => Get.to(
            ReservationDetailsScreen(
              bookId: "${reservation.invoiceNo}",
              title: '${reservation.listingTitle}',
            ),
          ),
          title: reservation.listingTitle,
          guestName: reservation.guestName,
          date: reservation.checkIn != null
              ? DateFormat('MMM dd, yyyy').format(reservation.checkIn!)
              : '',
        );
      },
      separatorBuilder: (context, index) => const Gap(10),
      itemCount: list.length,
    );
  }
}
