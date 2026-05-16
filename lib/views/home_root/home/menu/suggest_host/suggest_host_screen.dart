import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:stayverz_flutter_app/widgets/profile_avatar_widget.dart';
import '../../../../../widgets/own_icons_icons.dart';
import '../../../../../widgets/own_title_app_bar.dart';

class SuggestHostScreen extends StatefulWidget {
  const SuggestHostScreen({super.key});

  @override
  State<SuggestHostScreen> createState() => _SuggestHostScreenState();
}

class _SuggestHostScreenState extends State<SuggestHostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnTitleAppBar(
        appBarText: 'Suggest Host',
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
              child: OutlinedButton.icon(
                onPressed: () {

                },
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    side: BorderSide(width: 0.8, color: Colors.black38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                ),
                icon: Icon(OwnIcons.refer_host_icon, color: Colors.black,),
                label: Text(
                  'Suggest a Host',
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
            const Gap(24),
            Text(
              'Suggested Host List',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
            const Gap(16),
            ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(8),
                  decoration: ShapeDecoration(
                    color: Colors.white /* white */,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    shadows: [
                      BoxShadow(
                        color: Color(0x1D000000),
                        blurRadius: 4.30,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    spacing: 16,
                    children: [
                      ProfileAvatarWidget(
                        url: '',
                        radius: 28,
                        size: 38,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Atikur Rahman',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              height: 1.50,
                            ),
                          ),
                          Text(
                            'Host',
                            style: TextStyle(
                              color: const Color(0xFF67666B) /* Grey-70 */,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                          Text(
                            'Total Booking : 3',
                            style: TextStyle(
                              color: const Color(0xFF67666B) /* Grey-70 */,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                          Text(
                            'Total Earnings : ৳ 30',
                            style: TextStyle(
                              color: const Color(0xFF67666B) /* Grey-70 */,
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Gap(8),
              itemCount: 3,
            )
          ],
        ),
      ),
    );
  }
}

// Hello I am Tamim