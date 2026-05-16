import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class OwnAppBar extends StatelessWidget implements PreferredSizeWidget {

  final SystemUiOverlayStyle? systemOverlayStyle;
  final double? appHeight;
  final EdgeInsets? padding;
  final Widget child;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  const OwnAppBar({super.key, this.borderRadius,this.padding, this.backgroundColor, required this.child, this.systemOverlayStyle, this.appHeight});

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle ?? SystemUiOverlayStyle(
          statusBarColor: backgroundColor ?? Colors.white
      ),
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
        height: double.infinity,
        decoration:  BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 2,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ]
        ),
        child: SafeArea(
          child: child,
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(
      double.infinity,
      appHeight ?? 100
  );
}
// Hello I am Tamim