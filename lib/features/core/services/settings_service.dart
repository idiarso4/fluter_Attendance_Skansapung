import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Settings keys
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyAttendanceReminderTime = 'attendance_reminder_time';
  static const String _keyFaceDetectionSensitivity = 'face_detection_sensitivity';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyLanguage = 'language';

  factory SettingsService() {
    return _instance;
  }

  SettingsService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  // Notification Settings
  Future<bool> getNotificationsEnabled() async {
    await _ensureInitialized();
    return _prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _ensureInitialized();
    await _prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  Future<String?> getAttendanceReminderTime() async {
    await _ensureInitialized();
    return _prefs.getString(_keyAttendanceReminderTime);
  }

  Future<void> setAttendanceReminderTime(String time) async {
    await _ensureInitialized();
    await _prefs.setString(_keyAttendanceReminderTime, time);
  }

  // Face Detection Settings
  Future<double> getFaceDetectionSensitivity() async {
    await _ensureInitialized();
    return _prefs.getDouble(_keyFaceDetectionSensitivity) ?? 0.7;
  }

  Future<void> setFaceDetectionSensitivity(double sensitivity) async {
    await _ensureInitialized();
    await _prefs.setDouble(_keyFaceDetectionSensitivity, sensitivity);
  }

  // App Theme Settings
  Future<bool> getDarkMode() async {
    await _ensureInitialized();
    return _prefs.getBool(_keyDarkMode) ?? false;
  }

  Future<void> setDarkMode(bool enabled) async {
    await _ensureInitialized();
    await _prefs.setBool(_keyDarkMode, enabled);
  }

  // Language Settings
  Future<String> getLanguage() async {
    await _ensureInitialized();
    return _prefs.getString(_keyLanguage) ?? 'en';
  }

  Future<void> setLanguage(String languageCode) async {
    await _ensureInitialized();
    await _prefs.setString(_keyLanguage, languageCode);
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }

  Future<void> clearSettings() async {
    await _ensureInitialized();
    await _prefs.clear();
  }
}