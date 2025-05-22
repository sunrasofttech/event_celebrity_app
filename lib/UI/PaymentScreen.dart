import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String url;

  const PaymentScreen({super.key, required this.url});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  WebViewController controller = WebViewController();

  @override
  void initState() {
    // TODO: implement initState
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setNavigationDelegate(
      NavigationDelegate(
        onPageFinished: (_) {
          setState(() {});
        },
        onNavigationRequest: (navigation) {
          if (navigation.url != widget.url) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
    controller.loadRequest(Uri.parse(widget.url));
    controller.addJavaScriptChannel("messageHandler", onMessageReceived: (message) {
      print(message);
      final result = jsonDecode(message.message);
      if (result["status"] == "SUCCESS") {
        print("Success");
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Successful")));
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment failed? please try again later")));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
