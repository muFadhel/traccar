import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static void setInitPage(pageNum) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('initScreen', pageNum);
  }

  static getInitPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('initScreen');
  }

  static void setUserData(data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(data));
  }

  static getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userData');
  }

  static clearAllPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static userIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('userData');
    if (data == null) {
      return false;
    } else {
      return true;
    }
  }
}
