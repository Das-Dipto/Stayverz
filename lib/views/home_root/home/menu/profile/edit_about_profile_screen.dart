import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../services/network/error_display_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stayverz_flutter_app/core/constants/app_colors.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';
import 'package:stayverz_flutter_app/widgets/profile_avatar_widget.dart';
import '../../../../../controllers/profile_controller.dart';
import '../../../../../features/listing/controllers/listing_controller.dart';
import '../../../../../features/listing/models/map_suggestions_response_model.dart';
import '../../../../../widgets/own_title_app_bar.dart';
import 'languages_you_speak_screen.dart';

class EditAboutProfileScreen extends StatefulWidget {
  const EditAboutProfileScreen({super.key});

  @override
  State<EditAboutProfileScreen> createState() => _EditAboutProfileScreenState();
}

class _EditAboutProfileScreenState extends State<EditAboutProfileScreen> {
  RxBool enableCoHost = RxBool(false);
  final ListingController controller = Get.find<ListingController>();
  final ProfileController profileController = Get.find<ProfileController>();


  late TextEditingController searchController;


  Future<void> _loadProfile() async {
    try {
      await profileController.fetchProfile();
    } catch (e) {
      Get.find<ErrorDisplayManager>().showError('Failed to load profile');
    }
  }
  var localImagePath = ''.obs;
  RxBool isSubmitting = false.obs;
  File? _imageFile;
  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _imageFile = File(image.path);                // ✅ Assign to _imageFile
      localImagePath.value = image.path;            // ✅ Update UI
      await uploadAndSubmit();                      // ✅ Auto-upload after selection
    }
  }

  Future<void> uploadAndSubmit() async {
    if (_imageFile == null || isSubmitting.value) return;

    isSubmitting.value = true;

    final filePath = _imageFile!.path;

    try {
      // Upload image(s) and get URLs
      final List<String> uploadedUrls = await controller.uploadMultiplePhotos([filePath]);

      if (uploadedUrls.isEmpty) {
        isSubmitting.value = false;
        return;
      }

      // Delete local file after upload
      final file = File(filePath);
      if (await file.exists()) {
       // await file.delete();
      } else {
      }

      final String imageUrl = uploadedUrls[0];

      // Continue your flow after successful upload and deletion
      await profileController.patchImageUpload(imageUrl);
     // profileController.fetchProfile();
    } catch (e, stacktrace) {
      // Handle any errors
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // searchController.addListener(() {
    //   searchText.value = searchController.text;
    // });

    // Debounce search input to avoid spamming API calls

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Edit About Profile',
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Obx(() {
          if (profileController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (profileController.error.value.isNotEmpty) {
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
          final profile = profileController.profile.value;
          if (profile == null) {
            return const Center(child: Text('No profile data available'));
          }
          List<String> languages = profile.profile?.languages??[];


          return Column(
            children: [
              Gap(10),
              Stack(
                children: [
                  Obx(() {
                    final path = localImagePath.value;
                    // Check if path is not empty AND file actually exists
                    if (path.isNotEmpty) {
                      final file = File(path);
                      if (file.existsSync()) {
                        return CircleAvatar(
                          radius: 40,
                          backgroundImage: FileImage(file),
                        );
                      }
                    }
                    // Fallback to network image in ProfileAvatarWidget
                    return ProfileAvatarWidget(
                      url: profile.image ?? '',
                      radius: 40,
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImageFromGallery,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const Gap(24),
                    InkWell(
                      onTap: () {
                        TextEditingController controller =
                        TextEditingController();
                        _showHobbyInterestDialog(
                          context: context,
                          title: 'What is your hobby/Interest??',
                          description: 'Add some writing your hobby/Interest?.',
                          labelText: 'What is your hobby/Interest?',
                          helperText: 'Write you hobby/interest',
                          controller: controller,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            Icon(OwnIcons.education_icon, size: 18),
                            const Gap(16),
                            Expanded(
                              child: Text(
                                'What is your hobby/Interest: ${profile.profile?.school??"N/A"}',
                                style: TextStyle(
                                  color: const Color(0xFF67666B) /* Grey-70 */,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_outlined, size: 18),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 48, thickness: 0.8),
                    InkWell(
                      onTap: () {
                        TextEditingController controller =
                        TextEditingController();
                        _showHobbyInterestDialog(
                          context: context,
                          title: 'Your Profession?',
                          description:
                          'Tell us what your profession is. If you don\'t have a traditional job, tell us your life\'s calling. Example: Nurse, parent to four kids, or retired surfer.',
                          labelText: 'Where I went to work?',
                          helperText: 'Self Business',
                          controller: controller,
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            Icon(OwnIcons.work_icon, size: 18),
                            const Gap(16),
                            Expanded(
                              child: Text(
                                'My work: ${profile.profile?.work ?? "N/A"}',
                                style: TextStyle(
                                  color: const Color(0xFF67666B) /* Grey-70 */,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_outlined, size: 18),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 48, thickness: 0.8),
                    InkWell(
                      onTap: _showModalBottomShowForWhereILive,
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
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
                                  'My Location: ${profile.profile?.address}',
                                  style: TextStyle(
                                    color: const Color(0xFF67666B) /* Grey-70 */,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Divider(height: 48, thickness: 0.8),
                    InkWell(
                      onTap: () async {
                        await Get.to(LanguagesYouSpeakScreen());
                        profileController.fetchProfile();  // called after LanguagesYouSpeakScreen is popped
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
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
                                style: const TextStyle(
                                  color: Color(0xFF67666B), // Grey-70
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_outlined, size: 18),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 48, thickness: 0.8),
                    InkWell(
                      onTap: (){
                        TextEditingController controller =
                        TextEditingController();
                        _showHobbyInterestDialog(
                          context: context,
                          title: 'Your Bio?',
                          description:
                          'Tell us about your Bio',
                          labelText: 'Wright bio',
                          helperText: 'Bio',
                          controller: controller,
                        );
                      },
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Expanded(
                                child: Text(
                                  'Your Bio: ${profile.profile?.bio}',
                                  style: TextStyle(
                                    color: const Color(0xFF67666B) /* Grey-70 */,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 48, thickness: 0.8),
                    InkWell(
                      onTap: () {
                        _showGenderSelectionPopup();
                      },
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Expanded(
                                child: Text(
                                  'Gender: ${profile.profile?.gender??''}', // You should replace 'Male' with your current gender variable
                                  style: TextStyle(
                                    color: const Color(0xFF67666B),
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 1.50,
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(height: 48, thickness: 0.8),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your Email',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                      decoration: ShapeDecoration(
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
                            'Write your email',
                            style: TextStyle(
                              color: const Color(0xFF67666B) /* Grey-70 */,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                          const Gap(14),
                          if(profile.email!=null||profile.email!='')
                            Text(
                              '${profile.email}',
                              style: TextStyle(
                                color: const Color(0xFF67666B) /* Grey-70 */,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),
                          if(profile.email!=null||profile.email!='')
                          const Gap(14),
                          Row(
                            children: [
                              SizedBox(
                                height: 26,
                                child: TextButton(
                                  onPressed: () {
                                    TextEditingController controller = TextEditingController();
                                    _showHobbyInterestDialogEmail(
                                      context: context,
                                        title:(profile.email == null || profile.email=='')
                                            ? 'Add Email'
                                            : 'Edit Email',
                                        description: 'Tell us your email to verify',
                                        labelText: 'Email',
                                        helperText: 'Enter email adress',
                                        controller: controller
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.only(right: 8),
                                  ),
                                  child: Text(
                                    (profile.email == null || profile.email=='')
                                        ? 'Add Email'
                                        : 'Edit Email',
                                    style: TextStyle(
                                      color: Colors.black /* Black */,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      height: 1.50,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gap(20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your Emergency Contact',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                      decoration: ShapeDecoration(
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
                            'Write your emergency contact',
                            style: TextStyle(
                              color: const Color(0xFF67666B) /* Grey-70 */,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                          const Gap(14),
                          if(profile.email!=null||profile.email!='')
                            Text(
                              '${profile.profile?.emergencyContact??"01xxxx"}',
                              style: TextStyle(
                                color: const Color(0xFF67666B) /* Grey-70 */,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.50,
                              ),
                            ),

                          if(profile.email!=null||profile.email!='')
                            const Gap(14),

                          Row(
                            children: [
                              SizedBox(
                                height: 26,
                                child: TextButton(
                                  onPressed: () => showEmergencyContactDialog(context),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.only(right: 8),
                                  ),
                                  child: Text(
                                    (profile.email!=null||profile.email!='')?'Add Emergency Contact':"Edit Phone",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      height: 1.50,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              // SizedBox(
              //   width: 160,
              //   child: OutlinedButton(
              //     onPressed: () {},
              //     style: OutlinedButton.styleFrom(
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(6),
              //       ),
              //     ),
              //     child: Text(
              //       'Save',
              //       textAlign: TextAlign.center,
              //       style: TextStyle(
              //         color: Colors.black /* Black */,
              //         fontSize: 16,
              //         fontFamily: 'Inter',
              //         fontWeight: FontWeight.w600,
              //         height: 1.50,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
        },),
      ),
    );
  }

  void _showHobbyInterestDialog({
    required BuildContext context,
    required String title,
    required String description,
    required String labelText,
    required String helperText,
    required TextEditingController controller,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(width: 0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
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
          ),
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                labelText,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 6),
              CustomInputText(controller: controller, helperText: helperText),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    String inputText = controller.text.trim();
                    if (inputText.isEmpty) {
                      Get.find<ErrorDisplayManager>().showError('Please enter your hobby/interest');
                      return;
                    }
                    try {
                      final profileController = Get.find<ProfileController>();

                      if (helperText == "Write you hobby/interest") {
                        await profileController.patchUserSchool(inputText);
                      }
                      if (helperText == "Self Business") {
                        await profileController.patchUserWork(inputText);
                      }
                      if (helperText == "Bio") {
                        await profileController.patchUserBio(inputText);
                      }
                      if (helperText == "My Address") {
                        await profileController.patchUserBio(inputText);
                      }

                      profileController.fetchProfile();
                      Navigator.pop(context);
                    } catch (e) {
                      Get.find<ErrorDisplayManager>().showError('Something went wrong. Try again.');
                      Navigator.pop(context);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Save',
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
              ),
            ],
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  void _showHobbyInterestDialogEmail({
    required BuildContext context,
    required String title,
    required String description,
    required String labelText,
    required String helperText,
    required TextEditingController controller,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isLoading = false;

            return AlertDialog(
              title: Container(
                padding: const EdgeInsets.only(bottom: 10),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 0.4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
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
              ),
              scrollable: true,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    labelText,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 6),
                  CustomInputText(controller: controller, helperText: helperText),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                        String inputText = controller.text.trim();
                        final emailRegex =
                        RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

                        if (inputText.isEmpty) {
                          Get.find<ErrorDisplayManager>().showError('Please enter your email');
                          return;
                        } else if (!emailRegex.hasMatch(inputText)) {
                          Get.snackbar(
                              'Invalid Email',
                              'Please enter a valid email address');
                          return;
                        }

                        setState(() => isLoading = true);

                        try {
                          final profileController =
                          Get.find<ProfileController>();

                          await profileController.requestEmailUpdate(
                            email: inputText,
                            scope: 'email_verify',
                          );

                          Navigator.pop(context); // ✅ native close
                          _showOtpDialog(context,inputText); // open OTP dialog
                        } catch (e) {
                          Get.snackbar(
                              'Error', 'Something went wrong. Try again.');
                          Navigator.pop(context);
                        } finally {
                          if (Navigator.of(context).mounted) {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.black),
                      )
                          : const Text(
                        'Save',
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
                  ),
                ],
              ),
              backgroundColor: Colors.white,
            );
          },
        );
      },
    );
  }


  void _showOtpDialog(BuildContext context, String email) {
    final TextEditingController otpController = TextEditingController();
    final profileController = Get.find<ProfileController>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isLoading = false;

            return AlertDialog(
              title: const Text(
                'Enter OTP',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Please enter the 5-digit OTP sent to your email.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: otpController,
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                      hintText: 'Enter OTP',
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    String otp = otpController.text.trim();
                    if (otp.length != 5 ||
                        !RegExp(r'^\d{5}$').hasMatch(otp)) {
                      Get.snackbar('Invalid OTP',
                          'Please enter a valid 5-digit OTP.');
                      return;
                    }

                    setState(() => isLoading = true);

                    try {
                      var data = await profileController
                          .requestEmailUpdateOtpSubmit(
                        email: email,
                        otp: otp,
                        otpVerify: true,
                      );

                      profileController.fetchProfile();

                      Navigator.pop(context); // close OTP dialog
                    } catch (e) {
                      // Error handled in controller
                    } finally {
                      if (Navigator.of(context).mounted) {
                        setState(() => isLoading = false);
                      }
                    }
                  },
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Verify'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  _showModalBottomShowForWhereILive() {
    Get.bottomSheet(
      WhereILiveBottomSheet(),
      enableDrag: false,
      elevation: 6,
      isDismissible: false,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
    );
  }

  void _showGenderSelectionPopup() {
    final RxString selectedGender = ''.obs;  // to track selected option
    final RxBool isLoading = false.obs;

    Get.defaultDialog(
      title: 'Select Gender',
      content: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Male'),
              value: 'Male',
              groupValue: selectedGender.value,
              onChanged: (value) {
                selectedGender.value = value!;
              },
            ),
            RadioListTile<String>(
              title: const Text('Female'),
              value: 'Female',
              groupValue: selectedGender.value,
              onChanged: (value) {
                selectedGender.value = value!;
              },
            ),
            SizedBox(height: 12),
            isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: selectedGender.value.isEmpty
                  ? null
                  : () async {
                isLoading.value = true;
                try {
                  await profileController.patchUserGender(selectedGender.value);
                  profileController.fetchProfile();
                  Get.back(); // close popup on success
                  Get.snackbar('Success', 'Gender updated successfully!');
                  // Optionally update the UI to show the new gender here
                } catch (e) {
                  Get.find<ErrorDisplayManager>().showError('Failed to update gender');
                } finally {
                  isLoading.value = false;
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange, // Set orange background
                foregroundColor: Colors.white,  // Optional: white text for contrast
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      }),
    );
  }

  void showEmergencyContactDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              titlePadding: EdgeInsets.fromLTRB(24, 24, 8, 0),
              contentPadding: EdgeInsets.fromLTRB(24, 16, 24, 24),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter Emergency Contact',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[600], size: 24),
                    splashRadius: 20,
                    onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter 11-digit number',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          counterText: '',
                        ),
                        style: TextStyle(fontSize: 16),
                        validator: (value) {
                          if (value == null ||
                              value.trim().length != 11 ||
                              !RegExp(r'^\d{11}$').hasMatch(value.trim())) {
                            return 'Please enter a valid 11-digit number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                          if (!formKey.currentState!.validate()) return;

                          setState(() {
                            isLoading = true;
                          });

                          try {
                            await profileController.patchUserEmgContract(controller.text.trim());
                            profileController.fetchProfile();
                            Navigator.of(context).pop();
                            Get.snackbar('Success', 'Emergency contact updated successfully!');
                          } catch (e) {
                            // error handled inside patchUserEmgContract
                          } finally {
                            if (context.mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                            : Text(
                          'Submit',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}

class WhereILiveBottomSheet extends StatelessWidget {
  WhereILiveBottomSheet({super.key});

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final ListingController controller = Get.find<ListingController>();
  final ProfileController profile = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: Obx(() => GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: _kGooglePlex,
            markers: controller.selectedMarker.value != null
                ? {controller.selectedMarker.value!}
                : {},
            onMapCreated: (GoogleMapController mapController) {
              _controller.complete(mapController);
            },
            onTap: (location) {
              FocusScope.of(context).unfocus();
            },
          )),
        ),
        Container(
          margin: const EdgeInsets.all(6),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Expanded(
                child: TypeAheadField<PlaceSuggestion>(
                  controller: controller.suggestionController,
                  builder: (context, textController, focusNode) => TextField(
                    controller: textController,
                    focusNode: focusNode,
                    autofocus: true,
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontStyle: FontStyle.italic),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                      isDense: true,
                      isCollapsed: true,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                  ),
                  decorationBuilder: (context, child) => Material(
                    type: MaterialType.card,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(6),
                    child: child,
                  ),
                  itemBuilder: (context, suggestion) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const Gap(6),
                        Expanded(child: Text(suggestion.address ?? '')),
                      ],
                    ),
                  ),
                  onSelected: onSuggestionSelected,
                  suggestionsCallback: suggestionsCallback,
                  itemSeparatorBuilder: itemSeparatorBuilder,
                  listBuilder: gridLayoutBuilder,
                ),
              ),
              const Gap(8),
              IconButton.filled(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  elevation: 6,
                ),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
              IconButton.filled(
                onPressed: () {
                  // Save or confirm action
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  elevation: 6,
                ),
                icon: const Icon(Icons.check, color: Colors.white),
              ),
            ],
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          bottom: 10,
          child: GestureDetector(
            onTap: () async {
              final selectedPlace = controller.selectedPlace.value;

              if (selectedPlace != null) {
                final lat = double.tryParse(selectedPlace.latitude ?? '');
                final lng = double.tryParse(selectedPlace.longitude ?? '');
                final address = selectedPlace.address ?? '';

                if (lat != null && lng != null) {
                  await profile.patchUserAddressLocation(
                    address: address,
                    latitude: lat,
                    longitude: lng,
                  );

                  Get.back();
                  profile.fetchProfile();// close bottom sheet after success
                } else {
                  Get.find<ErrorDisplayManager>().showError('Invalid location coordinates.');
                }
              } else {
                Get.snackbar('Warning', 'Please select a location from search.');
              }
            },
            child: Container(
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Save",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onSuggestionSelected(PlaceSuggestion suggestion) async {
    controller.selectedPlace.value = suggestion;
    controller.suggestionController.text = suggestion.address ?? '';

    final double? lat = double.tryParse(suggestion.latitude ?? '');
    final double? lng = double.tryParse(suggestion.longitude ?? '');

    if (lat != null && lng != null) {
      final GoogleMapController mapController = await _controller.future;

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 16.0,
          ),
        ),
      );

      controller.selectedMarker.value = Marker(
        markerId: const MarkerId('selected-location'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: suggestion.address),
      );
    } else {
    }
  }

  Widget itemSeparatorBuilder(BuildContext context, int index) =>
      const Gap(2);

  Widget gridLayoutBuilder(BuildContext context, List<Widget> items) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      children: items,
    );
  }

  Future<List<PlaceSuggestion>> suggestionsCallback(String pattern) async =>
      controller.onPlaceSearchChange(pattern);
}


// Hello I am Tamim