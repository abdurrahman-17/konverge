class AppUpdateModel {
  num? iosVersion;
  String? iosUrl;
  bool? isNormalUpdate;
  String? androidUrl;
  num? androidVersion;
  bool? isForceUpdate;

  AppUpdateModel({
    this.iosVersion,
    this.iosUrl,
    this.isNormalUpdate,
    this.androidUrl,
    this.androidVersion,
    this.isForceUpdate,
  });

  AppUpdateModel.fromJson(Map<String, dynamic> json) {
    iosVersion = json['ios_version'] as num;
    iosUrl = json['ios_url'] as String;
    isNormalUpdate = (json['isNormalUpdate'] ?? false) as bool;
    androidUrl = json['android_url'] as String;
    androidVersion = json['android_version'] as num;
    isForceUpdate = (json['isForceUpdate'] ?? false) as bool;
  }
}
