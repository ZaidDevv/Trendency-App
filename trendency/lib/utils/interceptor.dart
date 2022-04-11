import 'package:http_interceptor/http_interceptor.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    if (data.headers["Authorization"] != null) {
      String? accessToken = data.headers["Authorization"];
      var decoded = Jwt.parseJwt(accessToken!.trim().split(" ")[1]);
      print(decoded);
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}
