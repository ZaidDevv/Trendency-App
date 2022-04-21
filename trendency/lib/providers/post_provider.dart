import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:trendency/models/PostModel.dart';
import 'package:trendency/models/UserModel.dart';
import 'package:trendency/utils/api_client.dart';
import 'package:trendency/utils/failure.dart';
import 'package:trendency/utils/service_locator.dart';

enum PostState { initial, loading, loaded, failed }

class PostProvider with ChangeNotifier {
  List<PostModel> _posts = [];
  List<PostModel> get items => _posts;

  PostState _state = PostState.initial;
  PostState get state => _state;

  bool _hasMore = true;
  bool get hasMore => this._hasMore;

  Failure? _failure;
  Failure? get failure => _failure;

  Future<Iterable<PostModel>> getPosts(
      {String? after, required int limit, int? count}) async {
    final ApiClient _client = locator();

    try {
      var response = await _client.get(
          "/api/timeline?after=${after!}&limit=$limit&count=$count",
          withAuth: true);

      if (response.statusCode == 200) {
        var posts = (jsonDecode(response.body)["redditPosts"] as List)
            .map((post) => PostModel.fromJson(post));

        _state = PostState.loaded;
        return posts;
      } else {
        _state = PostState.failed;
        throw HttpException("${response.body}");
      }
    } catch (e) {
      _state = PostState.failed;
      _failure = Failure(e.toString());
    }
    return _posts;
  }
}
