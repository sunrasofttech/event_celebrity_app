import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_user/UI/DashboardScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../Utility/const.dart';

class InAppWebViewScreen extends StatefulWidget {
  const InAppWebViewScreen({super.key, required this.Url});
  final String Url;
  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewState();
}

class _InAppWebViewState extends State<InAppWebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  addPayment(String url, String txnId) async {
    log("Upi Address=>$url");
    try {
      // Todo : //upi://pay?pa=$upi&pn=test&am=1&tn=hi&cu=INR
      //Todo Tested : => upi://pay?pa=merchant737120.augp@aubank&pn=test&am=1&tn=hi&cu=INR
      // Test merchant737120.augp@aubank
      await launchPayment(url.toString(), txnId.toString()).whenComplete(() => print("Payment"));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }

  Future launchPayment(String url, String txnId) async {
    //String uid = await pref.getString("key").toString();
    try {
      MethodChannel channel = MethodChannel('upi/tez');
      final result = await channel.invokeMethod('launchUpi', <String, dynamic>{"url": url});
      debugPrint("this is result ----> $result");
      if (result == "Failed") {
        print("Failed Payment=>>>");

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Payment Failed"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(translate("ok")),
                ),
              ],
            );
          },
        );
      }
      ///
      else {
        print("Success Payment=>>>");

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Payment Success"),
              content: Wrap(
                direction: Axis.vertical,
                children: [
                  Text("⌚", style: TextStyle(fontSize: 30)),
                  Text(
                    "पॉईंट अँड होने मे 5 मिनट का समय लग सकता है. कृपया wait करें,"
                    "अगर किसी के पॉईंट add ही नहीं होते तो WhatsApp पर हमें contact करे",
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(translate("ok")),
                ),
              ],
            );
          },
        );
      }
    } catch (e, stk) {
      debugPrint("catch error for url launcher $e, $stk");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Something Went Wrong"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(translate("ok")),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (webViewController != null && await webViewController!.canGoBack()) {
          await webViewController!.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () async {
              // final url = await webViewController?.getUrl();
              // if (url == "${Constants.baseUrl}/app/deposit/sucesspage") {
              //   BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
              //   Navigator.pop(context);
              // }
              if (webViewController != null && await webViewController!.canGoBack()) {
                await webViewController!.goBack();
              } else {
                if (mounted) Navigator.pop(context);
              }
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black38),
          ),
        ),
        body: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri(widget.Url)),
          onWebViewCreated: (controller) async {
            webViewController = controller;
          },
          onLoadStart: (controller, url) async {},
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            Uri uri = navigationAction.request.url!;
            debugPrint(" navigationAction.request.url ---> $uri, ${uri.path}, ${uri.data}");
            if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
              // if (await canLaunchUrl(uri)) {
              //   // Launch the App
              //   await launchUrl(
              //     uri,
              //   );
              //   // and cancel the request
              //   return NavigationActionPolicy.CANCEL;
              // }
            }

            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {
            log("url url url ----------> $url");

            //paytmmp://cash_wallet?pa=9373801163@freecharge&pn=Raj%20
            // softwares&am=301&tid=ATCJk4pZ1735653067&cu=
            // INR&tn=ATCJk4pZ1735653067&tr=ATCJk4pZ1735653067&mc=4722&&sign=
            // AAuN7izDWN5cb8A5scnUiNME+LkZqI2DWgkXlN1McoP6WZABa/KkFTiLvuPRP6/nWK8BPg/rPhb+u4QMrUEX10UsANTDbJaALcSM9b8Wk218X+55T/zOzb7xoiB+BcX8yYuYayELImXJHIgL/c7nkAnHrwUCmbM97nRbCVVRvU0ku3Tr
            // &featuretype=money_transfer

            ///https://payqr.in/payment7/instant-pay/60399f635c35c165816ca4d352208bd2ebc7234c99455ffdb5a4d031151a70ca#
            bool clickedPaytmUpi = url.toString().startsWith("paytmmp://");
            bool clickedPhonePeUpi = url.toString().startsWith("phonepe://");
            bool clickedGoogleUpi = url.toString().startsWith("gpay://");
            bool clickedCredUpi = url.toString().startsWith("credpay://");
            print("---------------->>> LINK :_ $url");
            if (clickedPaytmUpi || clickedPhonePeUpi || clickedGoogleUpi) {
              try {
                if (await canLaunchUrl(url!)) {
                  Navigator.pop(context);
                  await launchUrl(url);
                } else {
                  await controller.goBack();
                }
                await addPayment(url.toString(), "WebTransaction");
              } catch (err, stk) {
                if (controller.canGoBack() == true) await controller.goBack();
                Fluttertoast.showToast(msg: "Can't open application right now");
                print("Catch ERROR ON :-----> $err, ----> $stk");
              }
            } else if (url == "${Constants.baseUrl}/app/deposit/sucesspage" ||
                url == "${Constants.baseUrl}/payment/callbackPayment/subpaisaPayment") {
              Fluttertoast.showToast(msg: "Navigating to home screen");
              await Future.delayed(const Duration(seconds: 1));
              BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DashBoardScreen()), (route) => false);
            }
          },
          onProgressChanged: (controller, progress) {},
          onUpdateVisitedHistory: (controller, url, isReload) {},
          onConsoleMessage: (controller, consoleMessage) {
            print(consoleMessage);
          },
        ),
      ),
    );
  }
}
