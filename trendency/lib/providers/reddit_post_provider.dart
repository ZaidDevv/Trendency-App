import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:trendency/utils/api_client.dart';
import 'package:trendency/utils/failure.dart';

enum RedditPost { initial, loading, loaded, failed }

class RedditPostProvider with ChangeNotifier {
  RedditPost _state = RedditPost.initial;
  RedditPost get state => _state;

  Failure? _failure;
  Failure? get failure => _failure;
  static final client = ApiClient();

  Future<void> vote({required String id, required int dir}) async {
    _state = RedditPost.loading;
    notifyListeners();
    try {
      var response = await client.post(
          endpoint: "/api/reddit/vote?id=$id&dir=$dir", withAuth: true);
      if (response.statusCode == 200) {
        final user = response.data;
        _state = RedditPost.loaded;
        notifyListeners();
      } else {
        _state = RedditPost.failed;
        throw HttpException("${response.data}");
      }
    } catch (e) {
      _state = RedditPost.failed;
      _failure = Failure(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
