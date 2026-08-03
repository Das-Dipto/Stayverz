import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:stayverz_flutter_app/views/home_root/menu_screen/referral_link.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';
import '../../../controllers/profile_controller.dart';
import '../../../widgets/own_app_bar.dart';

/// Host version of the referral screen. The app bar and the top
/// "Create Referral" action are identical to [ReferralScreen] (guest).
/// Everything below that (stat cards, progress bar, referral list) is
/// wired to the host earnings/list endpoints instead of guest ones.
class HostReferralScreen extends StatefulWidget {
  const HostReferralScreen({super.key});

  @override
  State<HostReferralScreen> createState() => _HostReferralScreenState();
}

class _HostReferralScreenState extends State<HostReferralScreen> {
  final ProfileController controller = Get.find<ProfileController>();

  // Host list doesn't return a per-referral booking cap, so we display
  // progress against this fixed target, matching the "0 / 3" shown for
  // pending host referrals.
  static const int _maxBookingsPerReferral = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.profile.value == null) {
        await controller.fetchProfile();
      }
      controller.getReferralHostEarnings();
      controller.getReferralHostListData();
    });
  }

  String _fmt(double? value) {
    if (value == null) return '0';
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                color: Colors.black,
              ),
            ),
            const Text(
              'Host Referrals',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            controller.getReferralHostEarnings(),
            controller.getReferralHostListData(),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const Gap(20),

            // Top right button (identical to guest screen)
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () => Get.to(() => const ReferralLink()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFFA9A9B0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(OwnIcons.refer_host_icon),
                        const Gap(4),
                        const Text(
                          'Create Referral',
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
              ],
            ),
            const Gap(25),

            // ---------- Stat Cards ----------
            // 5 cards: Hosts Referred, Total Earned, Referral Balance,
            // Bookings, Host Credit — all sourced from referralHostEarnings.
            Obx(() {
              final earnings = controller.referralHostEarnings.value;
              final isLoading = controller.isLoadingHostEarnings.value;

              return Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Hosts Referred',
                            value: isLoading ? '-' : '${earnings?.totalHostsReferred ?? 0}',
                            subLabel:
                                '${earnings?.activeHosts ?? 0} active · ${earnings?.superhostCount ?? 0} Superhosts',
                            icon: Icons.home_outlined,
                            iconBg: const Color(0xFFFCE4E4),
                            iconColor: const Color(0xFFE05252),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: _StatCard(
                            label: 'Total Earned',
                            value: isLoading ? '-' : '৳ ${_fmt(earnings?.totalEarned)}',
                            subLabel: '৳ ${_fmt(earnings?.completedEarned)} completed',
                            icon: Icons.card_giftcard,
                            iconBg: const Color(0xFFDFF5E8),
                            iconColor: const Color(0xFF2E9E5B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(12),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Referral Balance',
                            value: isLoading ? '-' : '৳ ${_fmt(earnings?.referralBalance)}',
                            subLabel: '৳ ${_fmt(earnings?.completedEarned)} completed',
                            icon: Icons.card_giftcard,
                            iconBg: const Color(0xFFDFF5E8),
                            iconColor: const Color(0xFF2E9E5B),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: _StatCard(
                            label: 'Bookings',
                            value: isLoading ? '-' : '${earnings?.bookingsReferred ?? 0}',
                            subLabel: 'Value: ৳ ${_fmt(earnings?.totalBookingValue)}',
                            icon: Icons.trending_up,
                            iconBg: const Color(0xFFE1EEFB),
                            iconColor: const Color(0xFF2D7BD1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(12),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Host Credit',
                            value: isLoading ? '-' : '৳ ${_fmt(earnings?.hostReferralCreditBalance)}',
                            subLabel: '${_fmt(earnings?.bookingsPerHost)} bookings/host',
                            icon: Icons.attach_money,
                            iconBg: const Color(0xFFEDE3FB),
                            iconColor: const Color(0xFF7A3FE0),
                          ),
                        ),
                        const Gap(12),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ],
              );
            }),

            const Gap(16),

            // ---------- Referral Progress ----------
            Obx(() {
              final earnings = controller.referralHostEarnings.value;
              final progress = ((earnings?.progressPercentage ?? 0) / 100).clamp(0.0, 1.0);
              final active = earnings?.activeHosts ?? 0;
              final total = earnings?.totalHostsReferred ?? 0;
              final remaining = (total - active).clamp(0, total);

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF7F9FC),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFF0F1F5)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 34,
                          width: 34,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE1EEFB),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.emoji_events_outlined, size: 18, color: Color(0xFF2D7BD1)),
                        ),
                        const Gap(10),
                        const Expanded(
                          child: Text(
                            'Referral Progress',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            color: Color(0xFF2D7BD1),
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const Gap(14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: const Color(0xFFE4E7EE),
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF2D7BD1)),
                      ),
                    ),
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$active active hosts out of $total',
                          style: const TextStyle(
                            color: Color(0xFF67666B),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (remaining > 0)
                          Text(
                            '$remaining more to reach your goal',
                            style: const TextStyle(
                              color: Color(0xFF9A9AA5),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        else if (total > 0)
                          const Text(
                            '🎉 All referrals active!',
                            style: TextStyle(
                              color: Color(0xFF2E9E5B),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const Gap(24),

            // ---------- Your Referrals header ----------
            Obx(() {
              final total = controller.referralHostList.length;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Referred Hosts',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$total total',
                    style: const TextStyle(
                      color: Color(0xFF67666B),
                      fontSize: 13,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            }),
            const Gap(12),

            // ---------- Referral list (cards) ----------
            Obx(() {
              if (controller.isLoadingHostList.value) {
                return const Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.errorHostList.value.isNotEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Text(
                      'Error loading referrals',
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  ),
                );
              }

              final list = controller.referralHostList;

              if (list.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Text('No Referrals Yet!'),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, index) {
                  final item = list[index];
                  final referredUser = item.hostName ?? 'N/A';

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: Color(0xFFF0F1F5)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F1F5),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  item.referralCode,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12, fontFamily: 'Inter'),
                                ),
                              ),
                            ),
                            const Gap(8),
                            _StatusBadge(status: item.status),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(Icons.copy_outlined, size: 18, color: Colors.orange),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: item.referralCode));
                                Fluttertoast.showToast(msg: 'Referral code copied!');
                              },
                            ),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Referred User', style: TextStyle(fontSize: 11, color: Color(0xFF9A9AA5))),
                                  const Gap(2),
                                  Text(
                                    referredUser,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13, fontFamily: 'Inter', fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Bookings', style: TextStyle(fontSize: 11, color: Color(0xFF9A9AA5))),
                                  const Gap(2),
                                  Text(
                                    '${item.bookingsCount} / $_maxBookingsPerReferral',
                                    style: const TextStyle(fontSize: 13, fontFamily: 'Inter', fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Reward', style: TextStyle(fontSize: 11, color: Color(0xFF9A9AA5))),
                                  const Gap(2),
                                  Text(
                                    '৳ ${_fmt(item.rewardEarned)}',
                                    style: const TextStyle(fontSize: 13, fontFamily: 'Inter', fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${item.bookingsCount} transactions',
                                    style: const TextStyle(fontSize: 10, color: Color(0xFF9A9AA5)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(8),
                        Text(
                          item.referralDate != null
                              ? 'Added on ${DateFormat('MMM d, yyyy').format(item.referralDate!)}'
                              : '',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF9A9AA5)),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),

            const Gap(30),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subLabel;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subLabel,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFF0F1F5)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF67666B),
                    fontSize: 13,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Gap(6),
              Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 15, color: iconColor),
              ),
            ],
          ),
          const Gap(8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(4),
          Text(
            subLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF9A9AA5),
              fontSize: 11,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status.toLowerCase()) {
      case 'active':
      case 'completed':
        bg = const Color(0xFFDFF5E8);
        fg = const Color(0xFF2E9E5B);
        break;
      case 'pending':
        bg = const Color(0xFFFCEFDB);
        fg = const Color(0xFFC5860C);
        break;
      default:
        bg = const Color(0xFFF0F1F5);
        fg = const Color(0xFF67666B);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        status,
        style: TextStyle(color: fg, fontSize: 12, fontFamily: 'Inter', fontWeight: FontWeight.w500),
      ),
    );
  }
}

// Hello I am Tamim