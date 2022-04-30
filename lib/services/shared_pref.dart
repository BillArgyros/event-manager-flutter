import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  Future<void> saveNamedPreference(Map obj, key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String rawJson = jsonEncode(obj);
    prefs.setString(key, rawJson);
  }

  Future<Map> getNamedPreference(keys) async {
    Map events = {};
    String key = keys;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.remove(keys);
    String? rawJSON = prefs.getString(key);
    if (rawJSON == null) {
      return events;
    } else {
      Map events = jsonDecode(rawJSON);
      return events;
    }
  }
}
