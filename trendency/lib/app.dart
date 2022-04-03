import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          )),
      routeInformationParser: const RoutemasterParser(),
      routerDelegate:
          RoutemasterDelegate(routesBuilder: (context) => RouteConst.routes),
    );
  }
}
