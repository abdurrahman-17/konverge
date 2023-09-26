// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/questionnaire/match_response.dart';

import '../../models/questionnaire/questionnaire.dart';
import '../api_requests/api_manager.dart';
import '../../utilities/constants.dart';
import '../../utilities/enums.dart';
import '../../utilities/title_string.dart';
import '../../view/common_widgets/common_dialogs.dart';

class ApiService {
  APIManager apiManager = APIManager();

  int getActualValue(int percentage) {
    if (percentage < 50) {
      return 100 - percentage;
    } else if (percentage > 50) {
      return percentage;
    }
    return 50;
  }

  Future<MatchResponse?> submitQuestionnaireData(
      {required List<Questionnaire> questions, required String userId
      // required String templateId,
      // required List<TemplateQuestions> questions,
      }) async {
    try {
      List<dynamic> questionnaires = [];
      for (int i = 0; i < questions.length; i++) {
        Map<String, dynamic> questionnaire = <String, dynamic>{};
        questionnaire["question_id"] = '${questions[i].id}';
        questionnaire["percentage"] = getActualValue(questions[i].percentage);

        if (questions[i].code.isEmpty) {
          questions[i].code = questions[i].agree?.code ?? "N";
        }
        questionnaire["code"] = questions[i].code;
        questionnaires.add(questionnaire);
      }
      print("questionnaires $questionnaires");
      Map<String, dynamic> body = {
        'user_id': userId,
        'questionnaires': questionnaires,
      };
      // final query = QueriesConst().updateQuestionnaire();
      // Map<String, dynamic> body = {
      //   // 'query':query,
      // };
      log("variables $body");

      //body['query'] = query;
      // body["variables"] = variables.toString();

      final jsonResponse = await APIManager().makeDioApiCall(
        Constants.saveScoreUrl,
        apiCallType: ApiCallType.post,
        body: body,
      );

      log("jsonResponse $jsonResponse");
      if (jsonResponse is dio.Response) {
        if (jsonResponse.statusCode == 200) {
          try {
            MatchResponse response = MatchResponse.fromJson(
                jsonResponse.data as Map<String, dynamic>);
            return response;
          } catch (e) {
            log("response $e");
            await showInfo(
              globalNavigatorKey.currentContext!,
              title: "Alert",
              content: "$e",
              buttonLabel: TitleString.btnOkay,
              onTap: () {
                Navigator.pop(globalNavigatorKey.currentContext!);
              },
            );
            await showInfo(
              globalNavigatorKey.currentContext!,
              title: "Alert",
              content: jsonResponse.statusMessage ?? "",
              buttonLabel: TitleString.btnOkay,
              onTap: () {
                Navigator.pop(globalNavigatorKey.currentContext!);
              },
            );
            return null;
          }
        }
        return null;
      }
      if (jsonResponse != null &&
          jsonResponse == TitleString.noInternetConnection) {
        return null;
      }
      await showInfo(
        globalNavigatorKey.currentContext!,
        title: "Alert",
        content: "Error occurred",
        buttonLabel: TitleString.btnOkay,
        onTap: () {
          Navigator.pop(globalNavigatorKey.currentContext!);
        },
      );
      return null;
    } catch (e) {
      print("jsonResponse$e");
      await showInfo(
        globalNavigatorKey.currentContext!,
        title: "Alert",
        content: "$e",
        buttonLabel: TitleString.btnOkay,
        onTap: () {
          Navigator.pop(globalNavigatorKey.currentContext!);
        },
      );
      return null;
    }
  }

  Future<String?> uploadProfilePic(
      {required File file,
      required String fileName,
      required int fileSize,
      required String userId}) async {
    try {
      List data = await _getUploadUrl(
        fileName: fileName,
        fileSize: fileSize,
        userId: userId,
      );
      if (data[0] == null) {
        return null;
      }

      final isSuccess = await APIManager().uploadFileApi(
        apiUrl: data[0],
        file: file,
      );

      if (isSuccess) {
        log("${data[1]}");
        return "${data[1]}";
      }
      return null;
    } catch (e) {
      print("jsonResponse$e");
      return null;
    }
  }

  Future<List> _getUploadUrl(
      {required String fileName,
      required int fileSize,
      required String userId}) async {
    try {
      Map<String, dynamic> body = {
        "file_name": fileName,
        "file_size": fileSize,
        "user_id": userId
      };

      log("body $body");

      final jsonResponse = await APIManager().makeDioApiCall(
        Constants.uploadPicUrl,
        apiCallType: ApiCallType.post,
        body: body,
      );

      log("image url:  ${Constants.uploadPicUrl}");
      log("jsonResponse$jsonResponse");
      if (jsonResponse is dio.Response) {
        if (jsonResponse.statusCode == 200) {
          try {
            return [
              jsonResponse.data['upload_url'],
              jsonResponse.data['file_path'],
            ];
          } catch (e) {
            log("response $e");
            await showInfo(
              globalNavigatorKey.currentContext!,
              title: "Alert",
              content: jsonResponse.statusMessage ?? "",
              buttonLabel: TitleString.btnOkay,
              onTap: () {
                Navigator.pop(globalNavigatorKey.currentContext!);
              },
            );
            return [null, null];
          }
        }
        return [null, null];
      }
      if (jsonResponse != null &&
          jsonResponse == TitleString.noInternetConnection) {
        return [null, null];
      }
      await showInfo(
        globalNavigatorKey.currentContext!,
        title: "Alert",
        content: "Error occurred",
        buttonLabel: TitleString.btnOkay,
        onTap: () {
          Navigator.pop(globalNavigatorKey.currentContext!);
        },
      );
      return [null, null];
    } catch (e) {
      print("jsonResponse$e");
      await showInfo(
        globalNavigatorKey.currentContext!,
        title: "Alert",
        content: "$e",
        buttonLabel: TitleString.btnOkay,
        onTap: () {
          Navigator.pop(globalNavigatorKey.currentContext!);
        },
      );
      return [null, null];
    }
  }

