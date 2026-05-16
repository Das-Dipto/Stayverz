import 'package:get/get.dart';
import 'package:logger/logger.dart';

class LoggerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Logger>(
      () => Logger(
        printer: PrettyPrinter(
          methodCount: 1, // Number of method calls to be shown
          errorMethodCount: 5, // Number of method calls if stacktrace is provided
          lineLength: 100, // Width of the output
          colors: true, // Colorful log messages
          printEmojis: true, // Print an emoji for each log message
          printTime: false, // Should each log print contain a timestamp
        ),
      ),
    );
  }
}

// Hello I am Tamim