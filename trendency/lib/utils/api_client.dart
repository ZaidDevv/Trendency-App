import 'dart:convert';
import 'dart:core';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late Dio _dio;
  final BaseOptions options = BaseOptions(
    baseUrl: dotenv.env['BASE_URL'] ?? "http://192.168.0.122:4080",
    connectTimeout: 15000,
    receiveTimeout: 13000,
  );
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() => _instance;

  ApiClient._internal() {
    var cookieJar = CookieJar();
    _dio = Dio(options);
    _dio.interceptors.add(CookieManager(cookieJar));

    _dio.interceptors
        .add(InterceptorsWrapper(onError: (refreshTokenInterceptor)));
  }

  Future<void> refreshTokenInterceptor(
      DioError error, ErrorInterceptorHandler handler) async {
    print(error.message);
    try {
      if (error.response!.statusCode == 401) {
        String? refreshToken =
            await const FlutterSecureStorage().read(key: "refreshToken");
        var response = await _dio.post("/api/user/auth/refresh_token",
            data: jsonEncode(<String, String>{
              'refreshToken': refreshToken!,
            }));
        if (response.statusCode == 200) {
          print(response.data);
          await persistAuthCredentials(
              response.data["accessToken"], response.data["refreshToken"]);
          options.headers["authorization"] = response.data["accessToken"];
          handler.resolve(response);
        }
      }
    } on DioError catch (error) {
      handler.reject(error);
    }
  }

  Future<String?> getAuthenticationHeader() async {
    var storage = const FlutterSecureStorage();
    final String? token = await storage.read(key: "accessToken");
    return token;
  }

  Future<Response> get(
      {required String endpoint,
      required bool withAuth,
      Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await _dio.get(endpoint,
          queryParameters: queryParams,
          options: Options(headers: {
            "authorization":
                withAuth ? "Bearer ${await getAuthenticationHeader()}" : "",
          }));
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e.response);
      throw e;
    }
  }

  Future<Response> post(
      {required String endpoint,
      required bool withAuth,
      Map<String, dynamic>? body,
      Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await _dio.post(endpoint,
          data: body,
          queryParameters: queryParams,
          options: Options(headers: {
            "authorization":
                withAuth ? "Bearer ${await getAuthenticationHeader()}" : "",
          }));
      return response;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<void> persistAuthCredentials(
      String accessToken, String refreshToken) async {
    const storage = FlutterSecureStorage();

    await storage.write(key: "refreshToken", value: refreshToken);
    await storage.write(key: "accessToken", value: accessToken);
  }
}
