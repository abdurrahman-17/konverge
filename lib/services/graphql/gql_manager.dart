import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../core/locator.dart';
import '../../models/repo/error_model.dart';
import '../../utilities/enums.dart';
import '../../utilities/network_listener.dart';
import '../../utilities/title_string.dart';
import '../amplify/amplify_service.dart';

class GqlManager {
  static GraphQLClient? client;
  static String? accessToken;

  //the below graphql base url is the one with new db changes. old url='https://eu-west-1.aws.realm.mongodb.com/api/client/v2.0/app/application-0-dsszp/graphql'
  String graphQlBaseUrl = dotenv.env['GRAPHQL_BASE_URL']!;

  /*initial configuration of graphql client.
  * [idToken] represents the authentication token (jwt token) from -
  * amplify/aws cognito for authenticate user access.
  * */
  Future<GraphQLClient> configureGqlClient(String idToken) async {
    await initHiveForFlutter();
    final HttpLink httpLink = HttpLink(
      graphQlBaseUrl,
      defaultHeaders: {
        'jwtTokenString': idToken,
      },
    );
    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $idToken',
    );
    // final Link link =
    authLink.concat(httpLink);
    var client = GraphQLClient(
        link: httpLink,
        // The default store is the InMemoryStore, which does NOT persist to disk
        cache: GraphQLCache(store: HiveStore()));
    return client;
  }

  /*return valid graphql client, if valid client is not available new client configuration setup will run.*/
  Future<GraphQLClient?> getClient({bool refreshRequired = false}) async {
    if (refreshRequired) {
      client = null;
    }

    if (client != null) return client;
    String idToken = await Locator.instance<AmplifyService>().getRefreshToken();
    // getAccessToken();
    if (idToken.isNotEmpty) {
      client = await configureGqlClient(idToken);
      return client;
    } else {
      return null;
    }
  }

  /*return valid graphql client, if valid client is not available new client configuration setup will run.*/
  Future<String> getAccessToken2() async {
    String accessToken2 =
        await Locator.instance<AmplifyService>().getAccessToken();
    accessToken = accessToken2;
    return accessToken2;
  }

  //query execution
  Future<Either<ErrorModel, QueryResult>> executeQuery({
    required String query,
    Duration? pollInterval,
    FetchPolicy? fetchPolicy,
    Map<String, dynamic>? variables,
  }) async {
    try {
      ConnectionStatusSingleton connectivity =
          ConnectionStatusSingleton.instance;

      bool isConnected = await connectivity.checkConnectionStatus();
      if (!isConnected) {
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: TitleString.noInternetConnection,
          ),
        );
      }
      GraphQLClient? client = await getClient();
      if (client == null) {
        print("token expiredayath ivde anutoto");
        return Left(
          ErrorModel(
            type: ErrorType.normalWarning,
            message: "Authentication error while calling graphql client",
          ),
        );
      }
      QueryResult result = await client.query(
        QueryOptions(
          document: gql(query),
          pollInterval: pollInterval,
          fetchPolicy: fetchPolicy,
          variables: variables ?? const {},
        ),
      );

      if (result.hasException) {
        print("token expired");
        client = await getClient(refreshRequired: true);
        if (client == null) {
          return Left(
            ErrorModel(
              type: ErrorType.normalWarning,
              message: "Authentication error while calling graphql client.",
            ),
          );
        }
        print('solve ayi');
        result = await client.query(
          QueryOptions(
            document: gql(query),
            pollInterval: pollInterval,
            fetchPolicy: fetchPolicy,
            variables: variables ?? const {},
          ),
        );
      }
      print("object");
      return Right(result);
    } catch (e) {
      log("GQLManager:$e");
      log("Token expiryomma enikarilla $e");
      await Sentry.captureException(
        "GQLManager -> calling apply -> GraphqlErrorState $e",
      );
      return Left(
        ErrorModel(
          type: ErrorType.normalWarning,
          message: "Something went wrong",
        ),
      );
    }
  }
}
