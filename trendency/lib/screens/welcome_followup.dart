import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';
import 'package:trendency/widgets/instagram_icon.dart';
import 'package:trendency/widgets/trendency_app_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WelcomeFollowup extends StatefulWidget {
  const WelcomeFollowup({Key? key}) : super(key: key);

  @override
  State<WelcomeFollowup> createState() => _WelcomeFollowupState();
}

class _WelcomeFollowupState extends State<WelcomeFollowup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.primary,
      appBar: const TrendencyAppBar(
        isDismissable: true,
        height: 40,
        color: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CarouselSlider(
                options: CarouselOptions(
                  height: 170.0,
                  autoPlayCurve: Curves.easeInBack,
                  autoPlay: true,
                  autoPlayInterval: const Duration(milliseconds: 1800),
                  autoPlayAnimationDuration: const Duration(milliseconds: 400),
                  enableInfiniteScroll: true,
                ),
                items: const [
                  Icon(
                    FontAwesomeIcons.reddit,
                    size: 65,
                    color: AppColor.redditColor,
                  ),
                  Icon(
                    FontAwesomeIcons.twitter,
                    size: 100,
                    color: Colors.blue,
                  ),
                  InstagramIcon(size: 100)
                ]),
            Text(
              'Browse posts from your favorite platforms\n',
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            Text('Sign up now, It\'s totally free!',
                style: Theme.of(context).textTheme.bodyText2),
            const Expanded(child: SizedBox.shrink()),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(300, 60)),
                onPressed: () => Routemaster.of(context).push('/register'),
                child: Text(
                  "Sign up",
                  style: Theme.of(context).textTheme.button,
                )),
            const SizedBox(height: 15),
            Text(
              "Already have an account?",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  Routemaster.of(context).replace(RouteConst.LOGIN),
              child: Text(
                "Login",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 14)
          ],
        ),
      ),
    );
  }
}
