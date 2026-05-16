import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
class OwnTitleAppBar extends StatelessWidget implements PreferredSizeWidget {

  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool borderRadius;
  final String appBarText;
  final VoidCallback? onPressed;
  final bool isBackButtonHide;
  final Color? backgroundColor, fontColor, buttonIconColor;
  const OwnTitleAppBar({super.key, this.backgroundColor, this.fontColor, this.buttonIconColor, required this.appBarText, this.borderRadius = true, this.onPressed, this.isBackButtonHide = false, this.systemOverlayStyle});

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:  SystemUiOverlayStyle(
          statusBarColor: fontColor ?? AppColors.primaryColor
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: double.infinity,
        decoration:  BoxDecoration(
          color: backgroundColor ?? AppColors.primaryColor,
          borderRadius: borderRadius? const BorderRadius.only(bottomLeft: Radius.circular(24),bottomRight: Radius.circular(24)) : null,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(!isBackButtonHide)
              if(ModalRoute.of(context)?.impliesAppBarDismissal ?? false)
                IconButton(
                  style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(35, 35),
                      padding: EdgeInsets.only(left: 9),
                    //  backgroundColor: (buttonIconColor ?? Colors.black).withValues(alpha: 0.2)
                  ),
                  onPressed: () {
                    if(onPressed != null){
                     return onPressed!();
                    }
                    try {
                      Get.back(closeOverlays: true);
                    } catch (e) {
                      // Fallback if SnackbarController is not initialized
                      Get.back();
                    }
                  }, icon: Icon(Icons.arrow_back, color: buttonIconColor ?? Colors.black, size: 22,)),
              const Gap(5),
              Expanded(
                child: Text(
                    appBarText,
                    textScaleFactor: 1,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: fontColor ?? Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )
                ),
              )

            ],
          ),
        ),
      ),
    );

  }

  @override
  Size get preferredSize => const Size(double.infinity,65);
}
// Hello I am Tamim