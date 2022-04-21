import 'package:flutter/material.dart';

class TrendencyDialog extends StatelessWidget {
  const TrendencyDialog(
      {Key? key,
      required this.title,
      required this.actions,
      required this.description})
      : super(key: key);
  final String title;
  final List<Widget> actions;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(description.toString())),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        actions: actions);
  }
}
