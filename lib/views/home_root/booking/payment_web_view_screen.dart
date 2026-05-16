import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

import '../../../features/messaging/bindings/messaging_binding.dart';
import '../../../features/messaging/controllers/inbox_controller.dart';
import '../guest_bottom_navigation_bar_view.dart';
// Import your TripScreen

class PaymentWebViewScreen extends StatefulWidget {
  final String url;
  final String booKiD;

  const PaymentWebViewScreen({
    Key? key,
    required this.url,
    required this.booKiD,
  }) : super(key: key);

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool isLoading = true;
  // final MainController mainControl = Get.find<MainController>();
  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => isLoading = true);


            // Check for success/fail/cancel in URL parameters
            if (isSuccessUrl(url,widget.booKiD)) {
               Get.off(GuestBottomNavigationBarView(page: 1,));
              if (Get.isRegistered<InboxController>()) {
                MessagingBinding().dependencies();
                var mc = Get.find<InboxController>();
                mc.loadChatRooms();
              }
            } else if (url.contains('tran_type=fail')) {
              Get.snackbar("Payment", "Payment failed ❌");
              Get.back();
            } else if (url.contains('tran_type=cancel')) {
              Get.snackbar("Payment", "Payment cancelled ⚠️");
              Get.back();
            }
          },
          onPageFinished: (url) {
            setState(() => isLoading = false);
          },
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Go back
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
bool isSuccessUrl(String url, String bookId) {
  try {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;

    // Check if there are at least two segments for "success" and bookId
    if (segments.length >= 2) {
      final lastSegment = segments.last;
      final secondLastSegment = segments[segments.length - 2];

      if (secondLastSegment == 'success' && lastSegment == bookId) {
        return true;
      }
    }
  } catch (e) {
    // Invalid URL
    return false;
  }

  return false;
}

// Hello I am Tamim