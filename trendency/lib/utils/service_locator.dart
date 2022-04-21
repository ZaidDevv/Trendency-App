import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:trendency/utils/api_client.dart';

final GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  locator.registerSingleton<ApiClient>(ApiClient());
}
