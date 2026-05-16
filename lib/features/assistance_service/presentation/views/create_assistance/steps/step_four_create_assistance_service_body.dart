import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/utils/main_utils.dart';
import '../../../../controllers/assistance_service_controller.dart';
import '../../../widgets/location_suggestor_text_field_widget.dart';

class StepFourCreateAssistanceServiceBody extends GetView<AssistanceServiceController> {
  StepFourCreateAssistanceServiceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Share your qualifications',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
        ),
        const Gap(28),
        Text(
        'About you',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600
          ),
        ),
        const Gap(8),
        CustomInputText(
          controller: controller.aboutYouController,
          helperText: "Enter about you..",
          maxLines: 4,
          keyboardType: TextInputType.text
        ),
        const Gap(18),
        Text(
          'Current Location',
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600
          ),
        ),
        const Gap(8),
        LocationSuggesterTextFieldWidget(
          controller: controller.currentLocationSuggesterController,
          hintText: 'Enter area',
          onSuggestionSelected: (suggestion) async {
            controller.selectedAssistanceCurrentLocation = suggestion;
            controller.currentLocationSuggesterController.text = suggestion.address ?? '';
          },
        ),
        const Gap(18),
        Text(
          'Covering Area',
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600
          ),
        ),
        const Gap(8),
        LocationSuggesterTextFieldWidget(
          controller: controller.coveringAreaSuggesterController,
          hintText: 'Enter area',
          onSuggestionSelected: (suggestion) async {
            controller.selectedAssistanceCoveringArea = suggestion;
            controller.coveringAreaSuggesterController.text = suggestion.address ?? '';
          },
        ),
        const Gap(18),
        Text(
          'Title of Assistance',
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600
          ),
        ),
        const Gap(8),
        CustomInputText(
          controller: controller.titleController,
          helperText: "Enter title",
          keyboardType: TextInputType.name
        ),
        const Gap(18),
        Text(
          'Describe your Assistance',
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600
          ),
        ),
        const Gap(8),
        CustomInputText(
          controller: controller.describeYourAssistanceController,
          helperText: "Enter what guest will experience",
          keyboardType: TextInputType.text,
        ),
        const Gap(18),
        Text(
          'Details',
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600
          ),
        ),
        const Gap(8),
        CustomInputText(
          controller: controller.descriptionController,
          helperText: "Enter what you’ll provide your guest through this Assistance",
          maxLines: 4,
          keyboardType: TextInputType.text,
        ),
        const Gap(18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Enable Multiple date selection',
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
                value: controller.enableMultipleDateSelection.value,
                onChanged: (value) async {
                  controller.enableMultipleDateSelection.value = value;
                },
                materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
              );
            }),
          ],
        ),
        const Gap(18),
        Text(
          'Meetup point',
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600
          ),
        ),
        const Gap(8),
        WhereILiveBottomSheet(),
        const Gap(18),
        Text(
          'Max Participation',
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600
          ),
        ),
        /*const Gap(8),
        Text(
          'The booking allows a maximum of 4 guests. An additional charge of BDT 500 Price will apply for each extra guest.',
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: Colors.black38
          ),
        ),*/
        const Gap(8),
        CustomInputText(
          controller: controller.maxParticipationController,
          helperText: "Enter number of maximum guest",
          keyboardType: TextInputType.number,
        ),
        const Gap(18),
        Text(
          'Price',
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600
          ),
        ),
        const Gap(8),
        CustomInputText(
          controller: controller.priceController,
          helperText: "Enter price",
          keyboardType: TextInputType.number,
        ),
        const Gap(18),
        Text(
          'Extra services',
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600
          ),
        ),
        const Gap(8),
        Text(
          'Per Person',
          style: TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              color: Colors.black38
          ),
        ),
        const Gap(8),
        CustomInputText(
          controller: controller.extraServicesController,
          helperText: "Enter amount",
          keyboardType: TextInputType.number,
        ),
        const Gap(18),
        Text(
          'Photos',
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600
          ),
        ),
        const Gap(8),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
              onPressed: () async {
                final images = await MainUtils.pickImagesFromGallery();
                if (images.isNotEmpty) {
                  // Convert XFile to file paths
                  final List<String> paths = images.map((image) => image.path).toList();

                  // Check total file size
                  int totalBytes = 0;
                  for (final path in paths) {
                    final file = File(path);
                    if (await file.exists()) {
                      totalBytes += await file.length();
                    }
                  }

                  const maxSizeInBytes = 20 * 1024 * 1024; // 20 MB

                  if (totalBytes > maxSizeInBytes) {
                    Fluttertoast.showToast(
                      msg: "Total file size exceeds 20 MB. Please select smaller images.",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.TOP,
                    );
                    return;
                  }

                  controller.selectedAssistanceFiles.addAll(images.map((e) => File(e.path)).toList());
                }
              },
              icon: Icon(OwnIcons.upload_photo_icon),
            label: Text('Upload Images'),
            iconAlignment: IconAlignment.end,
            style: OutlinedButton.styleFrom(
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              foregroundColor: Colors.black54,
              iconColor: Colors.black87,
              side: BorderSide(width: 1.5, color: Colors.black12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
          ),
        ),
        const Gap(24),
        Obx(() {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of items in the cross axis
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.selectedAssistanceFiles.length, // Total number of items in the grid
              itemBuilder: (BuildContext context, int index) {
                return Obx(() {
                    return Container(
                      decoration:BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(controller.selectedAssistanceFiles[index]),
                          fit: BoxFit.cover
                        ),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.topRight,
                      child: InkWell(
                          onTap: () => controller.selectedAssistanceFiles.removeAt(index),
                          child: Container(
                            decoration: ShapeDecoration(
                              color: Colors.white54,
                              shape: CircleBorder()
                            ),
                              child: Icon(Icons.close),
                          )
                      ),
                    );
                  }
                );
              },
            );
          }
        ),
        const Gap(24),
        Center(
          child: SizedBox(
            width: 120,
            child: Obx(() {
                return ElevatedButton(
                  onPressed: controller.isPublishing.value ? null : controller.goNextAfterSharingQualifications,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isPublishing.value ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.black87,
                    ),
                  ) : const Text(
                    'Publish',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  ),
                );
              }
            ),
          ),
        ),
        const Gap(64)
      ],
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

  final AssistanceServiceController controller = Get.find<AssistanceServiceController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        LocationSuggesterTextFieldWidget(
          controller: controller.meetupPointSuggestionController,
          hintText: 'Enter meetup area',
          onSuggestionSelected: (suggestion) async {
            controller.selectedAssistanceMeetupPoint = suggestion;
            controller.meetupPointSuggestionController.text = suggestion.address ?? '';

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
          },
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
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
      ],
    );
  }
}

// Hello I am Tamim