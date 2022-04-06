import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';
import 'package:trendency/models/UserModel.dart';
import 'package:trendency/providers/auth_provider.dart';
import 'package:trendency/widgets/trendency_dialog.dart';
import 'package:trendency/widgets/trendency_glass.dart';
import 'package:trendency/widgets/trendency_app_bar.dart';
import 'package:trendency/widgets/trendency_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _user;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 2) {
            Routemaster.of(context).pop();
          }
        },
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColor.primary,
            body: Stack(children: [
              Lottie.asset(
                'assets/lottie/login_anim.json',
                width: 300,
                height: 290,
                frameRate: FrameRate(30),
              ),
              Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Welcome",
                            style: Theme.of(context).textTheme.headline1,
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: TrendencyTextField(
                            hidden: false,
                            width: 300,
                            hint: "Username",
                            icon: FontAwesomeIcons.user,
                            isRequired: true,
                            callback: (val) => _user = val!),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TrendencyTextField(
                            hidden: true,
                            width: 300,
                            hint: "Password",
                            icon: FontAwesomeIcons.asterisk,
                            isRequired: true,
                            callback: (val) => _password = val!),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(250, 60)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  Provider.of<AuthProvider>(context,
                                          listen: false)
                                      .loginUser({
                                    "username": _user,
                                    "password": _password
                                  });
                                }
                              },
                              child: Text(
                                "LOG IN",
                                style: Theme.of(context).textTheme.button,
                              ))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Are you new here?",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          TextButton(
                            onPressed: () => {
                              Routemaster.of(context).push(RouteConst.REGISTER)
                            },
                            child: Text("Sign-up",
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
                          Consumer<AuthProvider>(builder: (_, value, __) {
                            if (value.failure != null) {}
                            if (value.userModel != null) {
                              return Text(value.userModel!.username);
                            }
                            return Container();
                          })
                        ],
                      ),
                    ]),
              ),
            ])));
  }
}
