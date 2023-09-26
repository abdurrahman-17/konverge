import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import '../../utilities/network_listener.dart';
import '../../utilities/title_string.dart';
import '../amplify/amplify_service.dart';
import '../../utilities/enums.dart';

class APIManager {
  //dio api call
  Future<dynamic> makeDioApiCall(
    String apiUrl, {
    ApiCallType apiCallType = ApiCallType.get,
    dynamic body,
    bool headerNeeded = true,
  }) async {
    try {
      ConnectionStatusSingleton connectivity =
          ConnectionStatusSingleton.instance;

      bool isConnected = await connectivity.checkConnectionStatus();
      if (!isConnected) {
        return TitleString.noInternetConnection;
      }
      Map<String, String> headers = {};
      if (headerNeeded) {
        final value = await AmplifyService().getTokens();

        if (value != null) {
          log("header ${value.accessToken.raw}");
          final accessToken = value.accessToken.raw;
          headers = {'Authorization': 'Bearer $accessToken'};
        }
      }

      ///header print
      log('headers: $headers');
      var response;
      final dio = Dio();
      log("apiCallType:$apiCallType");
      switch (apiCallType) {
        case ApiCallType.get:
          response = await dio.get(
            apiUrl,
            options: Options(headers: headers),
          );
          break;
        case ApiCallType.put:
          response = await dio.put(
            apiUrl,
            options: Options(headers: headers),
            data: body,
          );
          break;
        case ApiCallType.post:
          response = await dio.post(
            apiUrl,
            options: Options(
              headers: headers,
              contentType: Headers.jsonContentType,
            ),
            data: jsonEncode(body),
          );
          break;
        case ApiCallType.patch:
          response = await dio.patch(
            apiUrl,
            options: Options(headers: headers),
            data: body,
          );
          break;
        case ApiCallType.delete:
          response = await dio.patch(
            apiUrl,
            options: Options(headers: headers),
            data: body,
          );
          break;
        default:
          return ("API method is not defined");
      }
      log("DioResponse:$response");
      return response;
    } on SocketException {
      log("SocketException");
      return (TitleString.noInternetConnection);
    } on DioException catch (e) {
      log("DioException:$e");
      return (e.response);
    } catch (e) {
      log("makeDioApiCallException:$e");
      return ("Bad response 👎");
    }
  }

//uploadFile file api
  Future<bool> uploadFileApi({required apiUrl, required File file}) async {
    try {
      Uint8List image = file.readAsBytesSync();

      Options options =
          Options(contentType: lookupMimeType(file.path), headers: {
        'Accept': "*/*",
        'Content-Length': image.length,
        'Connection': 'keep-alive',
        'User-Agent': 'ClinicPlush'
      });

      Response response = await Dio().put(
        apiUrl,
        data: Stream.fromIterable(image.map((e) => [e])),
        options: options,
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      log("uploadFileApiException:$e");
      return false;
    }
  }
}
