import 'package:dartz/dartz.dart';
import '../blocs/graphql/graphql_event.dart';
import '../blocs/user_detail/user_detail_bloc.dart';
import '../core/configurations.dart';
import '../core/locator.dart';
import '../main.dart';
import '../models/graphql/user_info.dart';
import '../services/graphql/qql_service.dart';

import '../blocs/graphql/graphql_bloc.dart';
import '../blocs/user/user_bloc.dart';
import '../models/graphql/user.dart';
import '../models/repo/error_model.dart';

class UserRepo {
  Future<Either<ErrorModel, User>> saveUserData(
          Map<String, dynamic> userJson) async =>
      await Locator.instance.get<GraphqlService>().saveUserData(userJson);

  UserInfoModel? getCurrentUserData() {
    return BlocProvider.of<GraphqlBloc>(globalNavigatorKey.currentContext!)
        .currentUser;
  }

  void setCurrentUserData(UserInfoModel? user) {
    BlocProvider.of<GraphqlBloc>(globalNavigatorKey.currentContext!)
        .currentUser = user;
    BlocProvider.of<UserBloc>(globalNavigatorKey.currentContext!).add(
      UserInitialEvent(),
    );
    BlocProvider.of<UserDetailBloc>(globalNavigatorKey.currentContext!).add(
      UserDetailInitialEvent(),
    );
    BlocProvider.of<GraphqlBloc>(globalNavigatorKey.currentContext!).add(
      GraphqlInitialEvent(),
    );
  }

  Future<Either<ErrorModel, bool>> deleteUserAccount(String userId) async {
    return await Locator.instance
        .get<GraphqlService>()
        .deleteUserAccount(userId);
  }
}
