
import 'package:shared_preferences/shared_preferences.dart';


class SharedPrefManger {
  SharedPreferences sharedPreferences;
  SharedPrefManger({required this.sharedPreferences});


  // COMMON KEYS
  static const String onboardingOn = 'onboardingOn';
  static const String token = 'token';






  // FOR STRING
  putString(String key,String value) => sharedPreferences.setString(key, value);
  getString(String key) => sharedPreferences.getString(key);

  // FOR BOOLEAN
  putBool(String key,bool value) => sharedPreferences.setBool(key, value);
  getBool(String key) => sharedPreferences.getBool(key) ?? false;

  // FOR INT
  putInt(String key,int value) => sharedPreferences.setInt(key, value);
  getInt(String key) => sharedPreferences.getInt(key) ?? 0;

  // FOR DOUBLE
  putDouble(String key,double value) => sharedPreferences.setDouble(key, value);
  getDouble(String key) => sharedPreferences.getDouble(key) ?? 0.0;

}