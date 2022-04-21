import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:trendency/models/UserModel.dart';
import 'package:trendency/utils/api_client.dart';
import 'package:trendency/utils/failure.dart';
import 'package:trendency/utils/service_locator.dart';

enum RedditPost { initial, loading, loaded, failed }

class RedditPostProvider with ChangeNotifier {
  RedditPost _state = RedditPost.initial;
  RedditPost get state => _state;

  Failure? _failure;
  Failure? get failure => _failure;

  Future<void> vote({required String id, required int dir}) async {
    final ApiClient _client = locator();

    _state = RedditPost.loading;
    notifyListeners();
    try {
      var response = await _client.post("/api/reddit/vote?id=$id&dir=$dir",
          withAuth: true);
      if (response.statusCode == 200) {
        final user = json.decode(response.body);
        _state = RedditPost.loaded;
        notifyListeners();
      } else {
        _state = RedditPost.failed;
        throw HttpException("${response.body}");
      }
    } catch (e) {
      _state = RedditPost.failed;
      _failure = Failure(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
