import 'package:flutter/material.dart';

import '../consts/app_colors.dart';

class TrendencyTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isRequired;
  final double width;
  final bool hidden;
  final ValueSetter<String?> callback;

  const TrendencyTextField(
      {Key? key,
      required this.hint,
      required this.icon,
      required this.hidden,
      required this.width,
      required this.callback,
      required this.isRequired})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextFormField(
        obscureText: hidden,
        onSaved: callback,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          icon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              icon,
              color: AppColor.secondaryColor,
              size: 21,
            ),
          ),
          hintStyle:
              TextStyle(fontSize: 18, color: Colors.white.withOpacity(.9)),
        ),
        validator: (submitted) {
          if (submitted!.isEmpty && isRequired) {
            return "Please make sure to fill the $hint";
          }
          return null;
        },
      ),
    );
  }
}
