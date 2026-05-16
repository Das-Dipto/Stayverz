import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stayverz_flutter_app/views/home_root/booking/payment_screen.dart';

import '../../../widgets/own_app_bar.dart';

class BookingScreen extends StatefulWidget {
  final dynamic data;
  final String startDate;
  final String endDate;
  final int totalNight;
  final int discount;
  final double total;
   BookingScreen({super.key,required this.discount,this.total = 0,this.data, required this.startDate, required this.endDate, required this.totalNight, });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class GuestController extends GetxController {
  final int maxGuests;
  var adults = 0.obs;
  var children = 0.obs;
  var infants = 0.obs;

  GuestController({required this.maxGuests});

  int get totalGuests => adults.value + children.value;

  void incrementAdults() {
    if (totalGuests < maxGuests) {
      adults.value++;
    }
  }

  void decrementAdults() {
    if (adults.value > 0) {
      adults.value--;
    }
  }

  void incrementChildren() {
    if (totalGuests < maxGuests) {
      children.value++;
    }
  }

  void decrementChildren() {
    if (children.value > 0) {
      children.value--;
    }
  }

  void incrementInfants() {
    infants.value++;
  }

  void decrementInfants() {
    if (infants.value > 0) {
      infants.value--;
    }
  }

  bool get isAdultsIncrementDisabled => totalGuests >= maxGuests;
  bool get isChildrenIncrementDisabled => totalGuests >= maxGuests;
}


class _BookingScreenState extends State<BookingScreen> {


  String formatTimeTo12Hour(String time24) {
    try {
      // Parse 24-hour time string to DateTime
      final dateTime = DateFormat.Hms().parse(time24); // "Hms" handles "12:00:00"

      // Format to 12-hour format with AM/PM
      final formattedTime = DateFormat.jm().format(dateTime); // "jm" gives 12:00 PM
      return formattedTime;
    } catch (e) {
      return 'Invalid Time';
    }
  }


