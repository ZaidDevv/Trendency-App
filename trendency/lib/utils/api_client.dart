import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:trendency/utils/interceptor.dart';

class ApiClient {
  static Client? _client;

  static void _initClient() {
    // Singleton Client
    _client ??= InterceptedClient.build(
      interceptors: [AuthInterceptor()],
    );
  }
}
