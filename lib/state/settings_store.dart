import 'package:shared_preferences/shared_preferences.dart';

/// Giá trị cài đặt được lưu lại giữa các lần mở app.
class SettingsData {
  final String languageCode;
  final bool isDark;

  const SettingsData({this.languageCode = 'vi', this.isDark = false});
}

/// Đọc/ghi cài đặt bằng `shared_preferences`.
///
/// Mọi lỗi plugin (ví dụ khi chạy unit test không có platform channel) đều
/// được bỏ qua để app vẫn chạy với giá trị mặc định.
class SettingsStore {
  SettingsStore._();

  static const String _languageKey = 'settings.language';
  static const String _darkKey = 'settings.dark';

  static Future<SettingsData> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final language = prefs.getString(_languageKey);
      return SettingsData(
        languageCode: language == 'en' ? 'en' : 'vi',
        isDark: prefs.getBool(_darkKey) ?? false,
      );
    } catch (_) {
      return const SettingsData();
    }
  }

  static Future<void> saveLanguage(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
    } catch (_) {
      // Bỏ qua: cài đặt vẫn có hiệu lực trong phiên hiện tại.
    }
  }

  static Future<void> saveDarkMode(bool isDark) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkKey, isDark);
    } catch (_) {
      // Bỏ qua: cài đặt vẫn có hiệu lực trong phiên hiện tại.
    }
  }
}
