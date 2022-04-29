import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';
import 'package:trendency/providers/auth_provider.dart';
import 'package:trendency/providers/user_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      var storage = const FlutterSecureStorage();
      await storage.read(key: "accessToken").then((value) {
        if (value == null || Jwt.isExpired(value)) {
          FlutterNativeSplash.remove();
          return;
        }
        final decodedToken = Jwt.parseJwt(value);
        Provider.of<UserProvider>(context, listen: false)
            .fetchProfile(decodedToken["id"])
            .then((value) => Routemaster.of(context).replace(RouteConst.HOME));
        Future.delayed(const Duration(seconds: 2), () {
          FlutterNativeSplash.remove();
        });
      });

      setState(() {
        _animatedStyle =
            const TextStyle(wordSpacing: 1, height: 1, fontSize: 20);
      });
    });
  }

  TextStyle _animatedStyle =
      const TextStyle(wordSpacing: 15, height: 3, fontSize: 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx < 0) {
          Routemaster.of(context).push(RouteConst.WELCOME_FOLLOWUP);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColor.primary,
        body: Stack(
          fit: StackFit.expand,
          alignment: AlignmentDirectional.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset('assets/lottie/welcome_page_animation.json',
                    width: 350,
                    height: 350,
                    frameRate: FrameRate(30),
                    reverse: true),
                AnimatedDefaultTextStyle(
                  duration: const Duration(seconds: 1),
                  style: _animatedStyle,
                  child: Text.rich(
                    TextSpan(
                        text: 'Trendency where trends tend to \n\n',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        children: [
                          TextSpan(
                              text: 'Ascend',
                              style: Theme.of(context).textTheme.headline1)
                        ]),
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: Size(300, 60)),
                    onPressed: () => Routemaster.of(context)
                        .push(RouteConst.WELCOME_FOLLOWUP),
                    child: Text(
                      "Get Started",
                      style: Theme.of(context).textTheme.button,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
