import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/utils/main_utils.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';


class WebViewInboxConversationScreen extends StatefulWidget {
  const WebViewInboxConversationScreen({super.key, required this.url, this.accessToken, this.refreshToken, this.cookieToken, this.userType});
  final String? cookieToken;
  final String? refreshToken;
  final String? accessToken;
  final String? userType;
  final String? url;

  @override
  State<WebViewInboxConversationScreen> createState() => _WebViewInboxConversationScreenState();
}

class _WebViewInboxConversationScreenState extends State<WebViewInboxConversationScreen> {

  RxBool visibility = false.obs;

  WebViewController? controller;

  late final PlatformWebViewControllerCreationParams params;

  // Authentication tokens

  @override
  void initState() {
    initSetting();
    initController(widget.url!);
    super.initState();
  }

  @override
  void dispose() {
    controller?.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (!visibility.value) {
            return WebViewWidget(
              controller: controller!,
              gestureRecognizers:
              Set()..add(
                Factory<VerticalDragGestureRecognizer>(
                      () =>
                  VerticalDragGestureRecognizer()
                    ..onDown = (DragDownDetails dragDownDetails) {
                      controller!.getScrollPosition().then((
                          value,
                          ) {
                        if (value.dy == 0 &&
                            dragDownDetails.globalPosition.direction <
                                0.5) {
                          controller!.reload();
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
      ),
    );
  }

  initSetting() {

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      // iOS WebView configuration with WebSocket support
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      // Android WebView configuration
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController control =
    WebViewController.fromPlatformCreationParams(params);
    if (control.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (control.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  void initController(String webUrl) {
    controller =
    WebViewController(
      onPermissionRequest: (request) {
        // Auto-grant permission requests for better compatibility
        request.grant();
      },
    )
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: onProgress,
          onPageStarted: onPageStarted,
          onPageFinished: onPageFinished,
          onUrlChange: (change) async {
            // print("url changed runJavaScript script started document.querySelector('.fixed')?.style.display='none';");
            await controller!.runJavaScript(
                "document.querySelector('.fixed').style.display='none';"
            );
            // print("url changed runJavaScript script ended document.querySelector('.fixed')?.style.display='none';");
          },
          onWebResourceError: (WebResourceError error) {
            onWebResourceError(error);
          },
          onNavigationRequest: onNavigationRequest,
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
    // Add JavaScript channels for communication
      ..addJavaScriptChannel(
        'test_channel',
        onMessageReceived: (JavaScriptMessage message) {
          // print("javascript test channel receive a message: ");
          MainUtils.showSuccessSnackBar(message.message);
        },
      )
    // Add WebSocket status channel
      ..addJavaScriptChannel(
        'websocket_channel',
        onMessageReceived: (JavaScriptMessage message) {
          // Handle WebSocket-related messages
          if (message.message.contains('error') ||
              message.message.contains('closed')) {
            _handleWebSocketReconnect();
          }
        },
      );

    // Enable WebSocket support
    _enableWebSockets();

    // Set cookies before loading the URL
    _setCookies(webUrl);

    // Create headers map with authentication tokens
    Map<String, String> headers = {};

    // Add existing token if needed
    // headers["token"] = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtc2lzZG4iOiI4ODAxOTczMTc0NDI2IiwiaWF0IjoxNzMxOTE3MDk0LCJleHAiOjE3MzE5NTI3OTl9.buMr-kF-E_mrgtMUKAOROBGNRygfJo6tDNWK7RzgD7k";

    // Add access token to headers if available
    if (widget.accessToken != null && widget.accessToken!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $widget.accessToken';
    }

    controller!.loadRequest(Uri.parse(webUrl));
  }

  /// Set cookies in the WebView using WebViewCookieManager
  /// Enables proper WebSocket connection by ensuring cookies are set correctly
  void _setCookies(String webUrl) async {
    if (controller == null) return;

    Uri uri = Uri.parse(webUrl);
    String domain = uri.host;
    final WebViewCookieManager cookieManager = WebViewCookieManager();

    // Clear existing cookies first (optional)
    // await cookieManager.clearCookies();

    // Set cookie_token if available
    if (widget.cookieToken != null && widget.cookieToken!.isNotEmpty) {
      await cookieManager.setCookie(
        WebViewCookie(
          name: 'cookie_token',
          value: widget.cookieToken!,
          domain: domain,
          path: '/',
        ),
      );
    }

    // Set refresh_token if available
    if (widget.refreshToken != null && widget.refreshToken!.isNotEmpty) {
      await cookieManager.setCookie(
        WebViewCookie(
          name: 'refresh_token',
          value: widget.refreshToken!,
          domain: domain,
          path: '/',
        ),
      );
    }

    // Set access_token if available
    if (widget.accessToken != null && widget.accessToken!.isNotEmpty) {
      await cookieManager.setCookie(
        WebViewCookie(
          name: 'access_token',
          value: widget.accessToken!,
          domain: domain,
          path: '/',
        ),
      );
    }

    // Set user_type if available
    if (widget.userType != null && widget.userType!.isNotEmpty) {
      await cookieManager.setCookie(
        WebViewCookie(
          name: 'user_type',
          value: widget.userType!,
          domain: domain,
          path: '/',
        ),
      );
    }
  }

  void goToBack() async {
    if (await controller!.canGoBack()) {
      controller!.goBack();
    } else {
      Get.back();
    }
  }

  void onPageStarted(String url) {
    _hideNavbar();
  }

  void onProgress(int progress) {}

  void onPageFinished(String url) async {
    // print("runJavaScript script started document.querySelector('.fixed')?.style.display='none';");
    await controller!.runJavaScript(
        "document.querySelector('.fixed').style.display='none';"
    );
    // print("runJavaScript script ended document.querySelector('.fixed')?.style.display='none';");
  }

  void onWebResourceError(WebResourceError error) {
  }

  FutureOr<NavigationDecision> onNavigationRequest(NavigationRequest request) {
    if (request.url.startsWith('https://www.youtube.com/')) {
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  void sendMessageToWebView() async {
    // await controller.('receiveMessage("$message")');
    await controller!.runJavaScript(
      """bc.postMessage("The message sent from mobile");""",
    );
  }

  /// Enable WebSocket support in the WebView
  void _enableWebSockets() async {
    if (controller == null) return;

    // Add listener for WebSocket close events
    await controller!.runJavaScript('''
      // Monitor WebSocket connections
      (function() {
        // Override the WebSocket constructor
        const originalWebSocket = window.WebSocket;
        window.WebSocket = function(url, protocols) {
          console.log('WebSocket connecting to: ' + url);
          const ws = protocols ? new originalWebSocket(url, protocols) : new originalWebSocket(url);
          
          // Add event listeners
          ws.addEventListener('open', function(event) {
            console.log('WebSocket connected successfully');
            if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.websocket_channel) {
              window.webkit.messageHandlers.websocket_channel.postMessage('connected');
            } else if (window.websocket_channel) {
              websocket_channel.postMessage('connected');
            }
          });
          
          ws.addEventListener('close', function(event) {
            console.log('WebSocket closed', event);
            if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.websocket_channel) {
              window.webkit.messageHandlers.websocket_channel.postMessage('closed: ' + event.code);
            } else if (window.websocket_channel) {
              websocket_channel.postMessage('closed: ' + event.code);
            }
          });
          
          ws.addEventListener('error', function(event) {
            console.log('WebSocket error', event);
            if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.websocket_channel) {
              window.webkit.messageHandlers.websocket_channel.postMessage('error');
            } else if (window.websocket_channel) {
              websocket_channel.postMessage('error');
            }
          });
          
          return ws;
        };
      })();
    ''');
  }

  /// Hide button navigation bar in the WebView
  void _hideNavbar() async {
    if (controller == null) return;

    // prin
    // Add listener for WebSocket close events
    await controller!.runJavaScript('''
      document.querySelector(".fixed").style.display='none'
    ''');
  }

  /// Handle WebSocket reconnection when connection is lost
  void _handleWebSocketReconnect() async {
    if (controller == null) return;


    // Try to reconnect by reloading the page
    // This is a simple approach - you might want a more sophisticated reconnection strategy
    await controller!.reload();
  }
}

// Hello I am Tamim