import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../constants/app_colors.dart';

class MainUtils {

  /// Converts a timestamp string to a relative time string (e.g., "now", "1m", "1h", etc.)
  ///
  /// @param dateStr The ISO 8601 formatted date string to convert
  /// @return A human-readable relative time string
  ///
  ///


  static bool looksLikeJson(String input) {
    final jsonLikeRegex = RegExp(r'^\s*(\{.*\}|\[.*\])\s*$');
    return jsonLikeRegex.hasMatch(input);
  }

  static String? validateStrongPassword(String password) {
    if (password.length < 8) {
      return "Invalid password, Password should be minimum 8 characters";
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return "Password must contain at least one uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return "Password must contain at least one lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return "Password must contain at least one digit";
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return "Password must contain at least one special character";
    }
    return null; // Valid password
  }

  static String getTimeAgo(String dateStr) {
    try {
      final DateTime date = DateTime.parse(dateStr).toLocal();
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(date);

      // Within last minute
      if (difference.inSeconds < 60) {
        return 'now';
      }

      // Within last hour
      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m';
      }

      // Within last day
      if (difference.inHours < 24) {
        return '${difference.inHours}h';
      }

      // Within last week
      if (difference.inDays < 7) {
        return '${difference.inDays}d';
      }

      // Within last month
      if (difference.inDays < 30) {
        final int weeks = (difference.inDays / 7).floor();
        return '$weeks week${weeks > 1 ? 's' : ''}';
      }

      // Within last year
      if (difference.inDays < 365) {
        final int months = (difference.inDays / 30).floor();
        return '$months month${months > 1 ? 's' : ''}';
      }

      // More than a year
      final int years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''}';
    } catch (e) {
      return '';  // Return empty string if date parsing fails
    }
  }

  static String formatAmount(int? amount) {
    if (amount == null || amount < 1000) {
      return "(${(amount ?? 0).toString()})";
    } else if (amount < 1000000) {
      return "(${'${(amount / 1000).toStringAsFixed((amount % 1000 == 0) ? 0 : 1)}K'})";
    } else if (amount < 1000000000) {
      return "(${'${(amount / 1000000).toStringAsFixed((amount % 1000000 == 0) ? 0 : 1)}M'})";
    } else {
      return "(${'${(amount / 1000000000).toStringAsFixed((amount % 1000000000 == 0) ? 0 : 1)}B'})";
    }
  }

 static Future<List<XFile>> pickImagesFromGallery() async {
  final ImagePicker picker = ImagePicker();

  final List<XFile> images = await picker.pickMultiImage();
  return images;
}

