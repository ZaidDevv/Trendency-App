import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/models/Post.dart';
import 'package:trendency/models/RedditThread.dart';
import 'package:trendency/models/twitter/tweet_model.dart';
import 'package:trendency/providers/post_provider.dart';
import 'package:trendency/providers/user_provider.dart';
import 'package:trendency/widgets/error_indicator.dart';
import 'package:trendency/widgets/posts/create_post.dart';
import 'package:trendency/widgets/posts/reddit_post.dart';
import 'package:trendency/widgets/posts/twitter_post.dart';

class PagedArticleListView extends StatefulWidget {
  const PagedArticleListView({Key? key, required this.scrollController})
      : super(key: key);

  final ScrollController scrollController;

  @override
  _PagedArticleListViewState createState() => _PagedArticleListViewState();
}

class _PagedArticleListViewState extends State<PagedArticleListView> {
  var _pagingController;

  @override
  void initState() {
    _pagingController = PagingController<String, Post>(
      firstPageKey: "",
    );
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _fetchPage(String pageKey) async {
    try {
      var provider = context.read<PostProvider>();
      final previouslyFetchedItemsCount =
          _pagingController.itemList?.length ?? 0;
      var items;
      items = await provider.getPosts(
          twitterAfter: provider.nextTwitterPost ?? "",
          redditAfter: provider.nextRedditPost ?? "",
          limit: 30,
          count: previouslyFetchedItemsCount);
      _pagingController.appendPage(items, "");
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
      onRefresh: () => Future.sync(
            () => _pagingController.refresh(),
          ),
      child: PagedListView.separated(
          scrollController: widget.scrollController,
          pagingController: _pagingController,
          separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
          builderDelegate: PagedChildBuilderDelegate<Post>(
            itemBuilder: (context, post, index) {
              if (index == 0) {
                if (post.type == "twitter") {
                  return Column(
                    children: [
                      const CreatePost(),
                      TwitterPost(tweet: post as TweetModel)
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      CreatePost(),
                      RedditPost(post: post as RedditThread)
                    ],
                  );
                }
              }
              if (post.type == "twitter") {
                return TwitterPost(tweet: post as TweetModel);
              } else {
                return RedditPost(post: post as RedditThread);
              }
            },
            noItemsFoundIndicatorBuilder: (context) => ErrorIndicator(
              onTryAgain: () => _pagingController.refresh(),
            ),
            firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
              onTryAgain: () => _pagingController.refresh(),
            ),
          )));
}
