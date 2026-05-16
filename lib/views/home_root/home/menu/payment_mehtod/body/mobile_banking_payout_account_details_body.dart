import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../../widgets/custom_input_text.dart';
import 'package:stayverz_flutter_app/controllers/payment_mothod_controller.dart';

class MobileBankingPayoutAccountDetailsBody extends StatelessWidget {
  const MobileBankingPayoutAccountDetailsBody({super.key});


  @override
  Widget build(BuildContext context) {
    final PaymentMethodController ctrl = Get.find();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            'Enter Your Account Details',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.33,
            ),
          ),
        ),
        const Gap(48),
        Text(
          'Phone Number',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.46,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.50,
          ),
        ),
        const Gap(8),
        CustomInputText(
          controller: ctrl.mobilePhoneNumberController,
          keyboardType: TextInputType.number,
          helperText: '01xxxxxxxxx',
          maxLength: 11,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // allow digits only
          ],
          // optionally you can add validator logic in your controller or form
        ),
        const Gap(16),
        Text(
          'Merchant Name',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.46,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.50,
          ),
        ),
        const Gap(8),
        CustomInputText(
          controller: ctrl.mobileMerchantNameController,
          helperText: 'Merchant Name',
        ),
        const Gap(16),
        Row(
          children: [
            Obx(() {
                return Checkbox(
                  value: ctrl.isSetAsDefaultPaymentMethod.value,
                  onChanged: (value) {
                    ctrl.isSetAsDefaultPaymentMethod.value = value ?? false;
                  }, // disabled if canSetDefault is false
                  visualDensity: VisualDensity.compact,
                  checkColor: Colors.white,
                  fillColor: WidgetStateProperty.all(Colors.green),
                );
              }
            ),
            const SizedBox(width: 10),
            Text(
              'Set as default',
              style: TextStyle(
                color: const Color(0xFF67666B),
                fontSize: 16.46,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ],
        )
      ],
    );
  }
}

// Hello I am Tamim