import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../controllers/listing_controller.dart';

class StepTenthCreateListingBody extends GetView<ListingController> {
  StepTenthCreateListingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Now, set your price',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const Gap(6),
        Text(
        'You can change it anytime',
          style: TextStyle(
            color: const Color(0xFF33496C) /* Text */,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        const Gap(30),
        Align(
          alignment: Alignment.center,
          child: IntrinsicWidth(
            child: TextFormField(
              controller: controller.priceController,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "৳ ",
                prefixStyle: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800
                ),
                hintStyle: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.black
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                alignLabelWithHint: true,
                isDense: true,
                isCollapsed: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                hintText: "00.0",
              ),
            ),
          ),
        ),
        const Gap(20),

        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Guest price before taxes ৳${controller.totalGuestPriceValue.value.toStringAsFixed(2)}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF282C35) /* Black-80 */,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
                const Gap(16),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 2)
                  ),
                  child: Column(
                    children: [
                      Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Base Price',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF282C35) /* Black-80 */,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                              Text(
                                '৳ ${controller.basePriceValue.value.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: const Color(0xFF282C35) /* Black-80 */,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              )
                            ],
                          );
                        }
                      ),
                      const Gap(10),
                      Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            spacing: 10,
                            children: [
                              Text(
                                'Guest Gateway fee',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF282C35) /* Black-80 */,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              ),
                              Text(
                                '৳ ${controller.guestGatewayFeeValue.value.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: const Color(0xFF282C35) /* Black-80 */,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 1.50,
                                ),
                              )
                            ],
                          );
                        }
                      ),
                      const Divider( height: 30),
                      Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Guest price',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF282C35) /* Black-80 */,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.50,
                                ),
                              ),
                              Text(
                                '৳ ${controller.totalGuestPriceValue.value.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: const Color(0xFF282C35) /* Black-80 */,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  height: 1.50,
                                ),
                              )
                            ],
                          );
                        }),
                    ],
                  ),
                ),
                const Gap(26),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFDCDEE3) /* Grey-30 */,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                  child: Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'You earn',
                            style: TextStyle(
                              color: const Color(0xFF282C35) /* Black-80 */,
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(
                            '৳ ${controller.youEarnPriceValue.value}',
                            style: TextStyle(
                              color: const Color(0xFF282C35) /* Black-80 */,
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      );
                    }
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