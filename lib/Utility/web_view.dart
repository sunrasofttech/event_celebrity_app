import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewApp extends StatefulWidget {
  final String title;
  final String chatUrl;

  const WebViewApp({super.key, required this.chatUrl, required this.title});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;
  String url = "";
  bool isLoading = true;
  @override
  void initState() {
    url == widget.chatUrl;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (navigation) {
            if (navigation.url != widget.chatUrl) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.chatUrl));
    super.initState();
  }

  Widget _webWidget() {
    if (widget.chatUrl.isEmpty) return const SizedBox();
    try {
      return isLoading
          ? Center(child: CircularProgressIndicator())
          : WebViewWidget(
              controller: controller,
            );
    } catch (err) {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _webWidget(),
    );
  }
}
