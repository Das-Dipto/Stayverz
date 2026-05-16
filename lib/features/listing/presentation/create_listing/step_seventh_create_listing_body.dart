import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../widgets/compress_file.dart';
import '../../controllers/listing_controller.dart';

class StepSeventhCreateListingBody extends GetView<ListingController> {
  StepSeventhCreateListingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share some photos of your place',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const Gap(12),
        const Text(
          'You can add more later',
          style: TextStyle(
            color: Color(0xFF33496C),
            fontSize: 16,
            height: 1.5,
          ),
        ),
        const Gap(24),

        /// Uploading loader
        Obx(() => controller.isUploadingPhotos.value
            ? const Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              Gap(12),
              Text("Uploading photos..."),
            ],
          ),
        )
            : Column(
          children: [
            _categoryTile(
              context,
              title: "General Images",
              category: "images",
              icon: Icons.photo_library,
            ),
            _categoryTile(
              context,
              title: "Living Room",
              category: "living_room_images",
              icon: Icons.weekend,
            ),
            _categoryTile(
              context,
              title: "Kitchen",
              category: "kitchen_images",
              icon: Icons.kitchen,
            ),
            _categoryTile(
              context,
              title: "Bedroom",
              category: "bedroom_images",
              icon: Icons.bed,
            ),
            _categoryTile(
              context,
              title: "Bathroom",
              category: "bathroom_images",
              icon: Icons.bathtub,
            ),
            _categoryTile(
              context,
              title: "Washroom",
              category: "washroom_images",
              icon: Icons.wash,
            ),
          ],
        )),
        const Gap(24),
      ],
    );
  }

  /// ---------- CATEGORY TILE ----------
  Widget _categoryTile(
      BuildContext context, {
        required String title,
        required String category,
        required IconData icon,
      }) {
    return Obx(() {
      final images = controller.getCategoryImages(category);
      final isCoverCategory = controller.coverImageCategory.value == category;

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF0F1F5)),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text("${images.length} image(s)"),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isCoverCategory)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "Cover",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
          onTap: () {
            openPhotoUploadBottomSheet(
              context,
              controller,
              category,
            );
          },
        ),
      );
    });
  }
  void openPhotoUploadBottomSheet(
      BuildContext context,
      controller,
      String imageCategory,
      ) {
    final RxList<XFile> selectedNewImages = <XFile>[].obs;

    // Load existing images for this category
    final RxList<String> existingUrls =
        List<String>.from(controller.getCategoryImages(imageCategory)).obs;

    final RxString coverImageUrl = ''.obs;
    final RxInt coverImageIndex = (-1).obs;
    final RxBool isCoverFromExisting = true.obs;
    final RxBool isCompressing = false.obs;

    final Map<String, String> categoryNames = {
      'images': 'General Images',
      'living_room_images': 'Living Room',
      'kitchen_images': 'Kitchen',
      'bathroom_images': 'Bathroom',
      'bedroom_images': 'Bedroom',
      'washroom_images': 'Washroom',
    };

    // Pre-select cover image if it exists in this category
    if (controller.coverImageUrl.value.isNotEmpty &&
        existingUrls.contains(controller.coverImageUrl.value)) {
      coverImageUrl.value = controller.coverImageUrl.value;
      coverImageIndex.value = existingUrls.indexOf(controller.coverImageUrl.value);
      isCoverFromExisting.value = true;
    }

    final ImagePicker picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return WillPopScope(
          onWillPop: () async {
            if (isCompressing.value || controller.isUploadingPhotos.value) {
              Fluttertoast.showToast(
                msg: "Please wait for the process to complete",
                gravity: ToastGravity.TOP,
              );
              return false;
            }
            return true;
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16.0,
              16,
              16,
              MediaQuery.of(context).viewInsets.bottom + 50,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Bar with Category Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Upload Photos",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            categoryNames[imageCategory] ?? imageCategory,
                            style: TextStyle(
                              fontSize: 14,
                              color: imageCategory == 'images'
                                  ? Colors.blue
                                  : Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          if (!isCompressing.value &&
                              !controller.isUploadingPhotos.value) {
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                              msg: "Please wait for the process to complete",
                              gravity: ToastGravity.TOP,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Compression Status
                  Obx(() => isCompressing.value
                      ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Compressing images...",
                          style: TextStyle(
                            color: imageCategory == 'images'
                                ? Colors.blue
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  )
                      : SizedBox()),

                  // Select New Images Button
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton.icon(
                      onPressed: isCompressing.value ||
                          controller.isUploadingPhotos.value
                          ? null
                          : () async {
                        final images = await picker.pickMultiImage();
                        if (images.isNotEmpty) {
                          isCompressing.value = true;

                          List<XFile> compressedImages = [];
                          for (var image in images) {
                            final compressed = await compressImage(image);
                            if (compressed != null) {
                              compressedImages.add(compressed);
                            } else {
                              compressedImages.add(image);
                            }
                          }

                          selectedNewImages.addAll(compressedImages);
                          isCompressing.value = false;

                          Fluttertoast.showToast(
                            msg: "Added ${compressedImages.length} image(s)",
                            toastLength: Toast.LENGTH_SHORT,
                          );
                        }
                      },
                      icon: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Colors.black87,
                      ),
                      label: Text(
                        "Select Images",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: imageCategory == 'images'
                            ? Colors.blue
                            : Colors.orange,
                        side: BorderSide(color: Colors.grey),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                        shadowColor: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Images Display Area
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Existing Images Section (Show First)
                          Obx(() {
                            if (existingUrls.isEmpty) return SizedBox();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Previously Uploaded (${existingUrls.length})",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (controller.coverImageUrl.value.isNotEmpty &&
                                        existingUrls.contains(controller.coverImageUrl.value))
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.green),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 12,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "Has Cover",
                                              style: TextStyle(
                                                color: Colors.green.shade800,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: existingUrls.length,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    final imageUrl = existingUrls[index];
                                    final isCurrentCover =
                                        controller.coverImageUrl.value == imageUrl;

                                    return Stack(
                                      children: [
                                        // Image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                            loadingBuilder: (context, child, progress) {
                                              if (progress == null) return child;
                                              return Container(
                                                color: Colors.grey.shade200,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    value: progress.expectedTotalBytes != null
                                                        ? progress.cumulativeBytesLoaded /
                                                        progress.expectedTotalBytes!
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder: (_, __, ___) => Container(
                                              color: Colors.grey.shade300,
                                              child: Icon(
                                                Icons.broken_image,
                                                size: 40,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Remove Button
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text("Remove Image"),
                                                    content: const Text(
                                                      "Are you sure you want to remove this image?",
                                                    ),
                                                    actions: [

                                                      /// ❌ Cancel
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child: const Text("Cancel"),
                                                      ),

                                                      /// 🗑 Remove
                                                      TextButton(
                                                        onPressed: () {
                                                          existingUrls.removeAt(index);
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Text(
                                                          "Remove",
                                                          style: TextStyle(color: Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(0.8),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(4),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Cover Image Selector
                                        Positioned(
                                          top: 4,
                                          left: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (isCurrentCover) {
                                                coverImageUrl.value = '';
                                                coverImageIndex.value = -1;
                                              } else {
                                                coverImageUrl.value = imageUrl;
                                                coverImageIndex.value = index;
                                                isCoverFromExisting.value = true;
                                              }
                                            },
                                            child: Obx(
                                                  () => Container(
                                                decoration: BoxDecoration(
                                                  color: coverImageUrl.value == imageUrl
                                                      ? Colors.green
                                                      : Colors.black.withOpacity(0.6),
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 4,
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 14,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      coverImageUrl.value == imageUrl
                                                          ? "Cover"
                                                          : "Set Cover",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Main Cover Badge
                                        if (isCurrentCover)
                                          Positioned(
                                            bottom: 4,
                                            right: 4,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                "MAIN COVER",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 16),
                              ],
                            );
                          }),

                          // New Selected Images Section
                          Obx(() {
                            if (selectedNewImages.isEmpty) return SizedBox();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "New Selected (${selectedNewImages.length})",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 8),
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: selectedNewImages.length,
                                  gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            File(selectedNewImages[index].path),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        ),

                                        // Remove Button
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () =>
                                                selectedNewImages.removeAt(index),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red.withOpacity(0.8),
                                                shape: BoxShape.circle,
                                              ),
                                              padding: EdgeInsets.all(4),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Cover Image Selector
                                        Positioned(
                                          top: 4,
                                          left: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              coverImageUrl.value =
                                                  selectedNewImages[index].path;
                                              coverImageIndex.value = index;
                                              isCoverFromExisting.value = false;
                                            },
                                            child: Obx(
                                                  () => Container(
                                                decoration: BoxDecoration(
                                                  color: coverImageUrl.value ==
                                                      selectedNewImages[index]
                                                          .path
                                                      ? Colors.green
                                                      : Colors.black
                                                      .withOpacity(0.6),
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 4,
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 14,
                                                    ),
                                                    SizedBox(width: 3),
                                                    Text(
                                                      "Cover",
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                SizedBox(height: 16),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const Gap(16),

                  // Save Button
                  Obx(
                        () => GestureDetector(
                      onTap: controller.isUploadingPhotos.value ||
                          isCompressing.value
                          ? null
                          : () async {
                        final newPaths = selectedNewImages
                            .map((img) => img.path)
                            .toList();
                        List<String> newUploadedUrls = [];

                        // Size check
                        int totalBytes = 0;
                        for (final path in newPaths) {
                          final file = File(path);
                          if (await file.exists()) {
                            totalBytes += await file.length();
                          }
                        }

                        const maxSizeInBytes = 20 * 1024 * 1024;

                        if (totalBytes > maxSizeInBytes) {
                          Fluttertoast.showToast(
                            msg:
                            "Total file size exceeds 20 MB. Please select fewer images.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                          );
                          return;
                        }

                        // Upload new images
                        if (newPaths.isNotEmpty) {
                          newUploadedUrls = await controller
                              .uploadCategoryPhotos(newPaths, imageCategory);
                        }

                        // Combine URLs
                        final combinedImageUrls = [
                          ...existingUrls,
                          ...newUploadedUrls,
                        ];

                        // Update category
                        controller.setCategoryImages(
                          imageCategory,
                          combinedImageUrls,
                        );

                        // Set cover image
                        if (coverImageUrl.value.isNotEmpty) {
                          if (isCoverFromExisting.value) {
                            controller.setCoverImage(
                              coverImageUrl.value,
                              imageCategory,
                            );
                          } else {
                            final index = coverImageIndex.value;
                            if (index >= 0 &&
                                index < newUploadedUrls.length) {
                              controller.setCoverImage(
                                newUploadedUrls[index],
                                imageCategory,
                              );
                            }
                          }
                        }

                        // Update backend
                         controller.goNextAfterUploadedPhotosData();

                        Fluttertoast.showToast(
                          msg: newUploadedUrls.isEmpty
                              ? "Updated ${categoryNames[imageCategory]} images"
                              : "Uploaded ${newUploadedUrls.length} new image(s) to ${categoryNames[imageCategory]}",
                        );
                        Get.back();
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 35,
                            vertical: 8,
                          ),
                          decoration: ShapeDecoration(
                            color: controller.isUploadingPhotos.value ||
                                isCompressing.value
                                ? Colors.grey.shade300
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                width: 1,
                                color: Color(0xFFA9A9B0),
                              ),
                            ),
                          ),
                          child: controller.isUploadingPhotos.value ||
                              isCompressing.value
                              ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            "Save",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Hello I am Tamim