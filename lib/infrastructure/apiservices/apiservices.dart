import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:mobilr_app_ui/core/cloudurl.dart';
import 'package:mobilr_app_ui/domain/authdata/authrequestmodel.dart';
import 'package:mobilr_app_ui/infrastructure/supporting_functions/token_supporting_functions.dart';

class APIservices {
  final Dio dio = Dio();
  Future<Response> logIN(
    AuthRequestModel authrequestmodel,
    String endpoint,
  ) async {
    final baseurl = 'https://$CLOUD$PATH$endpoint';
    log("LOGIN URL: $baseurl");
    log("LOGIN PAYLOAD: ${authrequestmodel.toJson()}");

    try {
      final response = await dio.post(
        baseurl,
        data: authrequestmodel.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
          },
        ),
      );

      log('LOGIN RESPONSE: ${response.data}');
      return response;
    } on DioException catch (dioErr) {
      log("DIO ERROR TYPE: ${dioErr.type}");
      log("DIO MESSAGE: ${dioErr.message}");
      log("STATUS CODE: ${dioErr.response?.statusCode}");
      log("ERROR RESPONSE: ${dioErr.response?.data}");

      throw dioErr;
    } catch (e, s) {
      log("UNEXPECTED ERROR: $e");
      log("STACKTRACE: $s");
      rethrow;
    }
  }

  // all api calls - post and get
  Future<Response?> apipost({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      final baseurl = 'https://$CLOUD$PATH$endpoint';
      log(baseurl);
      log('api - post ');
      String? token = await TokenStorage.getToken();
      Response response = await dio.post(
        baseurl,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json', 'Cookie': '$token'},
        ),
      );
      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE DATA: ${response.data.toString()}");
      return response;
    } catch (e) {
      log('Error occurred in API POST : $e');
    }
    return null;
  }

  Future<Response?> apiget({
    required String endpoint,
    bool isReport = false,
    Map<String, dynamic>? queryParameters,
    options,
  }) async {
    try {
      final baseurl = 'https://$CLOUD$PATH$endpoint';
      log(baseurl);
      log('api - get ');
      String? token = await TokenStorage.getToken();
      log(token.toString());
      Response response = await dio.get(
        baseurl,
        queryParameters: queryParameters,

        options: Options(
          headers: {'Content-Type': 'application/json', 'Cookie': '$token'},
          responseType: isReport ? ResponseType.bytes : null,
        ),
      );
      log("STATUS CODE: ${response.statusCode}");
      log("RESPONSE DATA: ${response.data.toString()}");
      return response;
    } catch (e) {
      log('Error occurred in API GET : $e');
      return null;
    }
  }
}
