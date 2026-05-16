import 'package:flutter/material.dart';

class HeadingTextWidget extends StatelessWidget {
  final String text;
  final double? horizontalGap, verticalGap;
  const HeadingTextWidget({super.key, required this.text, this.horizontalGap, this.verticalGap});

  @override
  Widget build(BuildContext context) {

    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0);

    if(horizontalGap != null) {
      padding = EdgeInsets.symmetric( horizontal: horizontalGap!);
    } else if(verticalGap != null) {
      padding = EdgeInsets.symmetric( vertical: verticalGap!);
    }

    return Padding(
      padding: padding,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          height: 1.33,
        ),
      ),
    );
  }
}

// Hello I am Tamim