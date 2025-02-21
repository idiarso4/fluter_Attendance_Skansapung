import 'package:flutter/foundation.dart';

class LoggingService {
  static void logError(dynamic error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('Error: $error');
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      }
    }
    // TODO: Implement production logging (e.g., Firebase Crashlytics, Sentry)
  }

  static void logInfo(String message) {
    if (kDebugMode) {
      print('Info: $message');
    }
    // TODO: Implement production logging
  }

  static void logWarning(String message) {
    if (kDebugMode) {
      print('Warning: $message');
    }
    // TODO: Implement production logging
  }
}