import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trendency/consts/app_colors.dart';

class GlassMorphism extends StatelessWidget {
  final Widget child;
  final double start;
  final double end;
  const GlassMorphism({
    Key? key,
    required this.child,
    required this.start,
    required this.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 350,
          height: 400,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withAlpha(140),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
            gradient: LinearGradient(
              colors: [
                AppColor.primary.withOpacity(start),
                AppColor.secondaryColor.withOpacity(end),
              ],
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              width: 1.5,
              color: AppColor.primary.withOpacity(0.25),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
