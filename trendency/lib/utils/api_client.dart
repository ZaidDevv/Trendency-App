import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:http_interceptor/models/retry_policy.dart';
import 'package:trendency/utils/failure.dart';
import 'package:trendency/utils/interceptor/interceptor.dart';
import 'package:trendency/utils/interceptor/retry_policy.dart';

class ApiClient {
  Client? _client;

  ApiClient() {
    _client ??= InterceptedClient.build(
        interceptors: [AuthInterceptor()], client: Client());
  }

  Future<String?> getAuthenticationHeader() async {
    var storage = const FlutterSecureStorage();
    final String? token = await storage.read(key: "accessToken");
    return token;
  }

  Future<Response> post(endpoint, {bool withAuth = false, dynamic body}) async {
    var response =
        await _client!.post(Uri.parse("${dotenv.env['BASE_URL']!}${endpoint}"),
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader:
                  withAuth ? "Bearer ${await getAuthenticationHeader()}" : "",
            },
            body: body);

    print(response.body);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw HttpException("${response.body}");
    }
  }

  Future<Response> get(endpoint, {bool withAuth = false, dynamic body}) async {
    var cookie = await const FlutterSecureStorage().read(key: "user-cookie");
    var response = await _client!.get(
      Uri.parse("${dotenv.env['BASE_URL']!}${endpoint}"),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader:
            withAuth ? "Bearer ${await getAuthenticationHeader()}" : "",
        HttpHeaders.setCookieHeader: cookie!,
      },
    );

    _storeCookie(response);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw HttpException("${response.body}");
    }
  }

  Future<bool> refreshToken(String refreshToken) async {
    try {
      var resp = await post("/api/user/auth/refresh_token",
          withAuth: false,
          body: jsonEncode(<String, String>{
            'refreshToken': refreshToken,
          }));
      if (resp.statusCode == 200) {
        var data = jsonDecode(resp.body);
        print(data + "noway");
        await persistAuthCredentials(data["accessToken"], data["refreshToken"]);
        return true;
      }
    } catch (e) {
      throw Failure(e.toString());
    }
    return false;
  }

  void _storeCookie(Response response) async {
    String? rawCookie = response.headers['set-cookie'];

    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      String cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      await const FlutterSecureStorage()
          .write(key: "user-cookie", value: cookie);
    }
  }

  static Future<void> persistAuthCredentials(
      String accessToken, String refreshToken) async {
    const storage = FlutterSecureStorage();

    await storage.write(key: "refreshToken", value: refreshToken);
    await storage.write(key: "accessToken", value: accessToken);
    return Future.value();
  }
}
