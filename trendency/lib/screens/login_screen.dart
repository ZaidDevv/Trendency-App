import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';
import 'package:trendency/providers/auth_provider.dart';
import 'package:trendency/providers/user_provider.dart';
import 'package:trendency/utils/trendency_snackbar.dart';

import 'package:trendency/widgets/trendency_app_bar.dart';
import 'package:trendency/widgets/trendency_spinner.dart';
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
  var notifier;

  void listener() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (notifier.state == AuthState.loggedIn) {
        context.read<UserProvider>().fetchProfile(notifier.userModel.id);
        WidgetsBinding.instance!.addPostFrameCallback(
            (_) => Routemaster.of(context).replace(RouteConst.HOME));
      } else if (notifier.state == AuthState.failed) {
        WidgetsBinding.instance!.addPostFrameCallback((_) => TrendencySnackbar.show(
            title: "Invalid Username/Password",
            content:
                "The username or password you have entered is incorrect!. Please try again",
            isError: true));
      }
    });
  }

  @override
  void initState() {
    notifier = context.read<AuthProvider>();
    notifier.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    notifier.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        FocusManager.instance.primaryFocus?.unfocus();
      }),
      child: Scaffold(
          appBar: const TrendencyAppBar(
            isDismissable: true,
            height: 40,
            color: Colors.transparent,
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.primary,
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: Form(
                key: _formKey,
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
                        padding: const EdgeInsets.symmetric(vertical: 15),
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
                      const SizedBox(height: 15),
                      TrendencyTextField(
                          hidden: true,
                          width: 300,
                          hint: "Password",
                          icon: FontAwesomeIcons.asterisk,
                          isRequired: true,
                          callback: (val) => _password = val!),
                      const SizedBox(height: 30),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(250, 60)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              notifier.loginUser(
                                  {"username": _user, "password": _password});
                            }
                          },
                          child: Text(
                            "LOG IN",
                            style: Theme.of(context).textTheme.button,
                          )),
                      const SizedBox(height: 15),
                      Text(
                        "Are you new here?",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      TextButton(
                        onPressed: () =>
                            Routemaster.of(context).push(RouteConst.REGISTER),
                        child: Text("Sign-up",
                            style: Theme.of(context).textTheme.bodyText1),
                      ),
                      Consumer<AuthProvider>(builder: (_, value, __) {
                        if (value.state == AuthState.loading) {
                          return const Center(child: TrendencySpinner());
                        }
                        return const SizedBox.shrink();
                      }),
                    ]),
              ),
            ),
          )),
    );
  }
}
