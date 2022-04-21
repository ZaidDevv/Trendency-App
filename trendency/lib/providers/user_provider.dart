import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:trendency/models/UserModel.dart';
import 'package:trendency/utils/api_client.dart';
import 'package:trendency/utils/failure.dart';

enum UserState { initial, loading, loaded, failed }

class UserProvider with ChangeNotifier {
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  UserState _state = UserState.initial;
  UserState get state => _state;

  Failure? _failure;
  Failure? get failure => _failure;

  static final client = ApiClient();

  Future<void> fetchProfile(id) async {
    _state = UserState.loading;
    notifyListeners();
    try {
      var response =
          await client.get(endpoint: "/api/user/$id", withAuth: true);
      if (response.statusCode == 200) {
        final user = response.data;
        _userModel = UserModel.fromJson(user);
        _state = UserState.loaded;
        notifyListeners();
      } else {
        _state = UserState.failed;
        throw HttpException("${response.data}");
      }
    } catch (e) {
      _state = UserState.failed;
      _failure = Failure(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> getRedditPosts() async {
    try {
      var response =
          await client.get(endpoint: "/api/reddit/threads", withAuth: true);
      if (response.statusCode == 200) {
        print(response.data);
      } else {
        _state = UserState.failed;
        throw HttpException("${response.data}");
      }
    } catch (e) {
      _state = UserState.failed;
      _failure = Failure(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
