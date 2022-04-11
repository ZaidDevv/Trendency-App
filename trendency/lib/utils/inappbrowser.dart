import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:trendency/widgets/trendency_app_bar.dart';

class TrendencyBrowser extends StatefulWidget {
  final String url;

  TrendencyBrowser({Key? key, required this.url}) : super(key: key);

  @override
  State<TrendencyBrowser> createState() => _TrendencyBrowserState();
}

class _TrendencyBrowserState extends State<TrendencyBrowser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TrendencyAppBar(
        color: Colors.white,
        height: 40,
      ),
      body: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(widget.url))),
    );
  }
}
