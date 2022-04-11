import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/consts/route_consts.dart';
import 'package:trendency/models/UserModel.dart';
import 'package:trendency/providers/auth_provider.dart';
import 'package:trendency/utils/trendency_snackbar.dart';
import 'package:trendency/widgets/trendency_app_bar.dart';
import 'package:trendency/widgets/trendency_text_field.dart';
import 'package:bottom_drawer/bottom_drawer.dart';

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
  String? _image;

  BottomDrawerController controller = BottomDrawerController();

  final ImagePicker _picker = ImagePicker();

  Future<void> setImage(ImageSource type) async {
    await _picker.pickImage(source: type).then((value) {
      if (value != null) {
        setState(() {
          _image = value.path;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.close();
  }

  @override
  void initState() {
    super.initState();
    final notifier = context.read<AuthProvider>();
    void listener() {
      if (notifier.state == AuthState.loaded) {
        Routemaster.of(context).push(RouteConst.REGISTER_FOLLOWUP);
      } else if (notifier.state == AuthState.failed) {
        TrendencySnackbar.show(
            title: "Registration Failed",
            content: notifier.failure!.message,
            isError: true);
      }
    }

    notifier.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TrendencyAppBar(
          height: 40,
          color: AppColor.primary,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.primary,
        body: Stack(children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Center(
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  spacing: 25,
                  children: [
                    Text(
                      "Register",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    CircleAvatar(
                      backgroundImage:
                          _image != null ? FileImage(File(_image!)) : null,
                      backgroundColor: AppColor.secondaryColor,
                      radius: 65,
                      child: IconButton(
                        icon: const Icon(FontAwesomeIcons.camera),
                        onPressed: () async {
                          await buildBottomSheet(context);
                        },
                        color: AppColor.primary,
                      ),
                    ),
                    TrendencyTextField(
                        hidden: false,
                        width: 350,
                        hint: "Username",
                        icon: FontAwesomeIcons.user,
                        isRequired: true,
                        callback: (val) => _user = val!),
                    TrendencyTextField(
                        hidden: true,
                        width: 350,
                        hint: "Password",
                        icon: FontAwesomeIcons.asterisk,
                        isRequired: true,
                        callback: (val) => _password = val!),
                    TrendencyTextField(
                        hidden: false,
                        width: 350,
                        hint: "Email",
                        icon: FontAwesomeIcons.envelope,
                        isRequired: true,
                        callback: (val) {
                          _email = val!;
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)) {}
                        }),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(250, 60)),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .userModel !=
                                null) {
                              Routemaster.of(context)
                                  .push(RouteConst.REGISTER_FOLLOWUP);
                              return;
                            }
                            UserModel model = UserModel(
                                username: _user!,
                                email: _email!,
                                image_path: _image,
                                password: _password);

                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .registerUser(model);
                          }
                        },
                        child: Text(
                          "Sign-up",
                          style: Theme.of(context).textTheme.button,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ]));
  }

  buildBottomSheet(BuildContext context) async {
    showModalBottomSheet(
        backgroundColor: AppColor.secondaryColor,
        barrierColor: AppColor.primaryAccent.withOpacity(.1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(
                  Icons.photo,
                  color: AppColor.primary,
                ),
                title: Text(
                  'Choose From Gallery',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: AppColor.primary),
                ),
                onTap: () {
                  setImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.camera,
                  color: AppColor.primary,
                ),
                title: Text(
                  'Take a photo',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(color: AppColor.primary),
                ),
                onTap: () {
                  setImage(ImageSource.camera);
                },
              ),
            ],
          );
        });
  }
}
