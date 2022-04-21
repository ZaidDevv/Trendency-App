import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:trendency/consts/app_colors.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({Key? key, required this.onTryAgain}) : super(key: key);
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lottie/404_notfound.json',
          width: 400,
          height: 350,
          repeat: true,
          reverse: true,
          frameRate: FrameRate(30),
        ),
        Text("No posts were found! Please try again in a moment",
            style: Theme.of(context).textTheme.headline1,
            textAlign: TextAlign.center),
        ElevatedButton.icon(
            onPressed: onTryAgain,
            icon: const Icon(
              FontAwesomeIcons.arrowAltCircleUp,
              color: AppColor.primary,
            ),
            label: Text(
              "Try Again",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: AppColor.primary),
            ))
      ],
    );
  }
}
