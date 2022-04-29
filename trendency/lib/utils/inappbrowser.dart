import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:trendency/consts/app_colors.dart';
import 'package:trendency/providers/auth_provider.dart';
import 'package:trendency/providers/user_provider.dart';
import 'package:trendency/utils/trendency_snackbar.dart';
import 'package:trendency/widgets/trendency_app_bar.dart';

import '../models/UserModel.dart';

class TrendencyBrowser extends StatefulWidget {
  final String url;

  const TrendencyBrowser({Key? key, required this.url}) : super(key: key);

  @override
  State<TrendencyBrowser> createState() => _TrendencyBrowserState();
}

class _TrendencyBrowserState extends State<TrendencyBrowser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TrendencyAppBar(
        isDismissable: true,
        color: Colors.transparent,
        height: 40,
      ),
      body: InAppWebView(
          initialUrlRequest: URLRequest(
              method: "GET",
              url: Uri.parse(widget.url),
              headers: {
                "x-username": context.read<AuthProvider>().userModel!.username
              }),
          onUpdateVisitedHistory: (controller, uri, _) async {
            if (uri!.path.contains("callback")) {
              var user = context.read<AuthProvider>().userModel;
              await context.read<UserProvider>().fetchProfile(user!.id);
              TrendencySnackbar.show(
                  title: "Success",
                  content: "Profile Successfully linked!",
                  isError: false);

              Routemaster.of(context).pop();
            }
          }),
    );
  }
}
