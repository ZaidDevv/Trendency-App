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
import 'package:trendency/widgets/trendency_glass.dart';
import 'package:trendency/widgets/trendency_app_bar.dart';
import 'package:trendency/widgets/trendency_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _user;
  String? _password;
  String? _email;

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
            body: Align(
              alignment: Alignment.center,
              child: Stack(children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Lottie.asset('assets/lottie/registration.json',
                      width: 300,
                      height: 290,
                      frameRate: FrameRate(30),
                      reverse: true),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Register",
                          style: TextStyle(
                            fontSize: 34,
                            color: Colors.white,
                            letterSpacing: 1,
                          )),
                      TrendencyTextField(
                          hidden: false,
                          width: 300,
                          hint: "Username",
                          icon: FontAwesomeIcons.user,
                          isRequired: true,
                          callback: (val) => _user = val!),
                      TrendencyTextField(
                          hidden: true,
                          width: 300,
                          hint: "Password",
                          icon: FontAwesomeIcons.asterisk,
                          isRequired: true,
                          callback: (val) => _password = val!),
                      TrendencyTextField(
                          hidden: true,
                          width: 300,
                          hint: "Email",
                          icon: FontAwesomeIcons.envelope,
                          isRequired: true,
                          callback: (val) => _email = val!),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(250, 60)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              Provider.of<AuthProvider>(context, listen: false)
                                  .loginUser({
                                "username": _user,
                                "password": _password
                              });
                            }
                          },
                          child: Text(
                            "SIGN UP",
                            style: Theme.of(context).textTheme.button,
                          )),
                      Consumer<AuthProvider>(builder: (_, value, __) {
                        if (value.failure != null) {
                          final snackBar = SnackBar(
                            content: const Text('Hi, I am a SnackBar!'),
                            backgroundColor: (Colors.black12),
                            action: SnackBarAction(
                              label: 'dismiss',
                              onPressed: () {},
                            ),
                          );
                        }
                        if (value.userModel != null) {
                          return Text(value.userModel!.username);
                        }
                        return Container();
                      })
                    ],
                  ),
                ),
              ]),
            )));
  }
}
