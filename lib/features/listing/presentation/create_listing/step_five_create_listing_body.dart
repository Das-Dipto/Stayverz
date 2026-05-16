import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';

class StepFiveCreateListingBody extends GetView<ListingController> {
  StepFiveCreateListingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Share some basics about your place',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const Gap(12),
        Text(
        'You\'ll add more details later, like bed types',
          style: TextStyle(
            color: const Color(0xFF33496C) /* Text */,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        const Gap(30),
        Obx(() {
            return IncrementCard(
              icon: OwnIcons.guests_icon,
              title: 'Persons',
              value: controller.personsCount.value.toString(),
              onDecrement: () {
                if(controller.personsCount.value <= 0) return;
                controller.personsCount.value = controller.personsCount.value - 1;
              },
              onIncrement: () => controller.personsCount.value = controller.personsCount.value + 1,
            );
          }
        ),
        const Gap(10),
        Obx(() {
            return IncrementCard(
              icon: OwnIcons.bedrooms_icon,
              title: 'Bedrooms',
              value: controller.bedroomsCount.value.toString(),
              onDecrement: () {
                if(controller.bedroomsCount.value <= 0) return;
                controller.bedroomsCount.value = controller.bedroomsCount.value - 1;
              },
              onIncrement: () => controller.bedroomsCount.value = controller.bedroomsCount.value + 1,
            );
          }
        ),
        const Gap(10),
        Obx(() {
            return IncrementCard(
              icon: OwnIcons.beds_icon,
              title: 'Beds',
              value: controller.bedsCount.value.toString(),
              onDecrement: () {
                if(controller.bedsCount.value <= 0) return;
                controller.bedsCount.value = controller.bedsCount.value - 1;
              },
              onIncrement: () => controller.bedsCount.value = controller.bedsCount.value + 1,
            );
          }
        ),
        const Gap(10),
        Obx(() {
            return IncrementCard(
              icon: OwnIcons.bathrooms_icon,
              title: 'Bathrooms',
              value: controller.bathroomsCount.value.toString(),
              onDecrement: () {
                if(controller.bathroomsCount.value <= 0) return;
                controller.bathroomsCount.value = controller.bathroomsCount.value - 1;
              },
              onIncrement: () => controller.bathroomsCount.value = controller.bathroomsCount.value + 1,
            );
          }
        ),
        const Gap(20)
      ],
    );
  }
}

class IncrementCard extends StatelessWidget {

  final String title, value;
  final IconData? icon;
  final void Function()? onIncrement, onDecrement;

  const IncrementCard({super.key, required this.value, required this.title, this.icon, this.onIncrement, this.onDecrement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: Colors.white /* white */,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFFF0F1F5) /* Grey-10 */,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Icon(icon),
            VerticalDivider(width: 40,),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ),
            ),
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton.outlined(
                onPressed: onDecrement,
                padding: EdgeInsets.zero,
                icon: Icon(Icons.remove),
              ),
            ),
            SizedBox(
              width: 40,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.20,
                ),
              ),
            ),
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton.outlined(
                onPressed: onIncrement,
                padding: EdgeInsets.zero,
                icon: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ThirdStepContent {
  String? asset, title, subtitle;
  ThirdStepContent({this.asset, this.title, this.subtitle});
}

// Hello I am Tamim