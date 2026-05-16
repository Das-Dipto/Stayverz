import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/constants/app_colors.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';
import 'package:stayverz_flutter_app/widgets/own_icons_icons.dart';
import '../../../../widgets/own_title_app_bar.dart';
import '../../controllers/inbox_controller.dart';
import '../../data/models/quick_reply_message_response.dart';

class QuickRepliesScreen extends GetView<InboxController> {

  QuickRepliesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: "Quick Replies",
        backgroundColor: Colors.white,
        fontColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {

          if(controller.isQuickReplyLoading) {
            return Center(
              child: SizedBox(
                height: 35,
                width: 35,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 25,
                    child: TextButton.icon(
                      onPressed: () {

                       // Get.dialog(CreateQuickRepliesDialog());

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => CreateQuickRepliesDialog(),
                        );

                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Create New'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 10)
                      ),
                    ),
                  ),
                ),
                const Gap(15),
                ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      QuickReplyData data = controller.myQuickReply[index];
                      return InkWell(
                        onTap: () {
                          Get.back(result: data.description);
                        },
                        child: InboxListItem(
                          name: data.title,
                          message: data.description,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Gap(12),
                    itemCount: controller.myQuickReply.length
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class InboxListItem extends StatelessWidget {

  final String? name, message;
  const InboxListItem({super.key, this.name, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: ShapeDecoration(
        color: Colors.white /* white */,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.94,
            color: const Color(0xFFF0F1F5) /* Grey-10 */,
          ),
          borderRadius: BorderRadius.circular(7.53),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: ShapeDecoration(
              color: const Color(0xFFD9D9D9),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Icon(OwnIcons.message_1_icon, size: 18, color: Colors.black54,),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                  ),
                ),
                Text(
                  message ?? '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CreateQuickRepliesDialog extends GetView<InboxController> {
  CreateQuickRepliesDialog({super.key});

  TextEditingController titleTextField = TextEditingController();
  TextEditingController messageTextField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white /* white */,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: const Color(0xFFF0F1F5) /* Grey-10 */,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create saved reply',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
                SizedBox(
                  width: 18,
                  height: 18,
                  child: IconButton(onPressed: () {
                    Get.back();
                  },
                      padding: EdgeInsets.zero,
                      icon: Icon(OwnIcons.cross_icon, size: 18,)),
                )
              ],
            ),
            const Gap(8),
            Text(
              'Ass a text shortcut to quickly insert reply',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400
              ),
            ),
            const Gap(8),
            Text(
              'Short Title',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            const Gap(6),
            CustomInputText(
              helperText: 'Add title',
              controller: titleTextField,
            ),
            const Gap(14),
            Text(
              'Message',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            const Gap(6),
            CustomInputText(
              helperText: 'Write a message...',
              controller: messageTextField,
              maxLength: 1000,
              maxLines: 2,
            ),
            const Gap(16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(onPressed: () {
                    Get.back();
                  },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA9A9B0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)
                      )
                    ),
                    child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white /* white */,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.50,
                    ),
                  )),
                ),
                const Gap(10),
                Expanded(
                  child: Obx(() {
                      return ElevatedButton(onPressed: controller.isQuickReplyCreating ? null : () => controller.createQuickReply(titleTextField.text, messageTextField.text),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)
                              )
                          ),
                          child: controller.isQuickReplyCreating ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          ) : Text(
                            'Save',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white /* white */,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                            ),
                          ));
                    }
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}


// Hello I am Tamim