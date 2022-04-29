import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:trendency/app.dart';
import 'package:trendency/providers/auth_provider.dart';
import 'package:trendency/providers/post_provider.dart';
import 'package:trendency/providers/reddit_post_provider.dart';
import 'package:trendency/providers/saved_threads_provider.dart';
import 'package:trendency/providers/saved_tweets_provider.dart';
import 'package:trendency/providers/twitter_post_provider.dart';
import 'package:trendency/providers/user_provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");
  await initializeWebAppView();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => RedditPostProvider()),
    ChangeNotifierProvider(create: (context) => PostProvider()),
    ChangeNotifierProvider(create: (context) => TwitterPostProvider()),
    ChangeNotifierProvider(create: (context) => SavedTweetsProvider()),
    ChangeNotifierProvider(create: (context) => SavedThreadsProvider()),
  ], child: const GetMaterialApp(home: App())));
}

Future<void> initializeWebAppView() async {
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient =
          AndroidServiceWorkerClient();
    }
  }
}
