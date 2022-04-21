import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        title: 'Trendency',
        theme: ThemeData(
          primarySwatch: AppColor.primaryMaterial,
          primaryColor: AppColor.primary,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
              TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
            },
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                primary: AppColor.secondaryColor,
                shape: (RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: AppColor.primary)))),
          ),
          textTheme: GoogleFonts.kanitTextTheme(
            Theme.of(context).textTheme,
          ).copyWith(
              headline1: const TextStyle(
                  fontSize: 28,
                  color: AppColor.thirdColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1),
              bodyText1: const TextStyle(
                  fontSize: 18, color: AppColor.thirdColor, letterSpacing: 1),
              bodyText2: const TextStyle(
                  fontSize: 15,
                  color: AppColor.primaryAccent,
                  letterSpacing: 1),
              button: const TextStyle(
                  fontSize: 18, color: AppColor.primary, letterSpacing: 1)),
        ),
        routeInformationParser: RoutemasterParser(),
        routerDelegate:
            RoutemasterDelegate(routesBuilder: (context) => RouteConst.routes),
      ),
    );
  }
}
