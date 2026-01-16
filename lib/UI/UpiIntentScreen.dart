import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_upi_india/flutter_upi_india.dart';
import 'package:http/http.dart' as http;
import 'package:planner_celebrity/Utility/CustomFont.dart';

import '../Utility/const.dart';
import '../main.dart';
import 'MainScreen.dart';

class UPIIntentScreen extends StatefulWidget {
  const UPIIntentScreen({super.key, required this.amount, required this.upiId, required this.upiName});

  final String amount;
  final String upiId;
  final String upiName;

  @override
  State<UPIIntentScreen> createState() => _UPIIntentScreenState();
}

class _UPIIntentScreenState extends State<UPIIntentScreen> {
  String? _upiAddrError;

  List<ApplicationMeta>? _apps;

  @override
  void initState() {
    super.initState();
    debugPrint("-----> upiName: ${widget.upiName}");
    debugPrint("-----> upiId: ${widget.upiId}");
    Future.delayed(Duration(milliseconds: 0), () async {
      _apps = await UpiPay.getInstalledUpiApplications(statusType: UpiApplicationDiscoveryAppStatusType.all);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _callApi(UpiTransactionResponse a) async {
    try {
      var headers = {'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "", 'Content-Type': "application/json"};
      String uid = await pref.getString("key").toString();

      var request = http.Request('POST', Uri.parse(paymentReceiveNewApi));
      request.body = json.encode({
        "userId": uid,
        "merchantTransactionId": a.txnId,
        "paymentStatus": "success",
        "amount": widget.amount,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      final res = await response.stream.bytesToString();
      print("_callApi API  ---> body:- ${request.body} Status code: ${response.statusCode} --> res --- > $res ");
      if (response.statusCode == 200) {
      } else {
        print(response.reasonPhrase);
      }
    } catch (e, s) {
      print(" paymentReceiveNewApi _callApi RESPONSE [catch error]: $e, $s");
    }
  }

  Future<void> _onTap(ApplicationMeta app) async {
    setState(() {
      _upiAddrError = null;
    });

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    if (kDebugMode) {
      print("Starting transaction with id $transactionRef");
    }

    UpiTransactionResponse a = await UpiPay.initiateTransaction(
      amount: widget.amount,
      app: app.upiApplication,
      receiverName: widget.upiName,
      receiverUpiAddress: widget.upiId,
      transactionRef: transactionRef,
      transactionNote: 'UPI Payment',
      // merchantCode: '7372',
    );

    print("This is UPI PAY MENT :-$a, ---------> Status ${a.status.toString()}");
    if (a.status == UpiTransactionStatus.success) {
      _callApi(a);
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Payment Success"),
            content: SizedBox(
              height: 500,
              child: Column(
                children: [
                  Text("⌚", style: TextStyle(fontSize: 30)),
                  Text(
                    "पॉईंट अँड होने मे 5 मिनट का समय लग सकता है. कृपया wait करें,"
                    "अगर किसी के पॉईंट add ही नहीं होते तो WhatsApp पर हमें contact करे",
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                    (route) => false,
                  );
                },
                child: Text(translate("ok")),
              ),
            ],
          );
        },
      );
    } else if (a.status == UpiTransactionStatus.failure) {
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
    } else {
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
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Payment")),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: <Widget>[
            if (_upiAddrError != null) _vpaError(),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(child: Text("Rs.${widget.amount}", style: whiteStyle)),
            ),
            if (Platform.isIOS) _submitButton(),
            Platform.isAndroid ? _androidApps() : _iosApps(),
          ],
        ),
      ),
    );
  }

  Widget _vpaError() {
    return Container(
      margin: EdgeInsets.only(top: 4, left: 12),
      child: Text(_upiAddrError!, style: TextStyle(color: Colors.red)),
    );
  }

  Widget _submitButton() {
    return Container(
      margin: EdgeInsets.only(top: 32),
      child: Row(
        children: <Widget>[
          Expanded(
            child: MaterialButton(
              onPressed: () async => await _onTap(_apps![0]),
              color: Theme.of(context).colorScheme.secondary,
              height: 48,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              child: Text(
                'Initiate Transaction',
                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _androidApps() {
    return Container(
      margin: EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(margin: EdgeInsets.only(bottom: 12), child: Text('Pay Using', style: whiteStyle)),
          if (_apps != null) _appsGrid(_apps!.map((e) => e).toList()),
        ],
      ),
    );
  }

  Widget _iosApps() {
    return Container(
      margin: EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 24),
            child: Text(
              'One of these will be invoked automatically by your phone to '
              'make a payment',
              style: whiteStyle,
            ),
          ),
          Container(margin: EdgeInsets.only(bottom: 12), child: Text('Detected Installed Apps', style: whiteStyle)),
          if (_apps != null) _discoverableAppsGrid(),
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 12),
            child: Text('Other Supported Apps (Cannot detect)', style: whiteStyle),
          ),
          if (_apps != null) _nonDiscoverableAppsGrid(),
        ],
      ),
    );
  }

  Widget _discoverableAppsGrid() {
    List<ApplicationMeta> metaList = [];
    for (var e in _apps!) {
      if (e.upiApplication.discoveryCustomScheme != null) {
        metaList.add(e);
      }
    }
    return _appsGrid(metaList);
  }

  Widget _nonDiscoverableAppsGrid() {
    List<ApplicationMeta> metaList = [];
    for (var e in _apps!) {
      if (e.upiApplication.discoveryCustomScheme == null) {
        metaList.add(e);
      }
    }
    return _appsGrid(metaList);
  }

  Widget _appsGrid(List<ApplicationMeta> apps) {
    if (apps.isEmpty) {
      return Center(child: Text("No UPI APPLICATION FOUND"));
    }
    apps.sort(
      (a, b) => a.upiApplication.getAppName().toLowerCase().compareTo(b.upiApplication.getAppName().toLowerCase()),
    );
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      // childAspectRatio: 1.6,
      physics: NeverScrollableScrollPhysics(),
      children:
          apps
              .map(
                (it) => Material(
                  key: ObjectKey(it.upiApplication),
                  // color: Colors.grey[200],
                  child: InkWell(
                    onTap: Platform.isAndroid ? () async => await _onTap(it) : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        it.iconImage(48),
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          alignment: Alignment.center,
                          child: Text(it.upiApplication.getAppName(), textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

String? _validateUpiAddress(String value) {
  if (value.isEmpty) {
    return 'UPI VPA is required.';
  }
  if (value.split('@').length != 2) {
    return 'Invalid UPI VPA';
  }
  return null;
}
