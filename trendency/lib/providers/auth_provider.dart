import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:trendency/models/UserModel.dart';
import 'package:trendency/utils/failure.dart';

enum AuthState { initial, loading, loaded, failed }

class AuthProvider with ChangeNotifier {
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  AuthState _state = AuthState.initial;
  AuthState get state => _state;

  Failure? _failure;
  Failure? get failure => _failure;

  Future<void> loginUser(credentials) async {
    try {
      final response = await http.post(
          Uri.http("192.168.0.122:4080", "/api/user/auth/login"),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          body: jsonEncode(credentials));
      if (response.statusCode == 200) {
        final user = json.decode(response.body);
        _userModel = UserModel.fromJson(user);
        _state = AuthState.loaded;
        notifyListeners();
      } else {
        _state = AuthState.failed;
        throw HttpException("${response.body}");
      }
    } catch (e) {
      _state = AuthState.failed;
      _failure = Failure(e.toString());
    }
  }
}
