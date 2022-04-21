import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shimmer/shimmer.dart';
import 'package:trendency/consts/route_consts.dart';
import 'package:trendency/models/PostModel.dart';
import 'package:trendency/providers/reddit_post_provider.dart';
import 'package:trendency/widgets/media/reddit_video_widget.dart';
import 'package:trendency/widgets/trendency_photo.dart';
import 'package:video_player/video_player.dart';

import '../../consts/app_colors.dart';

class RedditPost extends StatefulWidget {
  const RedditPost({Key? key, required this.post}) : super(key: key);
  final PostModel post;

  @override
  State<RedditPost> createState() => _RedditPostState();
}

enum PostType { IMAGE, VIDEO, SELF, GIF }

class _RedditPostState extends State<RedditPost> {
  var upvotes;

  @override
  void initState() {
    super.initState();
    upvotes = widget.post.upvotes;
  }

  late VideoPlayerController videoPlayerController;
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
          "title": widget.post.title!
        }),
        child: Hero(
          tag: widget.post.title!,
          child: Image.network(
            widget.post.url!.endsWith("jpg") || widget.post.url!.endsWith("png")
                ? widget.post.url!
                : widget.post.thumbnail,
            fit: BoxFit.contain,
          ),
        ),
      );
    } else if (type == PostType.VIDEO) {
      return getRedditVideo();
    } else if (type == PostType.GIF) {
      return Center(child: Image.network(widget.post.url!));
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
    return SizedBox.shrink();
  }

  Widget getRedditVideo() {
    if (widget.post.secure_media?.video != null) {
      var video = widget.post.secure_media!.video!;

      videoPlayerController = VideoPlayerController.network(video.fallback_url);

      return RedditVideoWidget(
        url: video.fallback_url,
        controller: videoPlayerController,
        looping: true,
        autoplay: true,
      );
    }

    return const SizedBox.shrink();
  }

  String getPostDate(int created) {
    var postDate =
        DateTime.fromMillisecondsSinceEpoch(widget.post.created! * 1000);
    List<String> dateAndTime = postDate.toIso8601String().split("T");

    if (postDate.difference(DateTime.now()).inDays > 0) {
      return dateAndTime.first + dateAndTime.last.substring(0, 5);
    } else {
      return dateAndTime.last.substring(0, 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppColor.primaryAccent.withOpacity(1),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            colors: [
              AppColor.secondaryColor.withOpacity(.9),
              AppColor.secondaryAccent.withOpacity(.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    FontAwesomeIcons.reddit,
                    size: 20,
                    color: AppColor.primary,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text.rich(
                        TextSpan(
                            text: "/r/${widget.post.subreddit!}\n",
                            children: [
                              TextSpan(
                                  text: "/u/${widget.post.author!}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                          fontSize: 12,
                                          color: AppColor.primary))
                            ]),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 14, color: AppColor.primary)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      getPostDate(widget.post.created!),
                      textAlign: TextAlign.end,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(color: AppColor.primary, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("${widget.post.title!}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: AppColor.primary)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: getPostMedia(getPostType(widget.post.post_type!)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      if (widget.post.upvotes! >= upvotes) {
                        Provider.of<RedditPostProvider>(context, listen: false)
                            .vote(id: "t3_${widget.post.id}", dir: 1);
                        setState(() {
                          upvotes++;
                        });
                      } else {
                        Provider.of<RedditPostProvider>(context, listen: false)
                            .vote(id: "t3_${widget.post.id}", dir: 0);
                        setState(() {
                          upvotes--;
                        });
                      }
                    },
                    icon: const Icon(
                      FontAwesomeIcons.arrowUp,
                      color: AppColor.primary,
                      size: 20,
                    ),
                    label: Text(upvotes.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: AppColor.primary, fontSize: 14)),
                  ),
                  IconButton(
                    onPressed: () {
                      if (widget.post.upvotes! <= upvotes) {
                        Provider.of<RedditPostProvider>(context, listen: false)
                            .vote(id: "t3_${widget.post.id}", dir: -1);
                        setState(() {
                          upvotes--;
                        });
                      } else {
                        Provider.of<RedditPostProvider>(context, listen: false)
                            .vote(id: "t3_${widget.post.id}", dir: 0);
                        setState(() {
                          upvotes++;
                        });
                      }
                    },
                    icon: const Icon(
                      FontAwesomeIcons.arrowDown,
                      color: AppColor.primary,
                      size: 20,
                    ),
                  ),
                  IconButton(
                      onPressed: () => {},
                      icon: const Icon(
                        FontAwesomeIcons.comment,
                        color: AppColor.primary,
                        size: 20,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
