import '../../utilities/enums.dart';

class ErrorModel {
  String message;
  ErrorType type;
  ErrorModel({
    required this.type,
    required this.message,
  });
}
