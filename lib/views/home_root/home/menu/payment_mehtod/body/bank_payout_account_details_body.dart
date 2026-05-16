import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/payment_mothod_controller.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';

class BankPayoutAccountDetailsBody extends StatefulWidget {
  const BankPayoutAccountDetailsBody({super.key});

  @override
  State<BankPayoutAccountDetailsBody> createState() => _BankPayoutAccountDetailsBodyState();
}

class _BankPayoutAccountDetailsBodyState extends State<BankPayoutAccountDetailsBody> {
  final PaymentMethodController ctrl = Get.put(PaymentMethodController());

  @override
  Widget build(BuildContext context) {
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
        _buildLabel('Bank Name'),
        CustomInputText(
          controller: ctrl.bankNameController,
          helperText: 'Sample Bank Name',
        ),
        const Gap(16),
        _buildLabel('Branch Name'),
        CustomInputText(
          controller: ctrl.branchNameController,
          helperText: 'Sample Branch Name',
        ),
        const Gap(16),
        _buildLabel('Routing Number'),
        CustomInputText(
          controller: ctrl.routingNumberController,
          keyboardType: TextInputType.number,
          helperText: 'Sample Routing Number',
        ),
        const Gap(16),
        _buildLabel('Account Name'),
        CustomInputText(
          controller: ctrl.accountNameController,
          helperText: 'Sample Account Name',
        ),
        const Gap(16),
        _buildLabel('Account Number'),
        CustomInputText(
          controller: ctrl.accountNumberController,
          keyboardType: TextInputType.number,
          helperText: 'Sample Account Number',
        ),
        const Gap(16),
        Row(
          children: [
            Obx(() {
                return Checkbox(
                  value: ctrl.isSetAsDefaultPaymentMethod.value,
                  onChanged: (value) {
                    setState(() {
                      ctrl.isSetAsDefaultPaymentMethod.value = value ?? false;
                    });
                  },
                  visualDensity: VisualDensity.compact,
                  checkColor: Colors.white,
                  fillColor: WidgetStateProperty.all(Colors.green),
                );
              }
            ),
            const Gap(10),
            Text(
              'Set as default',
              style: TextStyle(
                color: const Color(0xFF67666B),
                fontSize: 16.46,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.46,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.50,
          ),
        ),
        const Gap(8),
      ],
    );
  }
}

// Hello I am Tamim