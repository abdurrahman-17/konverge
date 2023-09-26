import 'package:get_it/get_it.dart';
import '../../repository/amplify_repo.dart';
import '../../repository/graphql_repo.dart';
import '../../services/amplify/amplify_service.dart';
import '../../services/api_requests/api_service.dart';

import '../repository/user_repository.dart';
import '../services/authentication_service.dart';
import '../services/graphql/qql_service.dart';
import '../services/remote_config_service.dart';
import '../services/shared_preference_service.dart';

class Locator {
  static GetIt _i = GetIt.instance;
  static GetIt get instance => _i;

  Locator.setup() {
    _i = GetIt.I;
    _i.registerSingleton<SharedPrefServices>(SharedPrefServices());
    _i.registerSingleton<RemoteConfigService>(RemoteConfigService());
    _i.registerSingleton<AuthenticationService>(AuthenticationService());
    _i.registerSingleton<ApiService>(ApiService());

    _i.registerSingleton<GraphqlService>(GraphqlService());
    _i.registerSingleton<AmplifyService>(AmplifyService());
    //repositories
    _i.registerSingleton<GraphqlRepo>(GraphqlRepo());
    _i.registerSingleton<AmplifyRepo>(AmplifyRepo());
    _i.registerSingleton<UserRepo>(UserRepo());
  }
}
