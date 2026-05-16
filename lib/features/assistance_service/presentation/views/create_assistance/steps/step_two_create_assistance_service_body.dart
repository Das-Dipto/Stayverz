import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/assistance_service/controllers/assistance_service_controller.dart';
import '../../../../../../core/constants/app_colors.dart';

class StepTwoCreateAssistanceServiceBody extends GetView<AssistanceServiceController> {
  StepTwoCreateAssistanceServiceBody({super.key});

  final List<Map<String, String>> list = [
    {'id': '1', 'image': 'assets/m_photography.jpg'},
    {'id': '2', 'image': 'assets/m_videography.jpg'},
    {'id': '3', 'image': 'assets/m_dronegraphy.jpg'},
    {'id': '4', 'image': 'assets/f_home_made.jpg'},
    {'id': '5', 'image': 'assets/f_cooking_lesson.jpg'},
    {'id': '6', 'image': 'assets/f_cake_baking.jpg'},
    {'id': '7', 'image': 'assets/f_dessert.jpg'},
    {'id': '8', 'image': 'assets/f_street_food.jpg'},
    {'id': '9', 'image': 'assets/t_foreign_language.jpg'},
    {'id': '10', 'image': 'assets/t_deshi_language.jpg'},
    {'id': '11', 'image': 'assets/t_sign_language.jpg'},
    {'id': '12', 'image': 'assets/t_public_speaking.jpg'},
    {'id': '13', 'image': 'assets/fi_yoga.jpg'},
    {'id': '14', 'image': 'assets/fi_meditation.jpg'},
    {'id': '15', 'image': 'assets/fi_fitness_traning.jpg'},
    {'id': '16', 'image': 'assets/fi_mindset_coaching.jpg'},
    {'id': '17', 'image': 'assets/bu_bridal_makeup.jpg'},
    {'id': '18', 'image': 'assets/bu_party_makeup.jpg'},
    {'id': '20', 'image': 'assets/bu_photoshoot_makeup.jpg'},
    {'id': '21', 'image': 'assets/bu_day_makeup.jpg'},
    {'id': '22', 'image': 'assets/bu_grooms_makeup.jpg'},
    {'id': '23', 'image': 'assets/bu_hairstyling.jpg'},
    {'id': '24', 'image': 'assets/bu_saree_draping.jpg'},
    {'id': '25', 'image': 'assets/bu_nail_art_manicure.jpg'},
    {'id': '26', 'image': 'assets/bu_self_makeup_lessons.jpg'},
    {'id': '27', 'image': 'assets/bu_professional_makeup_course.jpg'},
    {'id': '29', 'image': 'assets/to_city_tour.jpg'},
    {'id': '31', 'image': 'assets/to_sightseeing_tour.jpg'},
    {'id': '30', 'image': 'assets/to_nature_tour.jpg'},
    {'id': '32', 'image': 'assets/to_luxury_car_hire.jpg'},
    {'id': '33', 'image': 'assets/mu_singing_class.jpg'},
    {'id': '34', 'image': 'assets/mu_islamic_song_class.jpg'},
    {'id': '35', 'image': 'assets/mu_instrumental_class.jpg'},
    {'id': '36', 'image': 'assets/mu_stage_performance_class.jpg'},
    {'id': '37', 'image': 'assets/sh_art_lessons.jpg'},
    {'id': '38', 'image': 'assets/sh_sewing_lesson.jpg'},
    {'id': '39', 'image': 'assets/sh_alpona_lessons.jpg'},
    {'id': '40', 'image': 'assets/sh_festival_arts.jpg'},
    {'id': '41', 'image': 'assets/sh_interior_design.jpg'},
    {'id': '42', 'image': 'assets/pl_wedding_planner.jpg'},
    {'id': '43', 'image': 'assets/pl_birthday_planner.jpg'},
    {'id': '44', 'image': 'assets/pl_anniversary_planner.jpg'},
    {'id': '45', 'image': 'assets/pl_corporate_events.jpg'},
  ];

  Map<String, String> getIdToImageMap() {
    final map = <String, String>{};
    for (final e in list) {
      final id = e['id'];
      final img = e['image'];
      if (id != null && img != null) map[id] = img;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final idToImage = getIdToImageMap();
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Obx(() {
        final subCategories = controller.selectedCategory.value?.subCategory?.toList() ?? [];
        // 🔹 Step 1: Auto-select first item + image on first load
        if (subCategories.isNotEmpty &&
            (controller.selectedExperiences.value == null ||
                !subCategories.contains(controller.selectedExperiences.value))) {
          final firstItem = subCategories.first;
          controller.selectedExperiences.value = firstItem;
          final firstId = firstItem.id?.toString();
          if (firstId != null && idToImage.containsKey(firstId)) {
            controller.imageUrl.value = idToImage[firstId]!; // ✅ set image url in controller
          }
        }

        // 🔹 Step 2: Determine current selected item & image
        final selectedItem = controller.selectedExperiences.value;
        final selectedId = selectedItem?.id?.toString();
        final selectedImage = selectedId != null && idToImage.containsKey(selectedId)
            ? idToImage[selectedId]!
            : (list.isNotEmpty ? list.first['image']! : '');

        // Always sync controller.imageUrl with selectedImage
        controller.imageUrl.value = selectedImage;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How would you describe your experience?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
            ),
            const Gap(30),

            // 🔹 Image updates automatically via controller.imageUrl
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: buildAssetImage(
                controller.imageUrl.value,
                width: double.infinity,
                height: 300,
                key: ValueKey(controller.imageUrl.value),
              ),
            ),
            const Gap(30),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 5 / 2,
              ),
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final item = subCategories[index];
                final itemId = item.id?.toString();
                final isSelected = itemId == selectedId;

                return InkWell(
                  onTap: () {
                    controller.selectedExperiences.value = item;
                    if (itemId != null && idToImage.containsKey(itemId)) {
                      controller.imageUrl.value = idToImage[itemId]!; // ✅ update on tap
                    }
                  },
                  child: Container(
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: isSelected ? 1.5 : 1,
                          color: isSelected
                              ? AppColors.primaryColor
                              : AppColors.primaryColor.withAlpha(44),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    alignment: Alignment.center,
                    child: Text(
                      item.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? AppColors.primaryColor : Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
            const Gap(24),
            Center(
              child: SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: controller.goNextAfterSelectingSubcategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                ),
              ),
            ),
            const Gap(46)
          ],
        );
      }),
    );
  }

  Widget buildAssetImage(String? url, {double? width, double? height, Key? key}) {
    final imagePath = url ?? '';
    return ClipRRect(
      key: key,
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        imagePath,
        width: width ?? 100,
        height: height ?? 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width ?? 100,
          height: height ?? 100,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      ),
    );
  }
}






// Hello I am Tamim