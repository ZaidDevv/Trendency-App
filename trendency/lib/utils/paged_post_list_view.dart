import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:trendency/models/PostModel.dart';
import 'package:trendency/providers/post_provider.dart';
import 'package:trendency/widgets/error_indicator.dart';
import 'package:trendency/widgets/posts/reddit_post.dart';

// 1
class PagedArticleListView extends StatefulWidget {
  const PagedArticleListView({
    Key? key,
  }) : super(key: key);

  @override
  _PagedArticleListViewState createState() => _PagedArticleListViewState();
}

class _PagedArticleListViewState extends State<PagedArticleListView> {
  var _pagingController;

  @override
  void initState() {
    _pagingController = PagingController<String, PostModel>(
      firstPageKey: "",
    );
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(String pageKey) async {
    try {
      var provider = context.read<PostProvider>();
      final previouslyFetchedItemsCount =
          _pagingController.itemList?.length ?? 0;
      final items = await provider.getPosts(
          after: pageKey, limit: 30, count: previouslyFetchedItemsCount);

      var itemsList = items.toList();

      final isLastPage = !provider.hasMore;

      if (isLastPage) {
        _pagingController.appendLastPage(itemsList);
      } else {
        final nextPageKey = "t3_" + itemsList[itemsList.length - 1].id;
        _pagingController.appendPage(itemsList, nextPageKey);
      }
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
          pagingController: _pagingController,
          padding: const EdgeInsets.all(5),
          separatorBuilder: (context, index) => const SizedBox(
                height: 16,
              ),
          builderDelegate: PagedChildBuilderDelegate<PostModel>(
            itemBuilder: (context, post, index) => RedditPost(post: post),
            animateTransitions: true,
            noItemsFoundIndicatorBuilder: (context) => ErrorIndicator(
              onTryAgain: () => _pagingController.refresh(),
            ),
            firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
              onTryAgain: () => _pagingController.refresh(),
            ),
          )));
}
