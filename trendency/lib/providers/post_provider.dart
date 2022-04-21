import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:trendency/models/PostModel.dart';
import 'package:trendency/utils/api_client.dart';
import 'package:trendency/utils/failure.dart';

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
  final ApiClient _client = ApiClient();

  Future<Iterable<PostModel>> getPosts(
      {String? after, required int limit, int? count}) async {
    try {
      var response = await _client.get(
          endpoint: "/api/timeline?after=${after!}&limit=$limit&count=$count",
          withAuth: true);

      if (response.statusCode == 200) {
        var posts = (jsonDecode(response.data)["redditPosts"] as List)
            .map((post) => PostModel.fromJson(post));

        _state = PostState.loaded;
        return posts;
      } else {
        _state = PostState.failed;
        throw HttpException("${response.data}");
      }
    } catch (e) {
      _state = PostState.failed;
      _failure = Failure(e.toString());
    }
    return _posts;
  }
}
