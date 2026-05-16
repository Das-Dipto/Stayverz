import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/widgets/own_clone_title_app_bar.dart';
import '../../../../../controllers/profile_controller.dart';
import '../../../../../features/profile/models/cohost_own_data.dart';

class SelectCoHost extends StatefulWidget {
  final String id;
  const SelectCoHost({super.key, required this.id});

  @override
  State<SelectCoHost> createState() => _SelectCoHostState();
}

class _SelectCoHostState extends State<SelectCoHost> {
  final ProfileController controller = Get.find<ProfileController>();
  final RxList<NotGrantedListing> selectedListings = <NotGrantedListing>[].obs;
  final TextEditingController commissionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCoHostAssignment(int.parse(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        backgroundColor: Colors.white,

        title: "Add Permission",
        titleFontSize: 16,
        titleFontWeight: FontWeight.w600,
        titleColor: Colors.black,
      ),
      body: Obx(() {
        final data = controller.coHostOwnData.value;

        if (controller.isLoadinge.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text(controller.errorMessage.value),
            ),
          );
        }

        if (data == null || data.notGrantedListings.isEmpty) {
          return const Center(child: Text('No data found.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 10),
          itemCount: data.notGrantedListings.length,
          separatorBuilder: (context, index) => const Gap(10),
          itemBuilder: (context, index) {
            final listing = data.notGrantedListings[index];

            return Obx(() {
              final isSelected = selectedListings.any((item) => item.id == listing.id);

              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    selectedListings.removeWhere((item) => item.id == listing.id);
                  } else {
                    selectedListings.add(listing);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green.shade50 : null,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    children: [
                      listing.coverPhoto.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          listing.coverPhoto,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                      const Gap(20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    listing.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Icon(
                                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: isSelected ? Colors.green : Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Price: ${listing.price}",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
          },
        );
      }),
      floatingActionButton: Obx(() {
        if (selectedListings.isEmpty) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (dialogContext) {  // ← dialogContext
                return AlertDialog(
                  title: const Text('Set Commission Percentage'),
                  content: Form(
                    key: formKey,
                    child: TextFormField(
                      controller: commissionController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Commission Percentage (0-100)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Commission is required';
                        }
                        final numValue = num.tryParse(value);
                        if (numValue == null) return 'Please enter a valid number';
                        if (numValue < 0 || numValue > 100) return 'Must be between 0 and 100';
                        return null;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(), // ← dialogContext
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          Navigator.of(dialogContext).pop(); // ← pop dialog FIRST
                          await Future.delayed(Duration.zero); // ← let it close

                          final commission = commissionController.text.trim();
                          final listingIds = selectedListings.map((e) => e.id).toList();
                          final coHostUserId = int.parse(widget.id);

                          await controller.assignCoHost(
                            coHostUserId: coHostUserId,
                            accessLevel: "semi",
                            listingIds: listingIds,
                            commissionPercentage: commission,
                          );

                          selectedListings.clear();
                          commissionController.clear();
                          controller.fetchCoHostAssignment(int.parse(widget.id));
                        }
                      },
                      child: const Text('Assign'),
                    ),
                  ],
                );
              },
            );
          },
          label: const Text("Give Access"),
          icon: const Icon(Icons.check),
          backgroundColor: Colors.redAccent,
        );
      }),
    );
  }
}

// Hello I am Tamim