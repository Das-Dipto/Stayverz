import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/payment_mothod_controller.dart';
import '../add_payment_method_screen.dart';

class PayoutsMethodsBody extends StatelessWidget {
  PayoutsMethodsBody({super.key});

  PaymentMethodController ctrl = Get.put(PaymentMethodController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'How would you like to pay?',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600
          ),
        ),
        Text(
          'Payouts will be sent in BDT.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),

        const Gap(24),
        Obx(() {
            return PaymentMethodItem(
              title: 'Bank',
              asset: './assets/bank.png',
              features: [
                '3-5 working days',
                'No Fees'
              ],
              isSelected: ctrl.selectedPayoutMethod.value == 'bank',
              onPress: () {
                ctrl.selectedPayoutMethod('bank');
              },
            );
          }
        ),
        const Gap(24),
        Obx(() {
            return PaymentMethodItem(
              title: 'Bkash',
              asset: './assets/bkash.png',
              features: [
                'Instant Transfer',
                'No Fees'
              ],
              isSelected: ctrl.selectedPayoutMethod.value == 'bkash',
              onPress: () {
                ctrl.selectedPayoutMethod('bkash');
              },
            );
          }
        ),
        const Gap(24),
        Obx(() {
            return PaymentMethodItem(
              title: 'Nagad',
              asset: './assets/nagad.png',
              features: [
                'Instant Transfer',
                'No Fees'
              ],
              isSelected: ctrl.selectedPayoutMethod.value == 'nagad',
              onPress: () {
                ctrl.selectedPayoutMethod('nagad');
              },
            );
          }
        ),
        const Gap(24),
        Obx(() {
            return PaymentMethodItem(
              title: 'Rocket',
              asset: './assets/rocket.png',
              features: [
                'Instant Transfer',
                'No Fees'
              ],
              isSelected: ctrl.selectedPayoutMethod.value == 'rocket',
              onPress: () {
                ctrl.selectedPayoutMethod('rocket');
              },
            );
          }
        ),
      ],
    );
  }
}

// Hello I am Tamim