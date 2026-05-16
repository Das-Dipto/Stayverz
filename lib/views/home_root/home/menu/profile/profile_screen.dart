import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../../services/network/error_display_manager.dart';
import 'package:stayverz_flutter_app/core/utils/main_utils.dart';
import 'package:stayverz_flutter_app/views/home_root/home/menu/profile/guest_review_screen.dart';
import 'package:stayverz_flutter_app/views/home_root/home/menu/profile/live_verification_screen.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';
import 'package:stayverz_flutter_app/widgets/profile_avatar_widget.dart';
import '../../../../../controllers/profile_controller.dart';
import '../../../../../features/listing/bindings/listing_binding.dart';
import '../../../../../features/listing/presentation/views/edit_listing_screen.dart';
import '../../../../../features/profile/bindings/profile_binding.dart';
import '../../../../../features/public_listings/presentation/views/public_listing_details_view.dart';
import '../../../../../main.dart';
import '../../../../../widgets/own_title_app_bar.dart';
import 'edit_about_profile_screen.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize binding if not already done
    if (!Get.isRegistered<ProfileController>()) {
      ProfileBinding().dependencies();
    }
    return const _ProfileScreen();
  }
}

class _ProfileScreen extends StatefulWidget {
  const _ProfileScreen();

  @override
  State<_ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<_ProfileScreen> {
  final ProfileController controller = Get.find<ProfileController>();
  final RxBool enableCoHost = false.obs;

  @override
  void initState() {
    super.initState();
    // Schedule the API call after the current build frame is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfile();
    });
  }

  Future<void> _loadProfile() async {
    try {
      await controller.fetchProfile();
    } catch (e) {
      Get.find<ErrorDisplayManager>().showError('Failed to load profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Profile',
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading profile',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text('No profile data available'));
        }
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: const Color(0xFFF0F1F5)),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(48),
                      bottomRight: Radius.circular(48),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Gap(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.fullName ?? 'N/A',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.33,
                            ),
                          ),
                          Text(
                            profile.uType ?? 'User Type N/A',
                            // profile.isActive ?? 'User Type N/A',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(GuestReviewScreen());
                            },
                            child: Row(
                              children: [
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      Icons.star,
                                      color:
                                          i < (profile.avgRating?.round() ?? 0)
                                              ? Colors.orangeAccent
                                              : Colors.grey,
                                      size: 14,
                                    );
                                  }),
                                ),
                                Text(
                                  MainUtils.formatAmount(
                                    profile.totalRatingCount ?? 0,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF67666B) /* Grey-70 */,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 1.50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ProfileAvatarWidget(url: profile.image ?? '', radius: 36),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    if (profile.uType == 'host')
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Enable Host Assist Option',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.50,
                              ),
                            ),
                            Obx(() {
                              return Switch(
                                value: controller.enableCoHost.value,
                                onChanged: (value) async {
                                  await controller.patchCohostAvailability(
                                    value,
                                  );
                                  controller.enableCoHost.value = value;
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              );
                            }),
                          ],
                        ),
                      )
                    else
                      SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: Colors.white /* white */,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFFF0F1F5) /* Grey-10 */,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${profile.fullName ?? 'N/A'}’s confirmed information",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                          const Gap(12),
                          Row(
                            children: [
                              Icon(Icons.phone, color: Colors.green),
                              const Gap(8),
                              Text(
                                profile.phoneNumber?.isNotEmpty == true
                                    ? (profile.phoneNumber ?? '')
                                    : '018xxxxxxxxx',
                                style: TextStyle(
                                  color: const Color(0xFF67666B) /* Grey-70 */,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                          const Gap(11),
                          Row(
                            children: [
                              profile.isPhoneVerified != true
                                  ? Icon(Icons.close, color: Colors.red)
                                  : Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                              const Gap(8),
                              Text(
                                profile.isPhoneVerified == true
                                    ? 'Phone Verified'
                                    : 'Phone Not Verified',
                                style: TextStyle(
                                  color:
                                      profile.isPhoneVerified == true
                                          ? Colors.green
                                          : Colors.red,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                          const Gap(11),
                          Row(
                            children: [
                              profile.identityVerificationStatus != 'verified'
                                  ? Icon(Icons.close, color: Colors.red)
                                  : Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                              const Gap(8),
                              Text(
                                profile.identityVerificationStatus == 'verified'
                                    ? 'Live Verified'
                                    : 'Not Live Verified',
                                style: TextStyle(
                                  color: profile.identityVerificationStatus == 'verified'? Colors.green : Colors.red, /* Grey-70 */
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                            ],
                          ),
                          if (profile.identityVerificationStatus != 'verified')
                            profile.identityVerificationStatus == 'pending'
                                ? Gap(10)
                                : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18.0,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      _showAboutIdentityVerification(context);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Learn about identity verification',
                                          style: TextStyle(
                                            color: const Color(
                                              0xFF67666B,
                                            ) /* Grey-70 */,
                                            fontSize: 16,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        const Gap(22),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 18,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          if (profile.identityVerificationStatus != 'verified')
                            profile.identityVerificationStatus == 'pending'
                                ? Center(
                                  child: Text(
                                    "Under Review",
                                    style: TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                                : Center(
                                  child: OutlinedButton.icon(
                                      onPressed: () {
                                        Get.to(() => LiveVerificationScreen())?.then((_) {
                                          // This will be called when coming back from LiveVerificationScreen
                                          controller.fetchProfile();
                                        });

                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    icon: Icon(OwnIcons.face_verification),
                                    label: Text(
                                      'Live Verification',
                                      style: TextStyle(
                                        color: const Color(
                                          0xFF67666B,
                                        ) /* Grey-70 */,
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        height: 1.71,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const Gap(30),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: Colors.white /* white */,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: const Color(0xFFF0F1F5) /* Grey-10 */,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'About ${profile.fullName ?? 'N/A'}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.50,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await Get.to(EditAboutProfileScreen());
                                  controller.fetchProfile();
                                },
                                icon: Icon(OwnIcons.edit_icon),
                              ),
                            ],
                          ),
                          Divider(),
                          const Gap(24),
                          Row(
                            children: [
                              Icon(OwnIcons.education_icon, size: 18),
                              const Gap(16),
                              Expanded(
                                child: Text(
                                  'My Hobby: ${profile.profile?.school ?? "N/A"}',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF67666B,
                                    ) /* Grey-70 */,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(16),
                          Row(
                            children: [
                              Icon(OwnIcons.work_icon, size: 18),
                              const Gap(16),
                              Expanded(
                                child: Text(
                                  'My work: ${profile.profile?.work ?? "N/A"}',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF67666B,
                                    ) /* Grey-70 */,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Icon(
                                  OwnIcons.where_live_in_icon,
                                  size: 18,
                                ),
                              ),
                              const Gap(16),
                              Expanded(
                                child: Text(
                                  'Where I live: ${profile.profile?.address ?? "N/A"}',
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF67666B,
                                    ) /* Grey-70 */,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Icon(OwnIcons.message_2_icon, size: 18),
                              ),
                              const Gap(16),

                              Expanded(
                                child: Text(
                                  'Languages I speak: ${profile.profile?.languages.join(",")}',

                                  // maxLines: 2,
                                  style: TextStyle(
                                    color: const Color(0xFF67666B), // Grey-70
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Gap(16),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                            onPressed: () async {
                              TextEditingController confirmPasswordController = TextEditingController();

                              await showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return Obx(() {
                                    return AlertDialog(
                                      title: const Text(
                                        "Please enter password to confirm delete this account.",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      content: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CustomInputText(
                                            controller: confirmPasswordController,
                                            helperText: "Password",
                                            keyboardType: TextInputType.visiblePassword,
                                            obscureText: true,
                                            onChange: (value) {
                                              if (value.isNotEmpty &&
                                                  controller.deleteAccountError.isNotEmpty) {
                                                controller.deleteAccountError.value = '';
                                              }
                                            },
                                          ),
                                          if (controller.deleteAccountError.isNotEmpty) const SizedBox(height: 8),
                                          if (controller.deleteAccountError.isNotEmpty)
                                            Text(
                                              controller.deleteAccountError.value,
                                              style: const TextStyle(color: Colors.red),
                                            ),
                                        ],
                                      ),
                                      actionsPadding:
                                      const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                                      contentPadding:
                                      const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                      titlePadding:
                                      const EdgeInsets.fromLTRB(24, 24, 24, 16),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.black87,
                                            textStyle: const TextStyle(fontWeight: FontWeight.w800),
                                          ),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: controller.isDeletingAccount.value
                                              ? null
                                              : () {
                                            controller.deleteAccount(
                                              password: confirmPasswordController.text,
                                            );
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            textStyle: const TextStyle(fontWeight: FontWeight.w800),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text("Confirm"),
                                              if (controller.isDeletingAccount.value)
                                                const SizedBox(width: 8),
                                              if (controller.isDeletingAccount.value)
                                                const SizedBox(
                                                  height: 15,
                                                  width: 15,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              );

                              controller.deleteAccountError.value = '';
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)
                              ),
                              foregroundColor: Colors.red,
                              textStyle: TextStyle(
                                fontSize: 16
                              )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Delete account"),
                                Icon(Icons.delete_forever)
                              ],
                            )
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reviews',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                          SizedBox(
                            height: 22,
                            child: TextButton(
                              onPressed: () {
                                Get.to(GuestReviewScreen());
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero
                              ),
                              child: Text(
                              'See All',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            )),
                          )
                        ],
                      ),
                    ),
                    if (profile.latestReviews!.isNotEmpty)
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: ShapeDecoration(
                          color: Colors.white /* white */,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.50,
                              color: const Color(0xFFF0F1F5) /* Grey-10 */,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Column(
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProfileAvatarWidget(
                                    // url: 'https://lh3.googleusercontent.com/-RGea0b3BCro/AAAAAAAAAAI/AAAAAAAAAAA/ALKGfkkUq0FoFSutOFhSIYegrjyaH5bJtg/photo.jpg',
                                    url:
                                        profile
                                                        .latestReviews?[0]
                                                        .reviewBy
                                                        .image ==
                                                    null ||
                                                profile
                                                        .latestReviews?[0]
                                                        .reviewBy
                                                        .image ==
                                                    ''
                                            ? ''
                                            : "${profile.latestReviews?[0].reviewBy.image}",
                                    radius: 30,
                                  ),
                                  const Gap(16),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10.0,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                profile
                                                        .latestReviews?[0]
                                                        .reviewBy
                                                        .fullName ??
                                                    '',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  height: 1.50,
                                                ),
                                              ),
                                              Text(
                                                profile
                                                        .latestReviews?[0]
                                                        .reviewBy
                                                        .uType ??
                                                    '',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 8,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          MainUtils.formatDateMonth(
                                            profile.latestReviews![0].createdAt,
                                          ),
                                          //'Feb 14 2025',
                                          style: TextStyle(
                                            color: const Color(
                                              0xFF67666B,
                                            ) /* Grey-70 */,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 1.50,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(16),
                            Text(
                              'Feedback',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                            buildRatingStars(
                              profile.latestReviews![0].rating.toDouble(),
                            ),

                            const Gap(16),
                            Text(
                              profile.latestReviews![0].review,
                              style: TextStyle(
                                color: const Color(0xFF67666B) /* Grey-70 */,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 1.50,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Gap(16),
                    controller.profile.value?.latestReviews?.length == 0
                        ? Text("No Review Yet!")
                        : OutlinedButton(
                          // margin: EdgeInsets.symmetric(vertical: 26),
                          onPressed: () {
                            Get.to(
                            //  YourReviewScreen(data: profile.latestReviews),
                                GuestReviewScreen()
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white /* white */,
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.8,
                                color: const Color(0xFFF0F1F4) /* Grey-10 */,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your Reviews',
                                style: TextStyle(
                                  color: const Color(0xFF67666B) /* Grey-70 */,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                              const Gap(22),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 18,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                   if(  controller.profile.value!.uType=="host")
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Listings',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                          SizedBox(
                            height: 22,
                            // child: TextButton(
                            //     onPressed: () {
                            //
                            //     },
                            //     style: TextButton.styleFrom(
                            //         padding: EdgeInsets.zero
                            //     ),
                            //     child: Text(
                            //       'See All',
                            //       style: TextStyle(
                            //         color: Colors.black,
                            //         fontSize: 12,
                            //         fontFamily: 'Inter',
                            //         fontWeight: FontWeight.w400,
                            //         height: 1.50,
                            //       ),
                            //     )),
                          ),
                        ],
                      ),
                    ),
                    if(  controller.profile.value!.uType=="host")
                    profile.listings == null
                        ? Text("No Listing Yet!")
                        : profile.listings!.isEmpty
                        ? Text("No Listing Yet!")
                        : InkWell(
                          onTap: () => mainControl.uType.value == 'host' ? {ListingBinding().dependencies(),Get.to(() => EditListingScreen(), arguments: {'id': profile.listings![0].uniqueId})} : Get.to(PublicListingDetailsView(), arguments: {'id': profile.listings![0].uniqueId }),
                          child: Container(
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: const Color(0xFFF0F1F5) /* Grey-10 */,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),

                            child: Column(
                              children: [
                                Container(
                                  height: 193,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image:
                                          profile.listings?[0].coverPhoto != ''
                                              ? NetworkImage(
                                                "${profile.listings?[0].coverPhoto}",
                                              )
                                              : NetworkImage(
                                                "https://media.cnn.com/api/v1/images/stellar/prod/140127103345-peninsula-shanghai-deluxe-mock-up.jpg",
                                              ),
                                      fit: BoxFit.cover,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    spacing: 6,
                                    children: [
                                      Text(
                                        profile.listings?[0].title ?? "N/A",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: const Color(
                                            0xFF004E70,
                                          ) /* Info */,
                                          fontSize: 16,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          height: 1.50,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          buildRatingStars(
                                            double.parse(
                                              "${profile.listings?[0].avgRating}",
                                            ),
                                          ),
                                          Text(
                                            '(${profile.listings?[0].avgRating})',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color(
                                                0xFF67666B,
                                              ) /* Grey-70 */,
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 1.50,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // OutlinedButton(
                                          //     onPressed: () {
                                          //
                                          //     },
                                          //     style: OutlinedButton.styleFrom(
                                          //         shape: RoundedRectangleBorder(
                                          //             borderRadius: BorderRadius.circular(6)
                                          //         )
                                          //     ),
                                          //     child: Text(
                                          //       'Price: 00/- night',
                                          //       style: TextStyle(
                                          //         color: Colors.black /* Black */,
                                          //         fontSize: 16,
                                          //         fontFamily: 'Inter',
                                          //         fontWeight: FontWeight.w500,
                                          //         height: 1.50,
                                          //       ),
                                          //     )
                                          // ),
                                          Expanded(
                                            child: Text(
                                              profile.listings?[0].address == ''
                                                  ? "N/A"
                                                  : profile.listings![0].address,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: 40,
                                          //   height: 40,
                                          //   child: ElevatedButton(
                                          //     onPressed: () {},
                                          //     style: OutlinedButton.styleFrom(
                                          //       shape: RoundedRectangleBorder(
                                          //         borderRadius:
                                          //             BorderRadius.circular(6),
                                          //       ),
                                          //       backgroundColor:
                                          //           Colors.grey.shade200,
                                          //       padding: EdgeInsets.zero,
                                          //     ),
                                          //     child: Padding(
                                          //       padding: const EdgeInsets.only(right: 7.0),
                                          //       child: Icon(
                                          //         OwnIcons.favourite_icon,
                                          //         color: Colors.deepOrangeAccent,
                                          //         size: 22,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    const Gap(22),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showAboutIdentityVerification(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'What is identity verification?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                height: 28,
                width: 28,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(padding: EdgeInsets.zero),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ],
          ),
          content: const Text(
            'Someone being "Identity verified," or having an identity verification badge, only means that they have provided info in order to complete our identity verification process.\nThis process has safeguards, but is not a guarantee that someone is who they claim to be.',
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }
}

Widget buildRatingStars(double rating) {
  const int totalStars = 5;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(totalStars, (index) {
      if (index < rating.floor()) {
        // Full star
        return Icon(Icons.star, color: Colors.orangeAccent, size: 20);
      } else if (index < rating && rating - index >= 0.5) {
        // Half star
        return Icon(Icons.star_half, color: Colors.orangeAccent, size: 20);
      } else {
        // Empty star
        return Icon(Icons.star, color: Colors.grey, size: 20);
      }
    }),
  );
}

// Hello I am Tamim