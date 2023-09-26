// all providers should initialized here..
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/notification/notification_bloc.dart';
import '../blocs/remote_config/remote_config_bloc.dart';
import '../blocs/search_user/search_user_bloc.dart';
import '../blocs/user_detail/user_detail_bloc.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/graphql/graphql_bloc.dart';
import '../blocs/user/user_bloc.dart';

final providers = [
  BlocProvider<AuthenticationBloc>(
    create: (BuildContext context) => AuthenticationBloc(),
  ),
  BlocProvider<RemoteConfigBloc>(
    create: (BuildContext context) => RemoteConfigBloc(),
  ),
  BlocProvider<UserBloc>(
    create: (BuildContext context) => UserBloc(),
  ),
  BlocProvider<SearchUserBloc>(
    create: (BuildContext context) => SearchUserBloc(),
  ),
  BlocProvider<GraphqlBloc>(
    create: (BuildContext context) => GraphqlBloc(),
  ),
  BlocProvider<NotificationBloc>(
    create: (BuildContext context) => NotificationBloc(),
  ),
  BlocProvider<UserDetailBloc>(
    create: (BuildContext context) => UserDetailBloc(),
  ),
];
