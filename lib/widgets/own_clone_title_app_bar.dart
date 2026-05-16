import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../core/constants/app_colors.dart';

class OwnTitleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final SystemUiOverlayStyle? systemOverlayStyle;

  final String title;
  final Color? backgroundColor, titleColor;
  final FontWeight? titleFontWeight;
  final double? titleFontSize;
  final BorderRadiusGeometry? borderRadius;
  final bool centerTitle;
  final VoidCallback? onPressed;
  final bool isBackButtonHide;
  final List<Widget> actions;
  const OwnTitleAppBar({
    super.key,
    this.onPressed,
    this.isBackButtonHide = false,
    this.borderRadius,
    this.titleFontWeight,
    this.titleFontSize,
    this.centerTitle = false,
    this.titleColor,
    this.backgroundColor,
    required this.title,
    this.systemOverlayStyle,
    this.actions = const []
  });

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle value =
        systemOverlayStyle ??
        SystemUiOverlayStyle(
          statusBarColor: backgroundColor ?? const Color(0xff003656),
        );

    TextStyle titleTextStyle = TextStyle(
      color: titleColor ?? Colors.white,
      fontWeight: titleFontWeight,
      fontSize: titleFontSize,
      overflow: TextOverflow.ellipsis,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: value,
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primaryColor,
          borderRadius: borderRadius ?? BorderRadius.zero,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!isBackButtonHide)
                  if (ModalRoute.of(context)?.impliesAppBarDismissal ?? false)
                    IconButton(
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(35, 35),
                        padding: EdgeInsets.only(left: 9),
                        backgroundColor: Colors.black.withOpacity(.1),
                      ),
                      onPressed: () {
                        if (onPressed != null) {
                          return onPressed!();
                        }
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                if (!centerTitle) const Gap(10),
                if (centerTitle)
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Text(
                          title,
                          textScaleFactor: 1,
                          style: titleTextStyle,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                      child: Text(
                          title,
                          style: titleTextStyle,
                          textScaleFactor: 1
                      )
                  ),
                  ...(actions)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(double.infinity, 60);
}

// Hello I am Tamim