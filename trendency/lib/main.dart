import 'package:dotenv/dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trendency/app.dart';
import 'package:trendency/providers/auth_provider.dart';

void main() {
  var env = DotEnv(includePlatformEnvironment: true)..load();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
  ], child: const App()));
}
