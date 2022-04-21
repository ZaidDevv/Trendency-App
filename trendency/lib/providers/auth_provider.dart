import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:trendency/models/UserModel.dart';
import 'package:trendency/utils/api_client.dart';
import 'package:trendency/utils/failure.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:trendency/utils/service_locator.dart';

enum AuthState { initial, loading, loggedIn, registered, failed }

class AuthProvider with ChangeNotifier {
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  bool _isRegistered = false;
  bool get isRegistered => _isRegistered;

  Failure? _failure;
  Failure? get failure => _failure;

  Future<void> loginUser(credentials) async {
    try {
      _state = AuthState.loading;
      notifyListeners();
      final response = await http.post(
          Uri.parse("${dotenv.env['BASE_URL']!}/api/user/auth/login"),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: jsonEncode(credentials));
      if (response.statusCode == 200) {
        final user = json.decode(response.body);
        _userModel = UserModel.fromJson(user);

        persistAuthCredentials(user["accessToken"], user["refreshToken"]);
        _state = AuthState.loggedIn;
        notifyListeners();
      } else {
        _state = AuthState.failed;
        throw HttpException("${response.body}");
      }
    } catch (e) {
      _state = AuthState.failed;
      _failure = Failure(e.toString());
      notifyListeners();
    }
  }

  Future<void> registerUser(UserModel user) async {
    _state = AuthState.loading;
    notifyListeners();
    var uri = Uri.parse(dotenv.env['BASE_URL']! + "/api/user/auth/register");
    var request = http.MultipartRequest("POST", uri);
    try {
      if (user.image_path != null) {
        File imageFile = File(user.image_path!);
        var stream = http.ByteStream(Stream.castFrom(imageFile.openRead()));
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile('avatar', stream, length,
            filename: basename(imageFile.path));
        request.files.add(multipartFile);
      }

      request.fields["username"] = user.username;
      request.fields["password"] = user.password!;
      request.fields["email"] = user.email;

      var response = await request.send();

      response.stream.transform(utf8.decoder).listen((value) async {
        var result = jsonDecode(value);

        if (response.statusCode == 200) {
          _userModel = UserModel.fromJson(result);
          print(userModel!.accessToken!);
          persistAuthCredentials(
              _userModel!.accessToken!, _userModel!.refreshToken!);
          _userModel!.accessToken = result["accessToken"];
          _userModel!.refreshToken = result["refreshToken"];
          _state = AuthState.registered;
        } else {
          _state = AuthState.failed;
          _failure =
              Failure("Request Has failed with status ${response.statusCode}");
        }
        notifyListeners();
      });
    } catch (e) {
      _state = AuthState.failed;
      _failure = Failure(e.toString());
      notifyListeners();
    }
  }

  Future<void> persistAuthCredentials(
      String accessToken, String refreshToken) async {
    const storage = FlutterSecureStorage();

    await storage.write(key: "refreshToken", value: refreshToken);
    await storage.write(key: "accessToken", value: accessToken);
    return Future.value();
  }
}
