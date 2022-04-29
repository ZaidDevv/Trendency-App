import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:trendency/models/RedditComment.dart';
import 'package:trendency/utils/api_client.dart';
import 'package:trendency/utils/failure.dart';

enum RedditPost { initial, loading, loaded, comments_loaded, failed }

class RedditPostProvider with ChangeNotifier {
  RedditPost _state = RedditPost.initial;
  RedditPost get state => _state;

  Iterable _comments = [];
  Iterable get comments => _comments;

  Failure? _failure;
  Failure? get failure => _failure;
  static final client = ApiClient();

  Future<void> vote({required String id, required int dir}) async {
    try {
      var response = await client.post(
          endpoint: "/api/reddit/vote?id=$id&dir=$dir", withAuth: true);
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw HttpException("${response.data}");
      }
    } catch (e) {
      _failure = Failure(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchComments(
      {required String id,
      required String subreddit,
      String? title,
      String? sort}) async {
    _state = RedditPost.loading;
    notifyListeners();
    try {
      var response = await client.get(
          endpoint:
              "/api/reddit/comments?id=$id&subreddit=$subreddit&title=${title ?? "title"}&sort=${sort ?? "best"}",
          withAuth: true);
      if (response.statusCode == 200) {
        final data = response.data;
        if ((data["comments"] as List).isNotEmpty) {
          _comments = (data["comments"] as List)
              .map((comment) => RedditComment.fromJson(comment));
        }

        _state = RedditPost.comments_loaded;
        notifyListeners();
      } else {
        _state = RedditPost.failed;
        throw HttpException("${response.data}");
      }
    } catch (e) {
      _state = RedditPost.failed;
      _failure = Failure(e.toString());
      notifyListeners();
    }
  }

  Future<void> createThread(
      {required String subreddit,
      required String title,
      String? media_path,
      String? selfText}) async {
    try {
      MultipartFile file;
      Map<String, Object?> body;
      if (media_path != null) {
        file = await MultipartFile.fromFile(media_path,
            filename: media_path.split("/").last);
        body = {
          "media": file,
          "selfText": selfText,
          "title": title,
          "subreddit": subreddit
        };
      } else {
        body = {"selfText": selfText, "title": title, "subreddit": subreddit};
      }

      var response = await client.post(
          endpoint: "/api/reddit/create",
          withAuth: true,
          contentType: Headers.formUrlEncodedContentType,
          body: body);
      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        throw HttpException("${response.data}");
      }
    } catch (e) {
      _failure = Failure(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
