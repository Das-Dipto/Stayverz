import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/payment_mothod_controller.dart';
import 'package:stayverz_flutter_app/controllers/profile_controller.dart';
import 'package:stayverz_flutter_app/views/home_root/home/menu/payment_mehtod/add_payment_method_screen.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';
import '../../../../../widgets/own_title_app_bar.dart';
import 'edit_payment_method_screen.dart';
import 'about_payout_work_screen.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {

  PaymentMethodController ctrl = Get.put(PaymentMethodController());
  final ProfileController controller = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    // Schedule the API calls after the current build frame is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchHostPaymentMethods();
      controller.fetchProfile();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Payment Method',
        fontColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Disbursement',
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
            const Gap(28),
            Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,8,8,0),
                    child: Text(
                      'How you will get paid',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                  ),
                  const Divider(thickness: 0.4,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,8,8),
                    child: Text(
                      'You can send your money to one or more payout methods. To manage your payout method(s) or assign a taxpayer, use the edit menu next to each payout method.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(32),
            Obx(() {
              final methods = controller.hostPaymentMethods;

              if (methods.isEmpty) {
                return const Center(child: Text('No payment methods found.'));
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: methods.length,
                separatorBuilder: (context, index) => const Gap(16),
                itemBuilder: (context, index) {
                  final method = methods[index];

                  // Compose the details list dynamically
                  final details = <String>[
                    'Name: ${method.accountName}',
                    if (method.mType == 'bank') ...[
                      'Bank Name: ${method.bankName}',
                      'Branch: ${method.branchName}',
                      'A/C No.: ${method.accountNo}',
                      'Routing Number: ${method.routingNumber}',
                    ] else if (method.mType == 'nagad') ...[
                      'Mobile No.: ${method.accountNo}'
                    ] else if (method.mType == 'bkash') ...[
                      'Mobile No.: ${method.accountNo}'
                    ] else if (method.mType == 'rocket') ...[
                      'Mobile No.: ${method.accountNo}'
                    ]
                  ];

                  String methodAssets = './assets/bank.png';

                  if(method.mType == 'bkash') {
                    methodAssets = './assets/bkash.png';
                  } else if(method.mType == 'nagad') {
                    methodAssets = './assets/nagad.png';
                  } else if(method.mType == 'rocket') {
                    methodAssets = './assets/roket.png';
                  }

                  return UserPayoutMethodCard(
                    asset: methodAssets, // choose correct asset
                    method: method.mType.capitalizeFirst ?? '',
                    details: details,
                    isDefault: method.isDefault,
                    onEdit: () {
                      ctrl.resetAllData();
                      ctrl.isBankEditMode.value = method.mType == 'bank';
                      ctrl.selectedEditId.value = "${method.id}";
                      if(ctrl.isBankEditMode.value) {
                        ctrl.selectedPayoutMethod.value = method.mType;
                        ctrl.bankNameController.text = method.bankName;
                        ctrl.branchNameController.text = method.branchName;
                        ctrl.routingNumberController.text = method.routingNumber;
                        ctrl.accountNumberController.text = method.accountNo;
                        ctrl.accountNameController.text = method.accountName;
                        ctrl.isSetAsDefaultPaymentMethod.value = method.isDefault;
                      } else {
                        ctrl.isSetAsDefaultPaymentMethod.value = method.isDefault;
                        ctrl.mobilePhoneNumberController.text = method.accountNo;
                        ctrl.mobileMerchantNameController.text = method.accountName;
                      }
                      Get.to(EditPaymentMethodScreen());
                    },
                  );
                },
              );
            }),
            const Gap(48),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  ctrl.resetAllData();
                  Get.to(AddPaymentMethodScreen());
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  side: BorderSide(width: 0.8,color: Colors.black26),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )
                ),
                icon: Icon(OwnIcons.payout_method_icon,color: Colors.black,),
                label: Text(
                  'Add Payment Method',
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
            const Gap(32),
            Text(
              'Need Help?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
            const Gap(12),
            OutlinedButton(
              onPressed: () {
                Get.to(HowPayoutWorksScreen());
              },
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  side: BorderSide(width: 0.8, color: Colors.black38),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )
              ),
              child: Row(
                children: [
                  Icon(Icons.file_copy_sharp, color: Colors.black,),
                  const Gap(16),
                  Expanded(
                    child: Text(
                      'How payouts work',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_outlined),
                ],
              ),
            ),
            const Gap(8),
            OutlinedButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "No transaction yet",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
              style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  side: BorderSide(width: 0.8, color: Colors.black26),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )
              ),
              child: Row(
                children: [
                  Icon(Icons.file_copy_sharp, color: Colors.black,),
                  const Gap(16),
                  Expanded(
                    child: Text(
                      'Go to your transaction',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_outlined),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class UserPayoutMethodCard extends StatelessWidget {

  final String asset, method;
  final List<String> details;
  final bool isDefault;
  final Function()? onEdit;
  const UserPayoutMethodCard({super.key, required this.asset, required this.method, this.details = const [], this.onEdit, this.isDefault = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                method,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 1.50,
                ),
              ),
            ),
            if(isDefault)Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(6)
              ),
              child: Text(
                ' Default ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Gap(6),
            SizedBox(
              height: 20,
                width: 20,
                child: IconButton(
                    onPressed: onEdit,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero
                    ),
                    icon: Icon(OwnIcons.edit_icon, size: 18,)
                )
            )
          ],
        ),
        Divider(thickness: 0.7, height: 25,),
        IntrinsicHeight(
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
                  children: details.map((element) => Text(
                    element,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  )).toList(),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}


// Hello I am Tamim