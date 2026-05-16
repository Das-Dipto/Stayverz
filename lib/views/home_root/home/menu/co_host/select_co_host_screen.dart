import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/views/home_root/home/menu/co_host/select_co_host.dart';
import '../../../../../controllers/profile_controller.dart';
import '../../../../../widgets/listing_card_widget.dart';
import '../../../../../widgets/own_title_app_bar.dart';

class SelectCoHostScreen extends StatefulWidget {
  final String id;
  final String iamge;
  const SelectCoHostScreen({super.key, required this.id, required this.iamge});

  @override
  State<SelectCoHostScreen> createState() => _SelectCoHostScreenState();
}

class _SelectCoHostScreenState extends State<SelectCoHostScreen> {
  final ProfileController controller = Get.find<ProfileController>();

  List inboxMessagesList = [
    ListingCard(
      name: 'Couple Room',
      message: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since',
    ),
    ListingCard(
      name: 'Single Room',
      message: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
    ),
  ];
  @override
  void initState() {
    // TODO: implement initState
    controller.fetchCoHostAssignment(int.parse(widget.id));
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: "Share Your Recommendation",
        backgroundColor: Colors.white,
        fontColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Obx(() {
          if (controller.isLoadinge.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Text(controller.errorMessage.value),
            ));
          }

          final data = controller.coHostOwnData.value;

          if (data == null) {
            return const Center(child: Text('No data found.'));
          }

          return Column(
            children: [
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: NavigationChoiceChips(
              //     onSelected: (index) {
              //       // Handle selection here
              //
              //     },
              //   ),
              // ),
              // const Gap(8),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text.rich(
              //     TextSpan(
              //       children: [
              //         TextSpan(
              //           text: 'See access',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontFamily: 'Inter',
              //             fontWeight: FontWeight.w300,
              //             height: 1.50,
              //           ),
              //         ),
              //         TextSpan(
              //           text: ' ',
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontFamily: 'Inter',
              //             fontWeight: FontWeight.w500,
              //             height: 1.50,
              //           ),
              //         ),
              //         TextSpan(
              //           text: 'conditions',
              //           recognizer: TapGestureRecognizer()..onTap = _showConditions,
              //           style: TextStyle(
              //             color: const Color(0xFF004E70) /* Info */,
              //             fontSize: 16,
              //             fontFamily: 'Inter',
              //             fontWeight: FontWeight.w500,
              //             decoration: TextDecoration.underline,
              //             height: 1.50,
              //           ),
              //         ),
              //       ],
              //     ),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              Gap(10),
              Container(
                margin: EdgeInsets.only(bottom: 16),
                width: 114.17,
                height: 107.26,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image:widget.iamge==""?AssetImage('assets/default_image.jpg'):NetworkImage("${widget.iamge}"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Text(
                      data.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(child: Text(data.bio.isNotEmpty ? data.bio : "No bio available",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF67666B) /* Grey-70 */,
                      fontSize: 12.63,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  )),
                  const SizedBox(height: 16),


                  Row(
                    children: [
                      _buildStatCard(
                        label: 'Listings',
                        value: '${data.totalActiveListings}',
                        icon: Icons.home_outlined,
                      ),
                      _buildStatCard(
                        label: 'Rating',
                        value: data.avgRating.toStringAsFixed(1),
                        icon: Icons.star_border,
                      ),
                      _buildStatCard(
                        label: 'Hosting',
                        value: '${data.yearsHosting}',
                        icon: Icons.history_edu,
                      ),

                    ],
                  ),

                  const SizedBox(height: 24),
                  Text("Granted Listings", style: const TextStyle(fontWeight: FontWeight.bold)),
                 Gap(10),
                  if (data.grantedListings.isEmpty)
                    const Text("No granted listings")
                  else
                    Column(
                      children: data.grantedListings.map((listing) {
                        return InkWell(
                          onLongPress: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Obx(() {
                                  return AlertDialog(
                                    title: const Text(
                                      "Do you want to delete this from granted my listing?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: controller.isDeletingGrantedListing.value
                                            ? null
                                            : () async {
                                          await controller.onClickDeleteGrantedListing(
                                            id: "${listing.id}",
                                            userId: widget.id,
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: controller.isDeletingGrantedListing.value
                                            ? const SizedBox(
                                          width: 10,
                                          height: 10,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                          ),
                                        )
                                            : const Text('Delete'),
                                      ),
                                    ],
                                  );
                                });
                              },
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                           //   crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Image or Placeholder
                                listing.listingDetails.coverPhoto != null && listing.listingDetails.coverPhoto!.isNotEmpty
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    listing.listingDetails.coverPhoto,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                const SizedBox(width: 12),
                                // Text Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listing.listingDetails.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Commission: ${listing.commissionPercentage}%",
                                        style: TextStyle(color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                ),
                                // Price
                                Text(
                                  "${listing.listingDetails.price}৳",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, size: 20),
                                      onPressed: () => showCommissionEditPopup(
                                          context,
                                          listing.id
                                      ),
                                      tooltip: 'Edit',
                                    ),

                                    InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return Obx(() {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Do you want to delete this from granted my_listing?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: controller.isDeletingGrantedListing.value
                                                          ? null
                                                          : () async {
                                                        await controller.onClickDeleteGrantedListing(
                                                          id: "${listing.id}",
                                                          userId: widget.id,
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                      child: controller.isDeletingGrantedListing.value
                                                          ? const SizedBox(
                                                        width: 10,
                                                        height: 10,
                                                        child: CircularProgressIndicator(
                                                          strokeWidth: 1,
                                                        ),
                                                      )
                                                          : const Text('Delete'),
                                                    ),
                                                  ],
                                                );
                                              });
                                            },
                                          );
                                        },
                                        child: Icon(Icons.delete,color: Colors.red,)),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 24),
                  // Text("Not Granted Listings", style: const TextStyle(fontWeight: FontWeight.bold)),
                  // Gap(10),
                  // if (data.notGrantedListings.isEmpty)
                  //   const Text("No ungranted listings")
                  // else
                  //   Column(
                  //     children: data.notGrantedListings.map((listing) {
                  //       return ListTile(
                  //         leading: listing.coverPhoto != null && listing.coverPhoto!.isNotEmpty
                  //             ? Image.network(listing.coverPhoto!, width: 50, height: 50, fit: BoxFit.cover)
                  //             : const Icon(Icons.image_not_supported),
                  //         title: Text(listing.title),
                  //         trailing: Text("${listing.price}৳"),
                  //       );
                  //     }).toList(),
                  //   ),
                ],
              ),
              Gap(25),



            ],
          );
        },),
      ),
      // bottomSheet: Padding(
      //   padding: const EdgeInsets.all(0),
      //   child: OutlinedButton(
      //       onPressed: () {
      //         Get.back();
      //       },
      //       style: ElevatedButton.styleFrom(
      //           backgroundColor: Colors.white,
      //           elevation: 0,
      //           side: BorderSide(width: 1, color: Colors.black54),
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(6),
      //           )
      //       ),
      //       child: Text(
      //         'Give access',
      //         textAlign: TextAlign.center,
      //         style: TextStyle(
      //             color: Colors.black /* white */,
      //             fontSize: 16,
      //             fontFamily: 'Inter',
      //             fontWeight: FontWeight.w500
      //         ),
      //       )),
      // ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // “Give access” button
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                 // controller.dispose();
                  Get.to(SelectCoHost(id: widget.id,));
                  // Fluttertoast.showToast(
                  //   msg: 'Co-host selected',
                  //   toastLength: Toast.LENGTH_SHORT,
                  //   gravity: ToastGravity.BOTTOM,
                  // );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  side: const BorderSide(width: 1, color: Colors.black54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Select Co‑host',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),


            Gap(18),
            // Expanded(
            //   child: OutlinedButton(
            //     onPressed: null, // ← null makes the button disabled
            //     style: OutlinedButton.styleFrom(
            //       backgroundColor: Colors.white,
            //       elevation: 0,
            //       side: const BorderSide(width: 1, color: Colors.black54),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(6),
            //       ),
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //     ),
            //     child: const Text(
            //       'Give access',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //         color: Colors.black54,   // use a lighter color to indicate disabled
            //         fontSize: 16,
            //         fontFamily: 'Inter',
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),
            // ),

            // “Select Co‑host” button

          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }

  void showCommissionEditPopup(BuildContext context, int coHostId) {
    final TextEditingController commissionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Commission'),
          content: TextField(
            controller: commissionController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Commission (%)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // close popup
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newCommission = commissionController.text.trim();
                if (newCommission.isNotEmpty) {
                  try {
                    await controller.patchCoHostCommission(
                      coHostId: coHostId,
                      commissionPercentage: newCommission,
                    );
                  } catch (e) {
                    // error already handled in controller (snackbar shown)
                  } finally {
                    Navigator.pop(context); // ✅ always closes dialog
                    controller.fetchCoHostAssignment(int.parse(widget.id));
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6.0),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.black38,
            width: 1
          )
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 6,
          //     offset: Offset(0, 3),
          //   ),
          // ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showConditions() {
    Get.bottomSheet(
        EditBottomSheet(),
        backgroundColor: Colors.white,

    );
  }
}


class EditBottomSheet extends StatelessWidget {
  const EditBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, right: 18, left: 18),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Cancellation rate',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),
              const Gap(12),
              SizedBox(
                height: 25,
                width: 25,
                child: IconButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center
                    ),
                    icon: Icon(Icons.close),
                    ),
              )
            ],
          ),
        ),
        Divider(height: 30,),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16,
              children: [
                Text(
                  'Stayverz is a smart, all-in-one platform built to simplify property management for short-term rentals and hospitality providers. It offers tools to manage bookings, guest communication, housekeeping, and more—everything you need to run day-to-day operations efficiently.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                Text(
                  'Full access conditions',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
                Text(
                  'You will get full access to the platform, but without the financial part. This ensures operational control while keeping sensitive financial data securely managed by the designated parties.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                Text(
                  'Semi access conditions',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
                Text(
                  'Under the semi access arrangement, users are granted permission to access and manage most operational aspects of the Stayverz platform, with certain limitations.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),

                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: OutlinedButton(
                      onPressed: () {

                      },
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          side: BorderSide(width: 0.8, color: Colors.black38),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )
                      ),
                      child: Text(
                        'Close',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black /* Black */,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

      ],
    );
  }
}

// Hello I am Tamim