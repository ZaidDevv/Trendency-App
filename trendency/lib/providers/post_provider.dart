import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:trendency/models/Post.dart';
import 'package:trendency/models/RedditThread.dart';
import 'package:trendency/models/twitter/tweet_model.dart';
import 'package:trendency/utils/api_client.dart';
import 'package:trendency/utils/failure.dart';

enum PostState { initial, loading, loaded, failed }

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get items => _posts;

  PostState _state = PostState.initial;
  PostState get state => _state;

  String? nextRedditPost;
  String? nextTwitterPost;

  bool _hasMore = true;
  bool get hasMore => this._hasMore;

  Failure? _failure;
  Failure? get failure => _failure;
  final ApiClient _client = ApiClient();

  Future<List<Post>> getPosts(
      {String? redditAfter,
      String? twitterAfter,
      required int limit,
      int? count}) async {
    try {
      var response = await _client.get(
          endpoint: "/api/timeline",
          queryParams: {
            "reddit_after": redditAfter,
            "twitter_after": twitterAfter,
            "limit": limit,
            "count": count
          },
          withAuth: true);

      if (response.statusCode == 200) {
        print(response.data);

        var posts = (response.data["posts"] as List).map((post) {
          print(post);

          if (post.containsKey("ups")) {
            return RedditThread.fromJson(post);
          } else {
            return TweetModel.fromJson(post);
          }
        }).toList();
        print(response.data);

        nextRedditPost = response.data["nextReddit"];
        nextTwitterPost = response.data["nextTwitter"];
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
