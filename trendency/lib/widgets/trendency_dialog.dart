import 'package:flutter/material.dart';

class TrendencyDialog extends StatelessWidget {
  const TrendencyDialog({Key? key, this.e}) : super(key: key);
  final dynamic e;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Login Failed"),
      content: SingleChildScrollView(child: Text(e.toString())),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
    );
  }
}
