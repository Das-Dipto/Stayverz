import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stayverz_flutter_app/widgets/custom_input_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/own_app_bar.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final List<ContactInfo> contacts = [
    ContactInfo(iconPath: Icon(Icons.phone_in_talk_outlined,color: Colors.deepOrangeAccent,), phoneNumber: '+8809606292909'),
    ContactInfo(iconPath: Icon(Icons.quick_contacts_dialer,color: Colors.deepOrangeAccent,), phoneNumber: '+8801879997999'),
    ContactInfo(iconPath:Icon(Icons.email_sharp,color: Colors.deepOrangeAccent,),phoneNumber: 'hello@stayverz.com'),
  ];

  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();
  // URLs for web fallback
  final facebookUrl = "https://www.facebook.com/StayverzApp";
  final instagramUrl = "https://www.instagram.com/stayverz_app/?igsh=NWk2bjBneDk2dzZy#";
  final tiktokUrl = "https://www.tiktok.com/@stayverz?_t=8lhvGs1IARL&_r=1";
  final YoutubeUrl = "https://www.tiktok.com/@stayverz?_t=8lhvGs1IARL&_r=1";

  // App URI schemes to try open the app directly:
  final facebookAppUrl = "fb://facewebmodal/f?href=https://www.facebook.com/StayverzApp";
  final instagramAppUrl = "instagram://user?username=stayverz_app";
  final tiktokAppUrl =  "tiktok://user/@stayverz";
  final YoutubeAppUrl = "https://www.youtube.com/@stayverz";


  Future<void> _launchSocial(String appUrl, String webUrl) async {
    final Uri appUri = Uri.parse(appUrl);
    final Uri webUri = Uri.parse(webUrl);

    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } else {
      // Could show a message that no browser/app is available
    }
  }

  void _submitForm() {
    if (firstNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "All fields are required",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
        msg: "Submitted successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Clear all fields
      firstNameController.clear();
      emailController.clear();
      phoneController.clear();
      messageController.clear();
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnAppBar(
        appHeight: 60,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.1),
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                color: Colors.black,
              ),
            ),
            const Text(
              'Contact Us',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
          children: [
            Gap(16),
           Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(12),
               color: Colors.deepOrangeAccent.withOpacity(0.1)
             ),
             padding: EdgeInsets.all(12),
             child: Column(
               children: [
                 const Text(
                   'Contact Information',
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     color: Colors.black,
                     fontSize: 30,
                     fontWeight: FontWeight.w600,
                   ),
                 ),
                 const Gap(10),
                 const Text(
                   'Say Something to start a live chat!',
                   textAlign: TextAlign.center,
                   style: TextStyle(
                     fontSize: 16,
                   ),
                 ),
                 const Gap(35),
                 ListView.separated(
                   separatorBuilder: (context, index) => const Gap(10),
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount: contacts.length,
                   itemBuilder: (context, index) {
                     final contact = contacts[index];
                     return Column(
                       children: [
                         contact.iconPath,
                         const Gap(10),
                         Text(
                           contact.phoneNumber,
                           style: const TextStyle(
                             fontSize: 16,
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                       ],
                     );
                   },
                 ),
                 const Gap(10),
                 Icon(Icons.location_on_rounded,color: Colors.deepOrangeAccent,),
                 Gap(10),
                 const Text(
                     "Lebel 4 & 5 Plot - 64 Road - 5, Sector - 12, Uttara, Dhaka",
                   textAlign: TextAlign.center,
                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                 ),
                 const Gap(20),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     IconButton(
                       icon: Image.asset(
                         'assets/fb.png',
                         width: 25,
                         height: 25,
                       ),
                       onPressed: () => _launchSocial(facebookAppUrl, facebookUrl),
                     ),
                     Gap(4),
                     IconButton(
                       icon: Image.asset(
                         'assets/insta.png',
                         width: 25,
                         height: 25,
                       ),
                       onPressed: () => _launchSocial(instagramAppUrl, instagramUrl),
                     ),
                     Gap(4),
                     IconButton(
                       icon: const Icon(Icons.tiktok, color: Colors.black, size: 30), // TikTok icon substitute
                       onPressed: () => _launchSocial(tiktokAppUrl, tiktokUrl),
                     ),
                     Gap(4),
                     IconButton(
                       icon: Image.asset(
                         'assets/youtube.png',
                         width: 25,
                         height: 25,
                       ),
                       onPressed: () => _launchSocial(YoutubeAppUrl, YoutubeUrl),
                     ),
                   ],
                 ),
               ],
             ),
           ),
            const Gap(20),
            // First Name
            const Text('First Name', style: TextStyle(fontWeight: FontWeight.w600)),
            const Gap(10),
            CustomInputText(
              controller: firstNameController,
              onChange: _requiredValidator,
            ),
            const Gap(20),
            // Email
            const Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
            const Gap(10),
            CustomInputText(
              controller: emailController,
              onChange: _requiredValidator,
            ),
            const Gap(20),
            // Phone
            const Text('Phone', style: TextStyle(fontWeight: FontWeight.w600)),
            const Gap(10),
            CustomInputText(
              controller: phoneController,
              onChange: _requiredValidator,
            ),
            const Gap(20),
            // Message
            const Text('Your Message', style: TextStyle(fontWeight: FontWeight.w600)),
            const Gap(10),
            CustomInputText(
              controller: messageController,
              onChange: _requiredValidator,
              maxLines: 5,
              borerRadius: 24,
            ),
            const Gap(30),
            GestureDetector(
              onTap: _submitForm,
              child: Container(
                width: 160,
                margin: const EdgeInsets.symmetric(horizontal: 90),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFFA9A9B0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  'Send message',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Gap(20),
          ],
        ),
      ),
      floatingActionButton: InkWell(
     onTap: _openWhatsApp,
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage('assets/wp.png'), fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
  final String whatsappUrl = "https://api.whatsapp.com/send/?phone=8801879997999&text&type=phone_number&app_absent=0";
  Future<void> _openWhatsApp() async {
    final Uri url = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
    }
  }
}

class ContactInfo {
  final Icon iconPath;
  final String phoneNumber;
  ContactInfo({required this.iconPath, required this.phoneNumber});
}

// Hello I am Tamim