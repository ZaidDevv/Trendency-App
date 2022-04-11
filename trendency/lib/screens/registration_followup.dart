import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';
import 'package:trendency/providers/auth_provider.dart';
import 'package:trendency/widgets/instagram_icon.dart';
import 'package:trendency/widgets/trendency_app_bar.dart';
import 'package:trendency/widgets/trendency_text_field.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationFollowupScreen extends StatefulWidget {
  const RegistrationFollowupScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationFollowupScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationFollowupScreen> {
  final _formKey = GlobalKey<FormState>();

  BottomDrawerController controller = BottomDrawerController();

  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   setState(() {
    //     _currentOpacity = 1;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    InAppWebViewController _controller;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.primary,
        body: Stack(children: [
          Center(
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              runSpacing: 25,
              children: [
                Text(
                  "Link your accounts",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SignInButton(
                  Buttons.Twitter,
                  padding: EdgeInsets.all(15),
                  text: "Link Twitter",
                  elevation: 3,
                  onPressed: () {
                    Routemaster.of(context).push(RouteConst.LINK_TWITTER);
                  },
                ),
                SignInButton(
                  Buttons.Reddit,
                  padding: EdgeInsets.all(15),
                  text: "Link Reddit",
                  elevation: 3,
                  onPressed: () {
                    _launchURL(
                        'http://192.168.0.122:4080/api/3rd-party/reddit');
                  },
                ),
                TextButton.icon(
                    icon: const InstagramIcon(size: 20),
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 27),
                        alignment: Alignment.centerLeft,
                        minimumSize: Size(250, 50),
                        backgroundColor: AppColor.secondaryColor),
                    label: Text("Link Instagram")),
                const SizedBox(height: 25),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(340, 60)),
                    onPressed: () {},
                    child: Text(
                      "Continue",
                      style: Theme.of(context).textTheme.button,
                    )),
                Consumer<AuthProvider>(builder: (_, value, __) {
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
          // TrendencyDrawer(controller: controller),
        ]));
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }
}
