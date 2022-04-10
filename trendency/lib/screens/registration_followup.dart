import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/providers/auth_provider.dart';
import 'package:trendency/widgets/trendency_app_bar.dart';
import 'package:trendency/widgets/trendency_text_field.dart';
import 'package:bottom_drawer/bottom_drawer.dart';

class RegistrationFollowupScreen extends StatefulWidget {
  const RegistrationFollowupScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationFollowupScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationFollowupScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _user;
  String? _password;
  String? _email;
  File? _image;
  double _currentOpacity = 0;

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
    return Scaffold(
        appBar: const TrendencyAppBar(height: 40),
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
                          _image != null ? FileImage(_image!) : null,
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
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              _image != null) {
                            _formKey.currentState!.save();
                          }
                        },
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
            ),
          ),
          // TrendencyDrawer(controller: controller),
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

  Future<void> setImage(ImageSource type) async {
    final XFile? image = await _picker.pickImage(source: type).then((value) {
      if (value != null) {
        setState(() {
          _image = File(value.path);
        });
      }
    });
  }
}
