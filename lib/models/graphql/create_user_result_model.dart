import 'package:graphql_flutter/graphql_flutter.dart';

import '../../utilities/constants_gql.dart';

class CreateUserResultModel {
  Map<String, dynamic>? resultData;
  String? warningInfo;
  ConstantGql resultType;
  OperationException? error;

  CreateUserResultModel({
    required this.resultType,
    this.warningInfo,
    this.resultData,
    this.error,
  });
}
