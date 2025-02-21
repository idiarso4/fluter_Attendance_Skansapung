import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settingsService = SettingsService();
  final _notificationService = NotificationService();
  
  bool _notificationsEnabled = true;
  String? _reminderTime;
  double _faceDetectionSensitivity = 0.7;
  bool _darkMode = false;
  String _language = 'en';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final notificationsEnabled = await _settingsService.getNotificationsEnabled();
    final reminderTime = await _settingsService.getAttendanceReminderTime();
    final sensitivity = await _settingsService.getFaceDetectionSensitivity();
    final darkMode = await _settingsService.getDarkMode();
    final language = await _settingsService.getLanguage();

    setState(() {
      _notificationsEnabled = notificationsEnabled;
      _reminderTime = reminderTime;
      _faceDetectionSensitivity = sensitivity;
      _darkMode = darkMode;
      _language = language;
    });
  }

  Future<void> _updateNotifications(bool value) async {
    await _settingsService.setNotificationsEnabled(value);
    if (!value) {
      await _notificationService.cancelAllNotifications();
    }
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _updateReminderTime(TimeOfDay? time) async {
    if (time == null) return;
    
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await _settingsService.setAttendanceReminderTime(
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
    );
    
    if (_notificationsEnabled) {
      await _notificationService.scheduleAttendanceReminder(scheduledTime);
    }

    setState(() {
      _reminderTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Enable attendance reminders'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: _updateNotifications,
            ),
          ),
          if (_notificationsEnabled)
            ListTile(
              title: const Text('Reminder Time'),
              subtitle: Text(_reminderTime ?? 'Not set'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _reminderTime != null
                      ? TimeOfDay(
                          hour: int.parse(_reminderTime!.split(':')[0]),
                          minute: int.parse(_reminderTime!.split(':')[1]),
                        )
                      : TimeOfDay.now(),
                );
                await _updateReminderTime(time);
              },
            ),
          ListTile(
            title: const Text('Face Detection Sensitivity'),
            subtitle: Slider(
              value: _faceDetectionSensitivity,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              label: _faceDetectionSensitivity.toStringAsFixed(1),
              onChanged: (value) async {
                await _settingsService.setFaceDetectionSensitivity(value);
                setState(() {
                  _faceDetectionSensitivity = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: _darkMode,
              onChanged: (value) async {
                await _settingsService.setDarkMode(value);
                setState(() {
                  _darkMode = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_language == 'en' ? 'English' : 'Bahasa Indonesia'),
            trailing: DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'id', child: Text('Bahasa Indonesia')),
              ],
              onChanged: (value) async {
                if (value != null) {
                  await _settingsService.setLanguage(value);
                  setState(() {
                    _language = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}