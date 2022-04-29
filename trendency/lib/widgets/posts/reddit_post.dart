import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/route_consts.dart';
import 'package:trendency/models/RedditThread.dart';
import 'package:trendency/providers/reddit_post_provider.dart';
import 'package:trendency/providers/saved_threads_provider.dart';
import 'package:trendency/widgets/media/trendency_player.dart';
import 'package:trendency/widgets/comments/reddit_comments.dart';
import 'package:trendency/widgets/trendency_spinner.dart';
import "package:trendency/utils/helpers/helpers.dart";
import '../../consts/app_colors.dart';

class RedditPost extends StatefulWidget {
  const RedditPost({Key? key, required this.post}) : super(key: key);
  final RedditThread post;

  @override
  State<RedditPost> createState() => _RedditPostState();
}

enum PostType { IMAGE, VIDEO, SELF, GIF }

class _RedditPostState extends State<RedditPost> {
  var upvotes;
  bool areCommentsShown = false;
  int dir = 0;

  @override
  void initState() {
    super.initState();
    upvotes = widget.post.upvotes;
  }

  PostType getPostType(String type) {
    switch (type) {
      case "image":
        return PostType.IMAGE;
      case "video":
        return PostType.VIDEO;
      case "gif":
        return PostType.GIF;
      default:
        return PostType.SELF;
    }
  }

  Widget getPostMedia(PostType type) {
    if (type == PostType.IMAGE) {
      return GestureDetector(
        onTap: () => Routemaster.of(context)
            .push(RouteConst.TIMELINE_HERO, queryParameters: {
          "link": widget.post.url!.endsWith("jpg") ||
                  widget.post.url!.endsWith("png")
              ? widget.post.url!
              : widget.post.thumbnail,
          "title": widget.post.title
        }),
        child: Hero(
          tag: widget.post.title,
          child: CachedNetworkImage(
            placeholder: (context, url) => const TrendencySpinner(),
            imageUrl: widget.post.url!.endsWith("jpg") ||
                    widget.post.url!.endsWith("png")
                ? widget.post.url!
                : widget.post.thumbnail,
          ),
        ),
      );
    } else if (type == PostType.VIDEO &&
        widget.post.secure_media?.video != null) {
      return TrendencyPlayer(
        url: widget.post.secure_media!.video!.fallback_url,
        looping: true,
        autoplay: true,
      );
    } else if (type == PostType.GIF) {
      return CachedNetworkImage(
          imageUrl: widget.post.url!,
          filterQuality: FilterQuality.medium,
          placeholder: (context, url) => const TrendencySpinner());
    } else if (type == PostType.SELF) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.post.selftext!,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontSize: 14, color: AppColor.primary),
          overflow: TextOverflow.ellipsis,
          maxLines: 15,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: AppColor.redditColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                child: Icon(
                  FontAwesomeIcons.reddit,
                  size: 25,
                  color: AppColor.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text.rich(
                    TextSpan(text: "/r/${widget.post.subreddit}\n", children: [
                      TextSpan(
                          text: "/u/${widget.post.author}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontSize: 12, color: AppColor.primary))
                    ]),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(fontSize: 14, color: AppColor.primary)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    Helpers.getPostDate(widget.post.created!),
                    textAlign: TextAlign.end,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: AppColor.primary, fontSize: 12),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Text(widget.post.title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: AppColor.primary)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: getPostMedia(getPostType(widget.post.post_type!)),
          ),
          Container(
            color: Colors.transparent,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: TextButton.icon(
                    onPressed: () {
                      if (widget.post.upvotes >= upvotes) {
                        Provider.of<RedditPostProvider>(context, listen: false)
                            .vote(id: "t3_${widget.post.id}", dir: 1);
                        setState(() {
                          dir++;
                          upvotes++;
                        });
                      } else {
                        Provider.of<RedditPostProvider>(context, listen: false)
                            .vote(id: "t3_${widget.post.id}", dir: 0);
                        setState(() {
                          dir--;
                          upvotes--;
                        });
                      }
                    },
                    icon: Icon(
                      FontAwesomeIcons.chevronUp,
                      color: dir == 1 ? AppColor.redditColor : AppColor.primary,
                      size: 20,
                    ),
                    label: Text(upvotes.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: AppColor.primary, fontSize: 14)),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (widget.post.upvotes <= upvotes) {
                      Provider.of<RedditPostProvider>(context, listen: false)
                          .vote(id: "t3_${widget.post.id}", dir: -1);
                      setState(() {
                        dir--;
                        upvotes--;
                      });
                    } else {
                      Provider.of<RedditPostProvider>(context, listen: false)
                          .vote(id: "t3_${widget.post.id}", dir: 0);
                      setState(() {
                        dir++;

                        upvotes++;
                      });
                    }
                  },
                  icon: Icon(
                    FontAwesomeIcons.chevronDown,
                    color: dir == -1 ? AppColor.redditColor : AppColor.primary,
                    size: 20,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      context.read<RedditPostProvider>().fetchComments(
                          id: widget.post.id,
                          subreddit: widget.post.subreddit,
                          sort: "best");
                      setState(() {
                        areCommentsShown = !areCommentsShown;
                      });
                    },
                    icon: const Icon(
                      FontAwesomeIcons.solidComment,
                      color: AppColor.primary,
                      size: 20,
                    )),
                IconButton(
                    onPressed: () => context
                        .read<SavedThreadsProvider>()
                        .saveRedditThread(thread: widget.post),
                    icon: const Icon(
                      FontAwesomeIcons.save,
                      color: AppColor.primary,
                    ))
              ],
            ),
          ),
          areCommentsShown
              ? RedditComments(
                  subreddit: widget.post.subreddit,
                  id: widget.post.id,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
