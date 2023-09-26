import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../models/app_update_model.dart';
import '../models/remote_config_model.dart';
import '../utilities/constants.dart';

class RemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  //returning login types
  Future<AppUpdateModel> getUpdateModel() async {
    try {
      Map<String, dynamic> userMap = jsonDecode(
        remoteConfig.getString(Constants.mobileUpdateVersion),
      ) as Map<String, dynamic>;
      print("Remote config response$userMap");
      var remoteConfigModel = AppUpdateModel.fromJson(userMap);
      return remoteConfigModel;
    } on Exception catch (e) {
      print("Firebase remote error$e");
      return AppUpdateModel(
        iosUrl: "",
        iosVersion: 1,
        androidVersion: 1,
        isForceUpdate: false,
        isNormalUpdate: false,
        androidUrl: "",
      );
    }
  }

  Future<RemoteConfigModel?> getLoginTypes() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await remoteConfig.fetchAndActivate();
      AppUpdateModel model = await getUpdateModel();
      Map<String, dynamic> remoteData = jsonDecode(
        remoteConfig.getString(Constants.loginTypes),
      ) as Map<String, dynamic>;
      return RemoteConfigModel.fromJson(remoteData, model);
    } on Exception catch (_) {
      return null;
    }
  }
}
