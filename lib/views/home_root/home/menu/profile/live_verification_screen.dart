import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stayverz_flutter_app/controllers/profile_controller.dart';
import '../../../../../features/listing/controllers/listing_controller.dart';
import '../../../../../widgets/own_title_app_bar.dart';

class LiveVerificationScreen extends StatefulWidget {
  const LiveVerificationScreen({super.key});

  @override
  State<LiveVerificationScreen> createState() => _LiveVerificationScreenState();
}

class _LiveVerificationScreenState extends State<LiveVerificationScreen> {
  final ListingController controller = Get.find<ListingController>();
  final ProfileController profileController = Get.find<ProfileController>();


  File? livePhoto;
  File? voterFront;
  File? voterBack;

  final RxBool isSubmitting = false.obs;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      Fluttertoast.showToast(msg: "Camera permission is required.");
    }
  }

  Future<File?> _captureImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  Future<void> uploadAndSubmit() async {
    if (livePhoto == null || voterFront == null || voterBack == null) {
      Fluttertoast.showToast(msg: "Please capture all required images.");
      return;
    }

    if (isSubmitting.value) return;
    isSubmitting.value = true;

    final filePaths = [livePhoto!.path, voterFront!.path, voterBack!.path];
    final uploadedUrls = await controller.uploadMultiplePhotos(filePaths);

    if (uploadedUrls.length < 3) {
      isSubmitting.value = false;
      Fluttertoast.showToast(msg: "Failed to upload one or more images.");
      return;
    }

    try {
      await profileController.submitDocument(
        documentType: "live",
        live: "${uploadedUrls[0]},${uploadedUrls[1]},${uploadedUrls[2]}",
      );
      Fluttertoast.showToast(msg: "Documents submitted successfully!");
    } catch (e) {
      Fluttertoast.showToast(msg: "Submission failed.");
    } finally {
      isSubmitting.value = false;
    }
  }

  Widget _buildImageSection(String label, File? image, VoidCallback onTap) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Gap(8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade400),
              image: image != null
                  ? DecorationImage(image: FileImage(image), fit: BoxFit.cover)
                  : const DecorationImage(
                image: AssetImage("assets/default_image.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: image == null
                ? const Center(
              child: Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey),
            )
                : null,
          ),
        ),
        const Gap(16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Live Verification',
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Column(
          children: [
            const Text(
              'Please capture the following photos using your phone\'s camera.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
            const Gap(24),

            _buildImageSection("1. Live Photo", livePhoto, () async {
              // final image = await _captureImage();
              // if (image != null) setState(() => livePhoto = image);

              final image = await _captureImage();
              if (image != null) {
                final file = File(image.path);
                if (await file.exists()) {
                  final fileSize = await file.length();
                  const maxSizeInBytes = 20 * 1024 * 1024; // 20 MB

                  if (fileSize > maxSizeInBytes) {
                    Fluttertoast.showToast(
                      msg: "Live photo exceeds 20 MB. Please retake a smaller image.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                    );
                    return;
                  }
                }

                setState(() => livePhoto = image);
              }
            }),

            _buildImageSection("2. NID/Passport/Driving licence - Front", voterFront, () async {
              final image = await _captureImage();

              if (image != null) {
                final file = File(image.path);
                if (await file.exists()) {
                  final fileSize = await file.length();
                  const maxSizeInBytes = 20 * 1024 * 1024; // 20 MB

                  if (fileSize > maxSizeInBytes) {
                    Fluttertoast.showToast(
                      msg: "Live photo exceeds 20 MB. Please retake a smaller image.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                    );
                    return;
                  }
                }

                setState(() => voterFront = image);
              }

              // if (image != null) setState(() => voterFront = image);
            }),

            _buildImageSection("3. NID/Passport/Driving licence - Back", voterBack, () async {
              final image = await _captureImage();

              if (image != null) {
                final file = File(image.path);
                if (await file.exists()) {
                  final fileSize = await file.length();
                  const maxSizeInBytes = 20 * 1024 * 1024; // 20 MB

                  if (fileSize > maxSizeInBytes) {
                    Fluttertoast.showToast(
                      msg: "Live photo exceeds 20 MB. Please retake a smaller image.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                    );
                    return;
                  }
                }

                setState(() => voterBack = image);
              }

              // if (image != null) setState(() => voterBack = image);
            }),

            const Gap(24),
            Obx(
                  () => ElevatedButton.icon(
                onPressed: isSubmitting.value ? null : uploadAndSubmit,
                icon: isSubmitting.value
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
                    : const Icon(Icons.cloud_upload),
                label: Text(
                  isSubmitting.value ? "Submitting..." : "Submit",
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
            Gap(20),
          ],
        ),
      ),
    );
  }
}

// Hello I am Tamim