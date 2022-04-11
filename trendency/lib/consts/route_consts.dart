import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/screens/login_screen.dart';
import 'package:trendency/screens/registration_followup.dart';
import 'package:trendency/screens/welcome_followup.dart';
import 'package:trendency/screens/welcome_screen.dart';
import 'package:trendency/utils/inappbrowser.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../screens/registration_screen.dart';

class RouteConst {
  // Prevent instance creation
  RouteConst._();

  static const String WELCOME_ROUTE = '/';
  static const String WELCOME_FOLLOWUP = '/followup';
  static const String HOME = '/home';
  static const String LOGIN = '/welcome/login';
  static const String REGISTER = '/register';
  static const String REGISTER_FOLLOWUP = '/register/link';
  static const String LINK_TWITTER = '$REGISTER_FOLLOWUP/twitter';

  static final routes = RouteMap(routes: {
    WELCOME_ROUTE: (_) => const MaterialPage(child: WelcomeScreen()),
    WELCOME_FOLLOWUP: (_) => const MaterialPage(child: WelcomeFollowup()),
    LOGIN: (_) => const MaterialPage(child: LoginScreen()),
    REGISTER: (_) => const MaterialPage(child: RegistrationScreen()),
    LINK_TWITTER: (_) => MaterialPage(
        child: TrendencyBrowser(
            url: "${dotenv.env['BASE_URL']}/api/3rd-party/twitter/connect")),
    REGISTER_FOLLOWUP: (_) =>
        const MaterialPage(child: RegistrationFollowupScreen()),
  });
}
