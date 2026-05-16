import 'package:flutter/material.dart';

class EditListingItem extends StatelessWidget {
  final String title, value;
  final Function()? onPress;
  const EditListingItem({super.key, required this.title, required this.value, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black /* Black */,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.50,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: const Color(0xFF67666B) /* Grey-70 */,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
            SizedBox(
              height: 20,
              child: TextButton(
                onPressed: onPress,
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero
                ),
                child: Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    height: 1.50,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
// Hello I am Tamim