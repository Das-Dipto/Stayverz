import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/controllers/webview_inbox_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../main.dart';

class WebViewInboxScreen extends StatelessWidget {
  WebViewInboxScreen({super.key});

  var webControl = Get.put(
    InboxWebViewController(
      // "https://www.stayverz.com/host-dashboard/inbox",
      "https://stayverz.divergenttechbd.com/host-dashboard/inbox",
      cookieToken: mainControl.accessToken.value,
      refreshToken: mainControl.refreshToken.value,
      accessToken: mainControl.accessToken.value,
      userType: mainControl.uType.value,
    ),
  );
  RxBool visibility = false.obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        if (!visibility.value) {
          return WebViewWidget(
            controller: webControl.controller!,
            gestureRecognizers:
                Set()..add(
                  Factory<VerticalDragGestureRecognizer>(
                    () =>
                        VerticalDragGestureRecognizer()
                          ..onDown = (DragDownDetails dragDownDetails) {
                            webControl.controller!.getScrollPosition().then((
                              value,
                            ) {
                              if (value.dy == 0 &&
                                  dragDownDetails.globalPosition.direction <
                                      0.5) {
                                webControl.controller!.reload();
                              }
                            });
                          },
                  ),
                ),
          );
        }
        return Container(
          alignment: Alignment.center,
          child: const Icon(Icons.ac_unit, size: 50),
        );
      }),
    );
  }
}

// Hello I am Tamim