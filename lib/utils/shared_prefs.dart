import 'package:shared_preferences/shared_preferences.dart';

const bool defaultIsFirstLogin = true;

class AppCache {
  static const String kIsFirstLogin = 'isFirstLogin';

  Future<void> cacheisFirstLogin(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kIsFirstLogin, value);
  }

  Future<bool> getIsFirstLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kIsFirstLogin) ?? defaultIsFirstLogin;
  }
}
