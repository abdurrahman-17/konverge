import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/constants.dart';
import '../utilities/enums.dart';

class SharedPrefServices {
  static late SharedPreferences _sharedPreferences;

  //making sharedPreference synchronously
  static Future<void> initializeSharedPref() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void clearSharedPref() {
    _sharedPreferences.clear();
  }

  void setUserId(String id) =>
      _sharedPreferences.setString(Constants.userId, id);

  String getUserId() {
    return _sharedPreferences.getString(Constants.userId) ?? '';
  }

  String getUserName() =>
      _sharedPreferences.getString(Constants.userName) ?? "";

  void setUserName(String userName) =>
      _sharedPreferences.setString(Constants.userName, userName);

  bool getUserPremium() =>
      _sharedPreferences.getBool(Constants.premiumUser) ?? false;

  bool getChatPageStatus() =>
      _sharedPreferences.getBool(Constants.isChatPage) ?? false;

  bool getPremium() =>
      _sharedPreferences.getBool(Constants.premiumUser) ?? false;

  void setUserPremium(bool status) =>
      _sharedPreferences.setBool(Constants.premiumUser, status);

  void setChatPageStatus(bool isChat) =>
      _sharedPreferences.setBool(Constants.isChatPage, isChat);

  void setPremium(bool value) =>
      _sharedPreferences.setBool(Constants.premiumUser, value);

  //set login type
  void setLoginType(LoginType type) {
    _sharedPreferences.setString(Constants.loginType, type.name);
  }

  //get login type
  LoginType getLoginType() {
    final type = _sharedPreferences.getString(Constants.loginType) ??
        LoginType.usernameAndPassword.name;
    for (var element in LoginType.values) {
      if (type == element.name) {
        return element;
      }
    }
    return LoginType.usernameAndPassword;
  }

  ///setting login time is  to db
  void updateLoginToDb(bool value) {
    _sharedPreferences.setBool(Constants.updateLogin, value);
  }

  //check whether db is already updated or not
  bool isUpdatedLoginToDb() {
    return _sharedPreferences.getBool(Constants.updateLogin) ?? false;
  }

  int getMatchCardSwipeCount() =>
      _sharedPreferences.getInt(Constants.matchSwipeCount) ?? 0;

  void setMatchCardSwipeCount(int data) =>
      _sharedPreferences.setInt(Constants.matchSwipeCount, data);
}
