import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/payment_mothod_controller.dart';
import 'package:stayverz_flutter_app/controllers/profile_controller.dart';
import 'package:stayverz_flutter_app/views/home_root/home/menu/payment_mehtod/body/bank_payout_account_details_body.dart';
import 'package:stayverz_flutter_app/views/home_root/home/menu/payment_mehtod/body/mobile_banking_payout_account_details_body.dart';
import '../../../../../core/utils/enums/product_listing_enums.dart';
import '../../../../../widgets/own_title_app_bar.dart';

class EditPaymentMethodScreen extends StatefulWidget {
  const EditPaymentMethodScreen({super.key});

  @override
  State<EditPaymentMethodScreen> createState() => _EditPaymentMethodScreenState();
}

class _EditPaymentMethodScreenState extends State<EditPaymentMethodScreen> {
  final PaymentMethodController ctrl = Get.put(PaymentMethodController());
  final ProfileController profile = Get.find<ProfileController>();

  @override
  void dispose() {
    ctrl.currentState(CurrentState.FIRST);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Edit Payment Method',
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {

              if(ctrl.isBankEditMode.value) {
                return BankPayoutAccountDetailsBody();
              }

              return MobileBankingPayoutAccountDetailsBody();
            }),
            const Gap(32),
            SizedBox(
              width: 180,
              child: OutlinedButton(
                onPressed: ctrl.handleContinue,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  side: const BorderSide(width: 0.8, color: Colors.black38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showBankDetailsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Entered Bank Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Bank Name", ctrl.bankNameController.text),
              _buildDetailRow("Branch Name", ctrl.branchNameController.text),
              _buildDetailRow("Routing Number", ctrl.routingNumberController.text),
              _buildDetailRow("Account Name", ctrl.accountNameController.text),
              _buildDetailRow("Account Number", ctrl.accountNumberController.text),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ctrl.goNext();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _showMobileBankingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Entered Mobile Banking Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Phone Number", ctrl.mobilePhoneNumberController.text),
              _buildDetailRow("Merchant Name", ctrl.mobileMerchantNameController.text),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ctrl.goNext();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}


class PaymentMethodItem extends StatelessWidget {

  final String asset, title;
  final List<String> features;
  final bool isSelected;
  final Function()? onPress;
  PaymentMethodItem({super.key, required this.asset, required this.title, this.features = const [], this.onPress, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Image.asset(
              asset,
              width: 60,
            ),
            VerticalDivider(thickness: 0.4, width: 28,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.50,
                    ),
                  ),
                  ...(features.map((element) => Row(
                    children: [
                      Icon(Icons.circle, size: 6, color: const Color(0xFF67666B)),
                      const Gap(4),
                      Text(
                        element,
                        style: TextStyle(
                          color: const Color(0xFF67666B) /* Grey-70 */,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ],
                  )).toList())
                ],
              ),
            ),
            Column(
              children: [
                Icon(isSelected ? Icons.circle : Icons.circle_outlined, color: isSelected ? Colors.green : Colors.black26, size: 18,),
              ],
            )
          ],
        ),
      ),
    );
  }
}


// Hello I am Tamim