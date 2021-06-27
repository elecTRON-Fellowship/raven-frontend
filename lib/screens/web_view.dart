import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen(this.url);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  bool wasSuccessful = false;

  @override
  Widget build(BuildContext context) {
    print(widget.url);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.primaryColorDark,
            ),
          ),
        ),
        leading: IconButton(
          color: theme.primaryColorDark,
          onPressed: () {
            Navigator.of(context).pop(wasSuccessful);
          },
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 25.0,
        ),
        centerTitle: true,
      ),
      body: WebView(
        navigationDelegate: (navigation) {
          if (navigation.url.startsWith('https://raven.herokuapp.com/')) {
            setState(() {
              wasSuccessful = true;
            });
          }
          return NavigationDecision.navigate;
        },
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
