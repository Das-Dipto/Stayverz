import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/messaging/data/models/websocket_models.dart';
import 'package:stayverz_flutter_app/features/messaging/data/services/websocket_service.dart';

void main() {
  late WebSocketService webSocketService;
  
  setUp(() {
    webSocketService = WebSocketService();
    Get.put<WebSocketService>(webSocketService);
  });

  tearDown(() async {
    await webSocketService.disconnect();
    await Get.delete<WebSocketService>();
  });

  test('WebSocketService initializes with correct status', () async {
    // Verify initial status
    expect(webSocketService.connectionStatus, WebSocketStatus.disconnected);
    
    // Initialize with a test token
    await webSocketService.initialize('test_token');
    
    // Verify connection status changes to connecting
    expect(webSocketService.connectionStatus, WebSocketStatus.connecting);
  });

  test('WebSocketService can send messages when connected', () {
    // This is a simple test to verify the method exists and can be called
    // In a real test, we would mock the WebSocket connection
    expect(
      () => webSocketService.sendMessage(
        message: {'type': 'test', 'content': 'Hello'},
        conversationId: 'test_conv',
      ),
      returnsNormally,
    );
  });

  test('WebSocketService can be disconnected', () async {
    // Initialize with a test token
    await webSocketService.initialize('test_token');
    
    // Test disconnection
    await webSocketService.disconnect();
    
    // Verify connection status is disconnected
    expect(webSocketService.connectionStatus, WebSocketStatus.disconnected);
  });
}
