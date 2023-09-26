import 'app_update_model.dart';

class RemoteConfigModel {
  final bool isSocialLogin;
  final bool isManualLogin;
  final List<dynamic> socialLogins;
  final AppUpdateModel updateModel;

  RemoteConfigModel(
    this.isSocialLogin,
    this.isManualLogin,
    this.socialLogins,
    this.updateModel,
  );

  RemoteConfigModel.fromJson(Map<dynamic, dynamic> json, AppUpdateModel model)
      : isSocialLogin = json['isSocialLogin'] as bool,
        isManualLogin = json['isManualLogin'] as bool,
        updateModel = model,
        socialLogins = json['socialLogins'] as List<dynamic>;

  Map<dynamic, dynamic> toJson() => {
        'isSocialLogin': isSocialLogin,
        'isManualLogin': isManualLogin,
        'socialLogins': socialLogins,
      };
}