  @override
  Widget build(BuildContext context) {

    //print(widget.data.length_of_stay_discounts);
    final maxGuests = widget.data.guestCount;
    final controller = Get.put(GuestController(maxGuests: maxGuests));
    return Scaffold(
      backgroundColor: Colors.white,
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
                color: Colors.transparent,
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back, size: 20,),
                color: Colors.black,
              ),
            ),
            Text(
              'Booking Details',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(30)
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Gap(20),
          Container(
            height: 100,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            // padding: EdgeInsets.all(12),
            decoration: ShapeDecoration(
              color: const Color(0xFFF5F5F5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 92,
                  height: 100,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image:widget.data.coverPhoto==null? AssetImage("assets/default_image.jpg"):NetworkImage("${widget.data.coverPhoto}"),
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                Gap(10),
                Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(8),
                    Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: Text(
                        '${widget.data.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Gap(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined,size: 19,color: Colors.black87,),
                        Gap(4),
                        Expanded(
                          child: Text(
                            '${widget.data.address}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Gap(5),
                        Text(
                          '৳${widget.data.price - (widget.discount * widget.data.price / 100)}',
                          style: TextStyle(
                            color: Colors.black /* Black */,
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Gap(6),
                        Text(
                          'night',
                          style: TextStyle(
                            color: const Color(0xFF4F4F4F),
                            fontSize: 9,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),


                  ],
                )),
                Gap(8)
              ],
            ),

          ),
          Gap(20),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Check-in',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    widget.startDate,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Check-out',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    widget.endDate,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Gap(25),
          // Container(
          //   padding: EdgeInsets.all(10),
          //   decoration: ShapeDecoration(
          //     color: Colors.white /* white */,
          //     shape: RoundedRectangleBorder(
          //       side: BorderSide(
          //         width: 1,
          //         color: const Color(0xFFF0F1F5) /* Grey-10 */,
          //       ),
          //       borderRadius: BorderRadius.circular(4),
          //     ),
          //   ),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'Contact Details',
          //             style: TextStyle(
          //               color: Colors.black,
          //               fontSize: 16,
          //               fontFamily: 'Inter',
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //         //  Icon(Icons.edit_note_sharp,color: const Color(0xFFF15925),size: 20,),
          //         ],
          //       ),
          //       Gap(5),
          //       Text(
          //         '${widget.data.host.fullName}',
          //         style: TextStyle(
          //           color: const Color(0xFF505050) /* Gray */,
          //           fontSize: 14,
          //           fontFamily: 'Inter',
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //       Row(
          //         children: [
          //           Icon(Icons.mail_outline,size: 14,color: const Color(0xFF505050),),
          //           Gap(4),
          //           Text(
          //             '${widget.data.host.email==null||widget.data.host.email==''?"update soon":widget.data.host.email}',
          //             style: TextStyle(
          //               color: const Color(0xFF505050) /* Gray */,
          //               fontSize: 12,
          //               fontFamily: 'Inter',
          //               fontWeight: FontWeight.w400,
          //             ),
          //           ),
          //         ],
          //       ),
          //       Row(
          //         children: [
          //           Icon(Icons.phone,size: 15,color: const Color(0xFF505050),),
          //           Gap(4),
          //           Text(
          //             '${widget.data.host.phoneNumber}',
          //             style: TextStyle(
          //               color: const Color(0xFF505050) /* Gray */,
          //               fontSize: 12,
          //               fontFamily: 'Inter',
          //               fontWeight: FontWeight.w400,
          //             ),
          //           ),
          //         ],
          //       ),
          //
          //
          //     ],
          //
          //   ),
          // ),
          Gap(20),
          Text(
            'Guest Request',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(10),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Obx(
                        () => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      insetPadding: const EdgeInsets.all(20),
                      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Guests",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                          Text(
                            "This place has a maximum of $maxGuests guests",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildStepper(
                              "Adults",
                              "Ages 13+",
                              controller.adults.value,
                              controller.incrementAdults,
                              controller.decrementAdults,
                              controller.isAdultsIncrementDisabled,
                            ),
                            const SizedBox(height: 20),
                            _buildStepper(
                              "Children",
                              "Ages 2–12",
                              controller.children.value,
                              controller.incrementChildren,
                              controller.decrementChildren,
                              controller.isChildrenIncrementDisabled,
                            ),
                            const SizedBox(height: 20),
                            _buildStepper(
                              "Infants",
                              "Under 2",
                              controller.infants.value,
                              controller.incrementInfants,
                              controller.decrementInfants,
                              false,
                            ),
                          ],
                        ),
                      ),

                      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      actions: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.withOpacity(0.85),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context, {
                                'adults': controller.adults.value,
                                'children': controller.children.value,
                                'infants': controller.infants.value,
                              });
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );

            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0.50,
                    color: const Color(0xFFDCDEE3),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.add_road, color: Colors.red, size: 20),
                  Gap(8),

