import 'package:flutter/material.dart';
import 'package:trendency/screens/welcome_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trendency',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        // '/splash': (context) =>,
        // '/second': (context) =>,
      },
    );
  }
}
