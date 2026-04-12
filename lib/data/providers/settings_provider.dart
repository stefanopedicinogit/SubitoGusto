import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Settings state
class AppSettings {
  final bool orderNotifications;
  final bool soundAlerts;
  final bool vibration;
  final String theme; // 'light', 'dark', 'system'
  final bool autoConfirmOrders;
  final int notificationSoundIndex;

  const AppSettings({
    this.orderNotifications = true,
    this.soundAlerts = true,
    this.vibration = true,
    this.theme = 'light',
    this.autoConfirmOrders = false,
    this.notificationSoundIndex = 0,
  });

  AppSettings copyWith({
    bool? orderNotifications,
    bool? soundAlerts,
    bool? vibration,
    String? theme,
    bool? autoConfirmOrders,
    int? notificationSoundIndex,
  }) {
    return AppSettings(
      orderNotifications: orderNotifications ?? this.orderNotifications,
      soundAlerts: soundAlerts ?? this.soundAlerts,
      vibration: vibration ?? this.vibration,
      theme: theme ?? this.theme,
      autoConfirmOrders: autoConfirmOrders ?? this.autoConfirmOrders,
      notificationSoundIndex: notificationSoundIndex ?? this.notificationSoundIndex,
    );
  }
}

/// Settings notifier
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppSettings(
      orderNotifications: prefs.getBool('orderNotifications') ?? true,
      soundAlerts: prefs.getBool('soundAlerts') ?? true,
      vibration: prefs.getBool('vibration') ?? true,
      theme: prefs.getString('theme') ?? 'light',
      autoConfirmOrders: prefs.getBool('autoConfirmOrders') ?? false,
      notificationSoundIndex: prefs.getInt('notificationSoundIndex') ?? 0,
    );
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('orderNotifications', state.orderNotifications);
    await prefs.setBool('soundAlerts', state.soundAlerts);
    await prefs.setBool('vibration', state.vibration);
    await prefs.setString('theme', state.theme);
    await prefs.setBool('autoConfirmOrders', state.autoConfirmOrders);
    await prefs.setInt('notificationSoundIndex', state.notificationSoundIndex);
  }

  void setOrderNotifications(bool value) {
    state = state.copyWith(orderNotifications: value);
    _saveSettings();
  }

  void setSoundAlerts(bool value) {
    state = state.copyWith(soundAlerts: value);
    _saveSettings();
  }

  void setVibration(bool value) {
    state = state.copyWith(vibration: value);
    _saveSettings();
  }

  void setTheme(String value) {
    state = state.copyWith(theme: value);
    _saveSettings();
  }

  void setAutoConfirmOrders(bool value) {
    state = state.copyWith(autoConfirmOrders: value);
    _saveSettings();
  }

  void setNotificationSoundIndex(int value) {
    state = state.copyWith(notificationSoundIndex: value);
    _saveSettings();
  }
}

/// Settings provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});