                  /// 👇 Make this reactive
                  Obx(() {
                    final total = controller.adults.value + controller.children.value;
                    return Text(
                      total > 0
                          ? 'Add Guest Request ($total)'
                          : 'Add Guest Request',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),

                  Spacer(),
                  Icon(Icons.add, color: Colors.red, size: 20),
                ],
              ),
            ),
          ),
          Gap(20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'House Rules',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap(10),
              Row(
                children: [
                  Icon(Icons.access_time,size: 15,color: const Color(0xFF999999),),
                  Gap(5),
                  Text(
                    'Check-in: ${formatTimeTo12Hour(widget.data.checkIn)}',
                    style: TextStyle(
                      color: const Color(0xFF999999) /* Gray-hide-title */,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time,size: 15,color: const Color(0xFF999999),),
                  Gap(5),
                  Text(
                    'Check-out: ${formatTimeTo12Hour(widget.data.checkOut)}',
                    style: TextStyle(
                      color: const Color(0xFF999999) /* Gray-hide-title */,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.smoke_free,size: 15,color: const Color(0xFF999999),),
                  Gap(5),
                  Text(
                    widget.data.smokingAllowed==false? 'No smoking':"allowed smoking",
                    style: TextStyle(
                      color: const Color(0xFF999999) /* Gray-hide-title */,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.pets,size: 15,color: const Color(0xFF999999),),
                  Gap(5),
                  Text(
                    widget.data.petAllowed==true? 'Pets are allowed':'Pets are not allowed',
                    style: TextStyle(
                      color: const Color(0xFF999999) /* Gray-hide-title */,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.group,size: 15,color: const Color(0xFF999999),),
                  Gap(5),
                  Text(
                    widget.data.unmarriedCouplesAllowed==true? 'Unmarried Couple are allowed':'Unmarried Couple are not allowed',
                    style: TextStyle(
                      color: const Color(0xFF999999) /* Gray-hide-title */,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(25),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cancellation policy',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.access_time,size: 15,color: const Color(0xFF999999),),
                  Gap(5),
                  Expanded(
                    child: Text(
                      widget.data.cancellationPolicy.policyName==null||widget.data.cancellationPolicy.policyName==''? "Refund Policy" :'${widget.data.cancellationPolicy.policyName}',
                      style: TextStyle(
                        color: const Color(0xFF999999) /* Gray-hide-title */,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.access_time,size: 15,color: const Color(0xFF999999),),
                  Gap(5),
                  Expanded(
                    child: Text(
                      '${widget.data.cancellationPolicy.description}',
                      style: TextStyle(
                        color: const Color(0xFF999999) /* Gray-hide-title */,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.access_time,size: 15,color: const Color(0xFF999999),),
                  Gap(5),
                  Expanded(
                    child: Text(
                      'Refund protection by Stayverz',
                      style: TextStyle(
                        color: const Color(0xFF999999) /* Gray-hide-title */,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
          Gap(30),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price',
                    style: TextStyle(
                      color: const Color(0xFF4F4F4F),
                      fontSize: 10,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Gap(10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:  '৳${widget.data.price}',
                          style: TextStyle(
                            color: Color(0xFFF15925), // Brand-color
                            fontSize: 15,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: ' /night',
                          style: TextStyle(
                            color: Color(0xFF4F4F4F),
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        if((widget.total - (widget.total * widget.discount/100)) > 0)TextSpan(
                          text: '\nTotal: ৳${(widget.total - (widget.total * widget.discount/100))}',
                          style: TextStyle(
                            color: Color(0xFF4F4F4F),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  if(controller.adults.value<=0){
                    Fluttertoast.showToast(msg: "Please select Minimum 1 Guest");
                    return ;
                  }
                  Get.to(PaymentScreen(
                    data: widget.data,
                    night: widget.totalNight,
                    startDate: widget.startDate,
                    endDate: widget.endDate,
                    price: (widget.total/widget.totalNight),
                    serviceCharge: widget.data.serviceChargePercentage,
                    adultCount: controller.adults.value,
                    childrenCount: controller.children.value,
                    infartCount: controller.infants.value,
                    discount: (widget.discount/100),
                  ));
                },
                child: Container(
                  width: 160,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                    color: Colors.white /* white */,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFDCDEE3) /* Grey-30 */,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 10,
                        offset: Offset(0, 0),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    'Make Payment',
                    style: TextStyle(
                      color: Colors.black /* Black */,
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(20),


        ],
      ),
    );
  }
  Widget _buildStepper(
      String title,
      String subtitle,
      int count,
      VoidCallback onIncrement,
      VoidCallback onDecrement,
      bool isIncrementDisabled,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(subtitle, style: TextStyle(fontSize: 12)),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: count > 0 ? onDecrement : null,
              icon: Icon(Icons.remove_circle_outline),
            ),
            Text('$count', style: TextStyle(fontSize: 16)),
            IconButton(
              onPressed: isIncrementDisabled ? null : onIncrement,
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
  Widget _stepperButton(String label, VoidCallback onTap, bool isEnabled) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400),
          color: isEnabled ? Colors.white : Colors.grey.shade200,
        ),
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: isEnabled ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

}

// Hello I am Tamim