  Future<bool> checkEmailExists({required String email}) async {
    try {
      Map<String, dynamic> body = {
        "email": email,
      };

      log("body $body");
      print("url ${Constants.checkEmailUrl}");
      final jsonResponse = await APIManager().makeDioApiCall(
          Constants.checkEmailUrl,
          apiCallType: ApiCallType.post,
          body: body,
          headerNeeded: false);

      log("jsonResponse$jsonResponse");
      if (jsonResponse is dio.Response) {
        if (jsonResponse.statusCode == 200) {
          try {
            bool status = jsonResponse.data['data']['status'] as bool;
            if (status) {
            } else {
              showInfo(
                globalNavigatorKey.currentContext!,
                title: "Alert",
                content: jsonResponse.data['data']['message'] ?? "",
                buttonLabel: TitleString.btnOkay,
                onTap: () {
                  Navigator.pop(globalNavigatorKey.currentContext!);
                },
              );
            }
            return status;
          } catch (e) {
            log("response $e");
            await showInfo(
              globalNavigatorKey.currentContext!,
              title: "Alert",
              content: jsonResponse.statusMessage ?? "",
              buttonLabel: TitleString.btnOkay,
              onTap: () {
                Navigator.pop(globalNavigatorKey.currentContext!);
              },
            );
            return false;
          }
        }
        return false;
      }
      if (jsonResponse != null &&
          jsonResponse == TitleString.noInternetConnection) {
        return false;
      }
      await showInfo(
        globalNavigatorKey.currentContext!,
        title: "Alert",
        content: "Error occurred",
        buttonLabel: TitleString.btnOkay,
        onTap: () {
          Navigator.pop(globalNavigatorKey.currentContext!);
        },
      );
      return false;
    } catch (e) {
      print("jsonResponse$e");
      await showInfo(
        globalNavigatorKey.currentContext!,
        title: "Alert",
        content: "$e",
        buttonLabel: TitleString.btnOkay,
        onTap: () {
          Navigator.pop(globalNavigatorKey.currentContext!);
        },
      );
      return false;
    }
  }

  Future<bool> checkPhoneNumberExists({required String phoneNumber}) async {
    try {
      Map<String, dynamic> body = {
        "phonenumber": phoneNumber,
      };

      log("body $body");
      print("url ${Constants.checkPhoneNumberExistsUrl}");
      final jsonResponse = await APIManager().makeDioApiCall(
          Constants.checkPhoneNumberExistsUrl,
          apiCallType: ApiCallType.post,
          body: body,
          headerNeeded: false);

      log("jsonResponse$jsonResponse");
      if (jsonResponse is dio.Response) {
        if (jsonResponse.statusCode == 200) {
          try {
            bool status = jsonResponse.data['data']['status'] as bool;
            if (status) {
            } else {
              showInfo(
                globalNavigatorKey.currentContext!,
                title: "Alert",
                content: jsonResponse.data['data']['message'] ?? "",
                buttonLabel: TitleString.btnOkay,
                onTap: () {
                  Navigator.pop(globalNavigatorKey.currentContext!);
                },
              );
            }
            return status;
          } catch (e) {
            log("response $e");
            await showInfo(
              globalNavigatorKey.currentContext!,
              title: "Alert",
              content: jsonResponse.statusMessage ?? "",
              buttonLabel: TitleString.btnOkay,
              onTap: () {
                Navigator.pop(globalNavigatorKey.currentContext!);
              },
            );
            return false;
          }
        }
        return false;
      }
      if (jsonResponse != null &&
          jsonResponse == TitleString.noInternetConnection) {
        return false;
      }
      await showInfo(
        globalNavigatorKey.currentContext!,
        title: "Alert",
        content: "Error occurred",
        buttonLabel: TitleString.btnOkay,
        onTap: () {
          Navigator.pop(globalNavigatorKey.currentContext!);
        },
      );
      return false;
    } catch (e) {
      print("jsonResponse$e");
      await showInfo(
        globalNavigatorKey.currentContext!,
        title: "Alert",
        content: "$e",
        buttonLabel: TitleString.btnOkay,
        onTap: () {
          Navigator.pop(globalNavigatorKey.currentContext!);
        },
      );
      return false;
    }
  }
}
