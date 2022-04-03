import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _currentOpacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _currentOpacity = 1;
        _animatedStyle = TextStyle(wordSpacing: 1, height: 1, fontSize: 20);
      });
    });
  }

  TextStyle _animatedStyle = TextStyle(wordSpacing: 15, height: 3, fontSize: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.primary,
      body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [
          AnimatedOpacity(
            opacity: _currentOpacity,
            duration: Duration(milliseconds: 1300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie/welcome_page_animation.json',
                    width: 350,
                    height: 350,
                    frameRate: FrameRate(60),
                    reverse: true),
                AnimatedDefaultTextStyle(
                  duration: const Duration(seconds: 1),
                  style: _animatedStyle,
                  child: const Text.rich(
                    TextSpan(
                        text: 'Trendency where trends tend to \n\n',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        children: [
                          TextSpan(
                              text: 'Ascend',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  fontSize: 26,
                                  color: AppColor.thirdColor))
                        ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      Routemaster.of(context).push(RouteConst.LOGIN),
                  style: ElevatedButton.styleFrom(
                      primary: AppColor.thirdColor.withOpacity(.3),
                      shape: const StadiumBorder(
                          side: BorderSide(color: AppColor.thirdColor)),
                      elevation: 2,
                      minimumSize: const Size(250, 80),
                      maximumSize: const Size(250, 80)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Get Started",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Lottie.asset('assets/lottie/arrow_right.json',
                          width: 50,
                          height: 60,
                          frameRate: FrameRate(60),
                          repeat: true,
                          reverse: true),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
