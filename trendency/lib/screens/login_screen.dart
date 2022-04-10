import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';
import 'package:trendency/providers/auth_provider.dart';

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
  double _currentOpacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _currentOpacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        FocusManager.instance.primaryFocus?.unfocus();
      }),
      child: Scaffold(
          appBar: TrendencyAppBar(height: 40),
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.primary,
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: Form(
                key: _formKey,
                child: AnimatedOpacity(
                  opacity: _currentOpacity,
                  duration: Duration(milliseconds: 600),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lottie/login_anim.json',
                          width: 280,
                          height: 250,
                          repeat: true,
                          reverse: true,
                          frameRate: FrameRate(30),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Welcome",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ),
                        TrendencyTextField(
                            hidden: false,
                            width: 300,
                            hint: "Username",
                            icon: FontAwesomeIcons.user,
                            isRequired: true,
                            callback: (val) => _user = val!),
                        SizedBox(height: 15),
                        TrendencyTextField(
                            hidden: true,
                            width: 300,
                            hint: "Password",
                            icon: FontAwesomeIcons.asterisk,
                            isRequired: true,
                            callback: (val) => _password = val!),
                        SizedBox(height: 30),
                        ElevatedButton(
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
                            )),
                        SizedBox(height: 15),
                        Text(
                          "Are you new here?",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        TextButton(
                          onPressed: () => {
                            Routemaster.of(context).push(RouteConst.REGISTER)
                          },
                          child: Text("Sign-up",
                              style: Theme.of(context).textTheme.bodyText1),
                        ),
                        // Consumer<AuthProvider>(builder: (_, value, __) {
                        //   if (value.failure != null) {}
                        //   if (value.userModel != null) {
                        //     return Text(value.userModel!.username);
                        //   }
                        //   return Container();
                        // }),
                      ]),
                ),
              ),
            ),
          )),
    );
  }
}
