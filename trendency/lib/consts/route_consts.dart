import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/screens/login_screen.dart';
import 'package:trendency/screens/welcome_screen.dart';

class RouteConst {
  // Prevent instance creation
  RouteConst._();

  static const String INITIAL_ROUTE = '/';
  static const String HOME = '/home';
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';

  static final routes = RouteMap(routes: {
    INITIAL_ROUTE: (_) => const MaterialPage(child: WelcomeScreen()),
    LOGIN: (_) => const MaterialPage(child: LoginScreen())
  });
}
