import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utilities/constants.dart';

class AuthenticationService {
  AuthenticationService();

//email and password saving to local storage for local auth
  void saveUserCredToLocal({
    required String email,
    required String password,
  }) async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    await storage.write(key: Constants.email, value: email);
    await storage.write(key: Constants.password, value: password);
    await storage.write(key: Constants.isLocalAuth, value: "true");
  }

//fetching email and password from local storage
  Future<Map<String, String>> getUserCredFromLocal() async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    return await storage.readAll();
  }
}
