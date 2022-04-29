import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';
import 'package:trendency/providers/user_provider.dart';

class RegistrationFollowupScreen extends StatefulWidget {
  const RegistrationFollowupScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationFollowupScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationFollowupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.primary,
        body: Stack(alignment: Alignment.topCenter, children: [
          Positioned(
            top: 100,
            child: Text(
              "Link your accounts",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
          Center(
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              runSpacing: 25,
              children: [
                SignInButton(
                  Buttons.Twitter,
                  padding: const EdgeInsets.all(15),
                  text: "Link Twitter",
                  elevation: 3,
                  onPressed: () {
                    Routemaster.of(context).push(RouteConst.LINK_TWITTER);
                  },
                ),
                SignInButton(
                  Buttons.Reddit,
                  padding: const EdgeInsets.all(15),
                  text: "Link Reddit",
                  elevation: 3,
                  onPressed: () {
                    Routemaster.of(context).push(RouteConst.LINK_REDDIT);
                  },
                ),
                const SizedBox(height: 25),
                Consumer<UserProvider>(builder: (_, value, __) {
                  if (value.state == UserState.loaded &&
                      value.userModel!.linked_accounts.length >= 2) {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(340, 60)),
                        onPressed: () {
                          Routemaster.of(context).push(RouteConst.HOME);
                        },
                        child: Text(
                          "Continue",
                          style: Theme.of(context).textTheme.button,
                        ));
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.infoCircle,
                          color: AppColor.secondaryColor,
                          size: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Please Link two accounts to proceed!",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ]));
  }
}