// Keep old method for backward compatibility
static Future<XFile?> pickImageFromGallery() async {
  final ImagePicker picker = ImagePicker();

  final XFile? image = await picker.pickImage(
      source: ImageSource.gallery);
  return image;
}

  static Future<XFile?> takePhotoByCamera() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
        source: ImageSource.camera);
    return image;
  }

  static String formatDateMonth(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    final formatter = DateFormat('MMM d yyyy');
    return formatter.format(dateTime);
  }

 static void showErrorSnackBar(String message, {Color? background}) {
   Get.showSnackbar(
     GetSnackBar(
       title: "Oops! Something went wrong",
       message: message,
       icon: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30),
       snackPosition: SnackPosition.TOP,
       duration: const Duration(milliseconds: 1500),
       borderRadius: 14,
       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
       backgroundGradient: LinearGradient(
         colors: [Colors.deepPurpleAccent.shade200, Colors.pinkAccent.shade400],
         begin: Alignment.topLeft,
         end: Alignment.bottomRight,
       ),
       boxShadows: [
         BoxShadow(
           color: Colors.black.withOpacity(0.25),
           blurRadius: 12,
           offset: const Offset(2, 6),
         ),
       ],
       overlayBlur: 2,
       overlayColor: Colors.black26,
       forwardAnimationCurve: Curves.elasticOut,
       reverseAnimationCurve: Curves.easeIn,
       isDismissible: true,
       mainButton: TextButton(
         onPressed: () => Get.back(),
         child: const Text(
           "DISMISS",
           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
         ),
       ),
     ),
   );
 }

 static String handleLocalizationNullException(Map<String, dynamic> data, {String? enKey, String? bnKey, String? defaultValue}){
   var isBn = Get.locale?.languageCode == 'bn';
   var enValue = data[enKey ?? ''];
   var bnValue = data[bnKey ?? ''];

   if(isBn && bnValue == null && enValue != null){
     return "${enValue ?? defaultValue ?? ''}";
   }

   if(isBn && bnValue != null){
     return bnValue;
   }

   return "${enValue ?? defaultValue ?? ''}";
 }

 static String convertToBanglaNumber(String englishNumberString) {
   const Map<String, String> digitMap = {
     '0': '০',
     '1': '১',
     '2': '২',
     '3': '৩',
     '4': '৪',
     '5': '৫',
     '6': '৬',
     '7': '৭',
     '8': '৮',
     '9': '৯',
   };


   if(Get.locale?.languageCode != 'bn') return englishNumberString;

   return englishNumberString.split('').map((char) {
     return digitMap[char] ?? char;  // Return the mapped Bangla digit or the character itself if not a digit
   }).join('');
 }

 // Main function to convert English date to Bangla date
  /// Get current location with address
  static Future<Map<String, dynamic>> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are disabled, ask user to enable them
        bool serviceRequested = await Geolocator.openLocationSettings();
        if (!serviceRequested) {
          return {
            'success': false,
            'error': 'Location services are disabled and could not be enabled',
          };
        }
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return {
            'success': false,
            'error': 'Location permissions are denied',
          };
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return {
          'success': false,
          'error': 'Location permissions are permanently denied',
        };
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        localeIdentifier: Get.deviceLocale?.languageCode ?? 'en',
      );

      if (placemarks.isEmpty) {
        return {
          'success': true,
          'latitude': position.latitude,
          'longitude': position.longitude,
          'address': 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}',
        };
      }

      Placemark place = placemarks.first;
      String address = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      
      return {
        'success': true,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
        'placemark': place,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to get location: $e',
      };
    }
  }

  static void showSuccessSnackBar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        title: "Success!",
        message: message,
        icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 30),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 1),
        borderRadius: 14,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        backgroundGradient: LinearGradient(
          colors: [Colors.tealAccent.shade400, Colors.greenAccent.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
        overlayBlur: 2,
        overlayColor: Colors.black26,
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeIn,
        isDismissible: true,
        mainButton: TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            "GOT IT",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }


  static customDialog({required BuildContext context, VoidCallback? function, String content = 'Doctor is not online!', String buttonText = "Close"}){

   return showDialog(context: context, builder: (context) {
     return  AlertDialog(
       alignment: Alignment.center,
       backgroundColor: Colors.white,
       surfaceTintColor: Colors.white,
       clipBehavior: Clip.none,
       shadowColor: Colors.white,
       actions: [
         Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             const SizedBox(
               height: 20,
             ),
             Container(
               width: double.infinity,
               padding:
               const EdgeInsets.only(left: 20, top: 30,right: 20),
               child:    Text(
                   content,
                   textAlign: TextAlign.center,
                   style: const TextStyle(
                     fontSize: 18,
                     fontWeight: FontWeight.w600,
                     color: Color(0xFF246C54),
                   )),
             ),
             const SizedBox(
               height: 50,
             ),
             InkWell(
               onTap: function ?? () {
                 Navigator.pop(context);
               },
               child: Container(
                 height: 40,
                 width: 188,
                 decoration: BoxDecoration(
                   color: const Color(0xFF246C54),
                   borderRadius: BorderRadius.circular(15),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.grey.withOpacity(0.5),
                       blurRadius: 2,
                       offset: const Offset(
                           0, 2), // changes position of shadow
                     ),
                   ],
                 ),
                 child:     Center(
                   child: Text(buttonText,
                       style: const TextStyle(
                         fontSize: 14,
                         color: Colors.white,
                         fontWeight: FontWeight.w500,
                       )),
                 ),
               ),
             ),
             const SizedBox(
               height: 20,
             ),
           ],
         ),
       ],);
   },);
 }

  static String countToK(String num){
    if(num.length > 4){
      return "${convertDoubleToFixedDecimalPlaces(value:  double.parse(num) / 1000, places: 1)}K";
    }
    return num;
  }



  static Future<PlatformFile?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      return result.files.single;
    } else {
      return null;
    }
  }

 static String formatDate({required String timeStamp, String formatPattern = 'dd MMMM yyyy'}){
    final dateTime = DateTime.parse(timeStamp);
    DateTime bangladeshDateTime = dateTime.add(const Duration(hours: 6));
    // Format the date using Intl
    final formattedDate = DateFormat(formatPattern).format(bangladeshDateTime);
    return formattedDate;
  }

 static void launchURL(String url) async {
   final Uri uri = Uri.parse(url);
   if (!await launchUrl(uri)) {
     throw Exception('Could not launch $uri');
   }
 }

 static Future<bool> onBackPressed(
     {required BuildContext context,
      String? no,
      String? yes,
      String? title,
      String? subTitle,
      VoidCallback? onYesPressed}) async {
   return (await showDialog<bool>(
     context: context,
     builder: (context) {
       return AlertDialog(
         shape: RoundedRectangleBorder(
             borderRadius:
             BorderRadius.circular(16.0)),
         backgroundColor:   Colors.white,
         title:   Text(title??'Exit App?',style: const TextStyle(color: Colors.black),),
         titleTextStyle: const TextStyle(
           color: Colors.black,
           fontWeight: FontWeight.w700,
           fontSize: 18,
         ),
         contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
         content:   Text(
           subTitle?? 'Are you sure you want to exit the app?',
         ),
         contentTextStyle: const TextStyle(
           color: Color(0xFF507267),
           fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
         actions: <Widget>[
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 12.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 Expanded(
                   child: ElevatedButton(
                     onPressed: () {
                       Navigator.of(context).pop(false); // Cancel the exit
                     },
                     style: ElevatedButton.styleFrom(
                       minimumSize: const Size(100, 40),
                       backgroundColor: Colors.grey.withOpacity(0.6),
                       elevation: 0,
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8),
                       ),
                     ),

                     child:   Text(
                       no?? 'Stay',
                       style: const TextStyle(
                         color: Colors.white,
                         fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                     ),

                   ),
                 ),
                 const Gap(10),
                 Expanded(
                   child: ElevatedButton(
                     onPressed: () {
                       if(onYesPressed != null){
                        return onYesPressed();
                       }
                       // Navigator.of(context).pop(true); // Confirm the exit
                       SystemNavigator.pop();
                     },
                     style: ElevatedButton.styleFrom(
                       minimumSize: const Size(100, 40),
                       backgroundColor: Colors.red.withOpacity(0.7),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8),
                       ),
                       elevation: 0
                     ),
                     child:  Text(
                       yes??'Exit App',
                       style: const TextStyle(
                         color: Colors.white,
                         fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                     ),
                   ),
                 ),
               ],

             ),
           ),


         ],
       );
     },
   ) ) ?? false;
 }

 static Future<bool> genericCustomPopup(
     {required BuildContext context,
      String? no,
      String? yes,
      String? title,
      String? subTitle,
      VoidCallback? onYesPressed}) async {
   return (await showDialog<bool>(
     context: context,
     builder: (context) {
       return AlertDialog(
         shape: RoundedRectangleBorder(
             borderRadius:
             BorderRadius.circular(16.0)),
         backgroundColor:   Colors.white,
         title:   Text(title??'Exit App?',style: const TextStyle(color: Colors.black),),
         titleTextStyle: const TextStyle(
           color: Colors.black,
           fontWeight: FontWeight.w700,
           fontSize: 36,
         ),
         content:   Text(
           subTitle?? 'Are you sure you want to exit the app?',
         ),
         contentTextStyle: const TextStyle(
           color: Color(0xFF507267),
           fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
         actions: <Widget>[
           Center(
             child:  ElevatedButton(
               onPressed: () {
                 Navigator.of(context).pop(); // Cancel the exit
               },
               style: ElevatedButton.styleFrom(
                 minimumSize: const Size(100, 40),
                 backgroundColor: const Color(0xFF246C54),

                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(8),
                 ),
               ),

               child:   Text(
                 no?? 'Stay',
                 style: const TextStyle(
                   color: Colors.white,
                   fontSize: 16,
                   fontWeight: FontWeight.w600,
                 ),
               ),

             ),
           ),


         ],
       );
     },
   ) ) ?? false;
 }

  static void showToastMessage({String? title, String? message, Color? color, SnackPosition snackPosition = SnackPosition.BOTTOM}) {

    Get.showSnackbar(GetSnackBar(
       borderRadius: 10,
      snackPosition: snackPosition,
      title: title,
      message: message,
      backgroundColor: color ?? AppColors.primaryColor,
      duration: const Duration(
        seconds: 3
      ),
    ));
  }

 static void showToastMessageL({String? title, String? message, Color? color}) {
   Get.showSnackbar(GetSnackBar(
     title: title,

     messageText: Text(
       message ?? '',
       style: const TextStyle(
         color: Colors.white,
         fontWeight: FontWeight.w500,
         fontSize: 15
       ),
     ),
     snackPosition: SnackPosition.TOP,
     backgroundColor: color ?? AppColors.primaryColor,
     duration: const Duration(
         seconds: 1
     ),
   ));
 }

 static String convertDoubleToFixedDecimalPlaces({required double value, int places = 2}){
    String formattedString = value.toStringAsFixed(places);
    return formattedString;
  }

  static String formatSecondsToMinutes(int seconds) {
   int  m = seconds ~/ 60;
    return "$m m";
  }

  static Future<bool> callContact({required String phnNo}) async {
    final url = 'tel:$phnNo';
    if(await canLaunchUrlString(url)) {
      await launchUrlString(url);
      return true;
    } else {
      return false;
    }

  }

  static Future<String> downloadFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    await File(filePath).writeAsBytes(response.bodyBytes);
    return filePath;
  }

 static String? checkEmptyFields(Map<String,TextEditingController> data) {

   for (var entry in data.entries) {
     if(entry.value.text.isEmpty) {
       return entry.key;
     }
   }
   return null;
 }

}
// Hello I am Tamim