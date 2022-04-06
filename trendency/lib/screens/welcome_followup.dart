import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';
import 'package:trendency/widgets/trendency_app_bar.dart';

class WelcomeFollowup extends StatefulWidget {
  const WelcomeFollowup({Key? key}) : super(key: key);

  @override
  State<WelcomeFollowup> createState() => _WelcomeFollowupState();
}

class _WelcomeFollowupState extends State<WelcomeFollowup> {
  double _currentOpacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _currentOpacity = 1;
        _animatedStyle = const TextStyle(height: 2, fontSize: 20);
      });
    });
  }

  TextStyle _animatedStyle = const TextStyle(height: 1, fontSize: 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx < 0) {
          Routemaster.of(context).push(RouteConst.LOGIN);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColor.primary,
        appBar: TrendencyAppBar(height: 40),
        body: AnimatedOpacity(
          opacity: _currentOpacity,
          duration: const Duration(milliseconds: 1300),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CarouselSlider(
  options: CarouselOptions(height: 400.0),
  items: [1,2,3,4,5].map((i) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.amber
          ),
          child: Text('text $i', style: TextStyle(fontSize: 16.0),)
        );
      },
    );
  }).toList(),
)
                AnimatedDefaultTextStyle(
                  duration: const Duration(seconds: 1),
                  style: _animatedStyle,
                  child: Text.rich(
                    TextSpan(
                        text:
                            'Browse your favorite posts from several platforms\n\n',
                        style:
                            const TextStyle(fontSize: 24, color: Colors.black),
                        children: [
                          TextSpan(
                              text: 'Sign up now, It\'s totally free!',
                              style: Theme.of(context).textTheme.bodyText2)
                        ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Expanded(child: SizedBox.shrink()),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: Size(300, 60)),
                    onPressed: () => Routemaster.of(context).push('/login'),
                    child: Text(
                      "Sign up",
                      style: Theme.of(context).textTheme.button,
                    )),
                SizedBox(height: 15),
                Text(
                  "Already have an account?",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 8),
                Text(
                  "Login",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 14)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
