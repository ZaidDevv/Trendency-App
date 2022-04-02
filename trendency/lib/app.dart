import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trendency',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
