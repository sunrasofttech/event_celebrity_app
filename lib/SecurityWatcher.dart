import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_jailbreak_detection_plus/flutter_jailbreak_detection_plus.dart';

class SecurityWatcher with WidgetsBindingObserver {
  static final SecurityWatcher _instance = SecurityWatcher._internal();
  factory SecurityWatcher() => _instance;
  SecurityWatcher._internal();

  Timer? _timer;
  dynamic securityKit;

  // Counter for consecutive detections to avoid false positives
  int _detectionCount = 0;
  static const int _detectionThreshold = 4; // number of consecutive checks before force close

  void startWatching(dynamic securityKitInstance) {
    securityKit = securityKitInstance;
    WidgetsBinding.instance.addObserver(this);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 7), (_) => _check());
  }

  void stopWatching() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _check();
    }
  }

  Future<void> _check() async {
    if (securityKit != null) {
      try {
        final s = await securityKit.getDeviceSecurityStatus();
        final hasProxy = await securityKit.hasProxySettings();
        final hasVPN = await securityKit.hasVPNConnection();
        // final rootedCheck = (await RootCheckerPlus.isRootChecker()) ?? false;
        // bool jailbroken = await FlutterJailbreakDetectionPlus.jailbroken;
        // bool developerMode = await FlutterJailbreakDetectionPlus.developerMode;

        // log(
        //   "Security Check => kDebugMode:$kDebugMode -- proxy:$hasProxy vpn:$hasVPN jb:$jailbroken dev:$developerMode isSecure:${s.isSecure} sProxy:${s.hasProxy} ssl:${s.isSSLValid}",
        // );

        // if (kDebugMode) {
        //   // ✅ Immediate exit for permanent threats
        //   if (jailbroken) {
        //     log(
        //       "Permanent threat detected — closing app immediately jailbroken:$jailbroken, developerMode:$developerMode ",
        //     );
        //     await _forceCloseApp();
        //     return;
        //   }
        // } else {
        //   // ✅ Immediate exit for permanent threats
        //   if (jailbroken || developerMode) {
        //     log(
        //       "Permanent threat detected — closing app immediately jailbroken:$jailbroken, developerMode:$developerMode ",
        //     );
        //     await _forceCloseApp();
        //     return;
        //   }
        // }

        // ✅ Only consider network threats for threshold
        bool networkThreat = false;
        int threatScore = 0;

        // if ((hasProxy && s.hasProxy)) {
        //   // require both to be true
        //   threatScore++;
        // }
        // if (hasVPN) threatScore++;
        // if (!s.isSSLValid) threatScore++;
        // if (!s.isSecure) threatScore++;
        //
        // networkThreat = threatScore >= 2;
        //
        // if (networkThreat) {
        //   _detectionCount++;
        //   log("Network Threat Count: $_detectionCount / $_detectionThreshold");
        //   if (_detectionCount >= _detectionThreshold) {
        //     log("Network threat confirmed — force closing app...");
        //     await _forceCloseApp();
        //   }
        // } else {
        //   _detectionCount = 0; // reset on safe check
        // }
      } catch (e) {
        log("Security check error: $e");
      }
    }
  }

  Future<void> _forceCloseApp() async {
    const _channel = MethodChannel('app/control');
    try {
      await _channel.invokeMethod('forceClose');
    } catch (e) {
      log("Native force close failed: $e");
    }
    SystemNavigator.pop();
    exit(0);
  }
}
