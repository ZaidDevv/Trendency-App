import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:trendency/utils/api_client.dart';
import 'package:trendency/utils/failure.dart';
import 'package:trendency/utils/service_locator.dart';

class AuthInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      try {
        FlutterSecureStorage storage = const FlutterSecureStorage();
        var refreshToken = await storage.read(key: "refreshToken");
        if (refreshToken != null) {
          final ApiClient _client = locator();
          bool isRefreshed = await _client.refreshToken(refreshToken);
        }
      } catch (e) {
        return data;
      }
    }
    return data;
  }
}
