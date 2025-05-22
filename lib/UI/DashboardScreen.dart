import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:apk_installer/apk_installer.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:mobi_user/Bloc/HomeTextBloc/HomeTextBloc.dart';
import 'package:mobi_user/Bloc/HomeTextBloc/HomeTextEvent.dart';
import 'package:mobi_user/Bloc/LogOutCubit/LogOutCubit.dart';
import 'package:mobi_user/Bloc/MarketBloc/MarketCubit.dart';
import 'package:mobi_user/Bloc/MarketBloc/MarketState.dart';
import 'package:mobi_user/UI/AddFundScreen.dart';
import 'package:mobi_user/UI/UnAuthorizedScreen.dart';
import 'package:mobi_user/Utility/CustomFont.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:mobi_user/Utility/const.dart';
import 'package:mobi_user/main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';
import 'package:zo_animated_border/widget/zo_snake_border.dart';

import '../Bloc/HomeTextBloc/HomeTextState.dart';
import '../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../Utility/BidCloseAlert.dart';
import '../Utility/InternetScreen.dart';
import '../Utility/blinking_text.dart';
import '../Utility/web_view.dart';
import '../Widget/DrawerWidget.dart';
import 'HarmfulAppsScreen.dart';
import 'KalyanDashBoard/bet/kalyan_dashboard_screen.dart';
import 'StarLineScreen.dart';
import 'UI_new/WelcomeScreen.dart';
import 'WithDrawScreen.dart';

Color parseColor(String? colorString) {
  try {
    if (colorString == null || colorString.isEmpty) return Colors.white;
    return Color(int.parse(colorString));
  } catch (e) {
    return Colors.white;
  }
}

Future<void> sendDeviceInfo(BuildContext context, String lngCode) async {
  try {
    // Get installed apps
    List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);
    List<Map<String, String>> installedApps =
        apps.map((app) {
          return {"app_name": app.name ?? "", "package_name": app.packageName ?? ""};
        }).toList();

    // Get device info
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo android = await deviceInfo.androidInfo;

    // Build request body
    Map<String, dynamic> requestBody = {
      "installed_app": installedApps,
      "device_name": android.device,
      "product": android.product,
      "manufacturer": android.manufacturer,
      "model": android.model,
      "device": android.device,
      "brand": android.brand,
      "hardware": android.hardware,
      "lngCode": lngCode,
    };

    log("request body:- $requestBody");
    // API endpoint
    String url = "${Constants.baseUrl}/app/user/save-deviceinfo"; // change this to actual domain if needed

    var headers = {'Authorization': pref.getString(sharedPrefAPITokenKey) ?? "", 'Content-Type': "application/json"};
    // Send POST request
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(requestBody));
    fetchHarmfulAppsAndShow(context);
    log("Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
  } catch (e) {
    log("Error sending device info: $e");
  }
}

///
Future<void> fetchHarmfulAppsAndShow(BuildContext context) async {
  String uid = await pref.getString("key").toString();
  final url = Uri.parse('${Constants.baseUrl}/app/get-alert/$uid');
  final _url = Uri.parse('${checkAppApiUrl}/$uid');

  try {
    final response = await http.post(_url, headers: {'authorization': pref.getString(sharedPrefAPITokenKey) ?? ""});
    log("fetchHarmfulAppsAndShow RESPONSEEEE ------->>>> ${response.body}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> apps = data['apps'] ?? [];

      if (apps.isEmpty) return;

      // final List<String> appPackageNames = apps.map((e) => e['package_name'].toString()).toSet().toList();

      // Build a list of maps: {package_name, desc}
      final List<Map<String, String>> appPackageNames =
          apps.map((e) {
            return {
              'package_name': e['package_name'].toString(),
              'app_name': e['app_name'].toString(),
              'app_logo': e['app_logo'].toString(),
              'app_desc': (e['app_desc']?.toString()?.isNotEmpty ?? false) ? e['app_desc'].toString() : 'We found security issues in the below app',
            };
          }).toList();
      showDialog(context: context, barrierDismissible: false, builder: (context) => HarmfulAppsDialog(appPackageNames: appPackageNames));
    } else {
      print("API error: ${response.statusCode}");
    }
  } catch (e) {
    print("Failed to fetch harmful apps: $e");
  }
}

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> with WidgetsBindingObserver {
  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          barrierDismissible: false, // Prevents closing on tap outside
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Header with Background Color
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: primaryColor, // Header background color
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Center(child: Text(translate("quit"), style: TextStyle(fontSize: 18, color: whiteColor, fontWeight: FontWeight.bold))),
                    ),
                    const SizedBox(height: 12),

                    /// Icon
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.teal, width: 2)),
                      child: Icon(Icons.directions_run, size: 50, color: Colors.black),
                    ),
                    const SizedBox(height: 16),

                    /// Message
                    Text(translate("quit_confirmation"), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center),
                    const SizedBox(height: 20),

                    /// Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// No Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor, // Button color
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(translate("no"), style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold)),
                        ),

                        /// Yes Button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close Dialog
                            // Perform Quit Action
                            if (Platform.isAndroid) {
                              exit(0);
                            } else {
                              Navigator.of(context).pop(true); //Will exit the App
                            }
                          },
                          child: Text(translate("yes"), style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ) ??
        false;
  }

  ValueNotifier<double> downloadProgress = ValueNotifier(0);
  int activeIndex = 0;
  bool fetchDataCalled = false;

  StreamSubscription<InternetStatus>? subscription;
  ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  checkInternetConnection() {
    subscription = InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (status == InternetStatus.connected) {
        print('Connected to the internet');
        if (!fetchDataCalled) fetchData();
        if (Navigator.canPop(context)) {
          debugPrint("CAN POPPPPPPPPPPPPP");
          Navigator.of(context).pop(); // Close the dialog
        }
      } else {
        print('Disconnected from the internet');
        setState(() {});
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (context) => Dialog(
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: InternetScreen(
                    onClose: () {
                      fetchData(); // Your retry logic
                    },
                  ),
                ),
              ),
        );
      }
    });
  }

  fetchData() async {
    fetchDataCalled = true;
    String uid = await pref.getString("key").toString();
    context.read<MarketCubit>().getMarkets(uid);
    BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());

    context.read<HomeTextBloc>().add(FetchHomeTextEvent());
    /*context.read<BannerCubit>().fetchBanner();*/
  }

  String formatTime(TimeOfDay selectedtime) {
    DateTime tempdate = DateFormat.Hms().parse(selectedtime.hour.toString() + ":" + selectedtime.minute.toString() + ":" + '0' + ":" + '0');
    var dateformat = DateFormat("h:mm a");
    return (dateformat.format(tempdate));
  }

  openWhatsapp(num) async {
    var state = context.read<UserProfileBlocBloc>().state;
    if (state is UserProfileFetchedState) {
      var number = num.toString().replaceAll("+91", "");
      var whatsapp = "+91$number";
      var whatsappURl_android =
          "whatsapp://send?phone=" + whatsapp + "&text=Username - ${state.user.data?.name} \n Mobile - ${state.user.data?.mobile}";
      var whatsappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("Username - ${state.user.data?.name} \n Mobile - ${state.user.data?.mobile}")}";
      if (Platform.isIOS) {
        // for iOS phone only
        if (await canLaunchUrl(Uri.parse(whatsappURL_ios))) {
          await launchUrl(Uri.parse(whatsappURL_ios));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
        }
      } else {
        // android , web
        if (await canLaunchUrl(Uri.parse(whatsappURl_android))) {
          await launchUrl((Uri.parse(whatsappURl_android)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
        }
      }
    }
  }

  openCall(number) async {
    var state = context.read<UserProfileBlocBloc>().state;
    if (state is UserProfileFetchedState) {
      var whatsapp = number;
      var whatsappURl_android = "whatsapp://send?phone=" + whatsapp + "&text=I am trouble with update latest version could you please help me";
      var whatsappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("I am trouble with update latest version could you please help me")}";
      if (Platform.isIOS) {
        // for iOS phone only
        if (await canLaunchUrl(Uri.parse(whatsappURL_ios))) {
          await launchUrl(Uri.parse(whatsappURL_ios));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
        }
      } else {
        // android , web
        if (await canLaunchUrl(Uri.parse(whatsappURl_android))) {
          await launchUrl((Uri.parse(whatsappURl_android)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
        }
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Timer? timer;

  Future<void> _showAlertDialog(String img) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        timer = Timer.periodic(Duration(seconds: 5), (timer) {
          Navigator.of(context).pop();
        });
        return Dialog(
          child: new Container(
            height: 600.0,
            width: 400,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Align(alignment: Alignment.center, child: Image.network("$img", fit: BoxFit.fill)),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      timer!.cancel();
    });
  }

  openTelegram(String link) async {
    var url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
        webOnlyWindowName: "dpbosspro",
        webViewConfiguration: const WebViewConfiguration(headers: <String, String>{'User-Agent': 'Telegram'}),
      );
    }
  }

  @override
  void initState() {
    checkInternetConnection();
    context.read<MarketCubit>().emitLoading();
    fetchData();
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var lngCode = localizationDelegate.currentLocale.languageCode;
    sendDeviceInfo(context, lngCode);

    _scrollController.addListener(() {
      if (_scrollController.offset > 50 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
        });
      } else if (_scrollController.offset <= 50 && _isScrolled) {
        setState(() {
          _isScrolled = false;
        });
      }
    });

    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (ModalRoute.of(context)?.isCurrent == true) {
      if (state == AppLifecycleState.paused || state == AppLifecycleState.resumed) {
        fetchData();
      }
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void didChangeDependencies() {
    if (ModalRoute.of(context)?.isCurrent == true) {
      fetchData();
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant DashBoardScreen oldWidget) {
    if (ModalRoute.of(context)?.isCurrent == true) {
      fetchData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    downloadProgress.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  ///**************************** APP UPDATE CODE *******************************///

  bool _isDialogShown = false;
  bool _lowBalanceDialogShown = false;

  vibrationsFunc() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(preset: VibrationPreset.singleShortBuzz);
    }
  }

  ///-------------------
  bool _isNewVersionAvailable(String currentVersion, String latestVersion) {
    final currentParts = currentVersion.split('.').map(int.parse).toList();
    final latestParts = latestVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (currentParts.length <= i || currentParts[i] < latestParts[i]) {
        return true;
      } else if (currentParts[i] > latestParts[i]) {
        return false;
      }
    }
    return false;
  }

  void showDownloadDialog(String apkUrl, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Text(translate("downloading_update_title"), style: TextStyle(fontSize: 18)),
            content: ValueListenableBuilder<double>(
              valueListenable: downloadProgress,
              builder: (context, value, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [LinearProgressIndicator(value: value), const SizedBox(height: 10), Text('${(value * 100).toStringAsFixed(1)}%')],
                );
              },
            ),
          ),
    );

    downloadAndInstallApk(apkUrl, downloadProgress, context);
  }

  void promptUpdate(String apkUrl, BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(translate("update_available_title")),
            content: Text(translate("update_available_message")),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(translate("later"))),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showDownloadDialog(apkUrl, context);
                },
                child: Text(translate("update")),
              ),
            ],
          ),
    );
  }

  Future<void> askForStoragePermission(String apkUrl, BuildContext context) async {
    final status = await Permission.manageExternalStorage.status;
    debugPrint("askForStoragePermission askForStoragePermission  askForStoragePermission $status");
    if (status.isDenied || status.isPermanentlyDenied) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(translate("storage_permission"), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Lottie.asset("asset/video/folder.json", width: 50, height: 50),
                    const SizedBox(height: 16),
                    Text(translate("storage_permission_message"), textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black54)),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          final result = await Permission.manageExternalStorage.request();

                          if (result.isGranted) {
                            // continue your flow
                            showDownloadDialog(apkUrl, context);
                          } else {
                            openAppSettings(); // fallback
                          }
                        },
                        child: Text(translate("allow"), style: TextStyle(color: Colors.green)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );
    } else if (status.isGranted) {
      showDownloadDialog(apkUrl, context);
    }
  }

  Future<void> downloadAndInstallApk(String apkUrl, ValueNotifier<double> downloadProgress, BuildContext context) async {
    try {
      // // Get permanent directory
      // final Directory appDocDir = await getApplicationDocumentsDirectory();
      //
      // // Extract file name from URL
      // final fileName = Uri.parse(apkUrl).pathSegments.last;
      //
      // final filePath = '${appDocDir.path}/$fileName';
      // final apkFile = File(filePath);

      // ✅ Request storage permission
      final status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        Navigator.of(context).pop();
        log("Permission denied to access storage. ${status}");
        return;
      }

      // ✅ Get downloads directory
      final directory = Directory('/storage/emulated/0/Download'); // Downloads folder
      final apkName = Uri.parse(apkUrl).pathSegments.last;
      final filePath = '${directory.path}/$apkName';
      final apkFile = File(filePath);
      if (await apkFile.exists()) {
        log('APK already exists at: $filePath');
        if (context.mounted) Navigator.of(context).pop(); // closes download dialog if open
        await _showInstallPrompt(context, filePath);
        return;
      }

      // Start downloading
      final dio = Dio();
      await dio.download(
        apkUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = received / total;
          }
        },
      );

      log('APK downloaded to: $filePath');
      if (context.mounted) {
        Navigator.of(context).pop(); // closes the download alert
      }
      await _showInstallPrompt(context, filePath);
    } catch (e, stk) {
      Navigator.of(context).pop();
      log('Error downloading/installing APK: $e\n$stk');
    }
  }

  Future<void> _showInstallPrompt(BuildContext context, String filePath) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(translate("install_update"), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Lottie.asset("asset/video/update-icon.json", width: 50, height: 50),
                const SizedBox(height: 16),
                Text(translate("update_downloaded"), textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(translate("cancel"), style: TextStyle(color: Colors.red))),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await ApkInstaller.installApk(filePath: filePath);
                      },
                      child: Text(translate("install"), style: TextStyle(color: Colors.green)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _checkVersion(BuildContext context, String latestVersion, String apkUrl) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    log("Current Version: $currentVersion");
    log("Latest Version: $latestVersion");

    if (_isNewVersionAvailable(currentVersion, latestVersion)) {
      log("New version available: $latestVersion");
      await askForStoragePermission(apkUrl, context);

      // promptUpdate(apkUrl, context);
    } else {
      log("App is up-to-date.");
    }
  }

  Future<void> onGameClickFunction(MarketLoadedState marketState, int index) async {
    final marketData = marketState.market.data?[index];

    if (marketData == null) return;

    // Find next adjacent OPEN market name
    String? nextOpenMarketName;
    for (int i = 0; i < marketState.market.data!.length; i++) {
      final nextMarket = marketState.market.data![i];
      log(
        "nextOpenMarketName ----> $nextOpenMarketName ----- ${nextMarket.marketStatus?.toLowerCase()} ------ ${nextMarket.marketStatusToday?.toLowerCase()}",
      );
      if (nextMarket.marketStatus?.toLowerCase() == "open" && nextMarket.marketStatusToday?.toLowerCase() != "close") {
        nextOpenMarketName = nextMarket.marketName;

        break;
      }
    }

    if (marketData.marketStatusToday?.toLowerCase() == "close") {
      await vibrationsFunc();
      BidCloseAlert.showClosedForTodayDialog(
        context,
        message: translate("holiday_message"),
        marketName: nextOpenMarketName != null ? "$nextOpenMarketName" : null,
      );
      Fluttertoast.showToast(msg: translate("cant_place_bid"));
    } else if (marketData.marketStatus?.toLowerCase() == "open") {
      context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());

      Navigator.push(context, MaterialPageRoute(builder: (context) => KalyanDashboard(market: marketState.market, index: index)));
    } else {
      BidCloseAlert.showClosedForTodayDialog(
        context,
        message: translate("betting_closed"),
        marketName: nextOpenMarketName != null ? "$nextOpenMarketName" : null,
      );
      Fluttertoast.showToast(msg: translate("betting_closed"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBlocBloc, UserProfileBlocState>(
      listenWhen: (prev, current) => prev != current,
      listener: (context, state) {
        if (state is UserProfileFetchedState) {
          try {
            print(state.isVersionChanged.toString() + "---s--s-s-s-s-s" + " --=-=-=-=-=-  ${state.user.data?.lowBalanceAmount}");

            if (state.isVersionChanged && !_isDialogShown) {
              _isDialogShown = true;
              _checkVersion(context, state.user.data?.latestVersion ?? "", state.user.data?.apkUrl ?? "");
            }

            // Check for low balance and show alert
            final currentBalance = double.tryParse(state.user.data?.balance?.toString() ?? '0') ?? 0;
            final lowBalanceLimit = double.tryParse(state.user.data?.lowBalanceAmount?.toString() ?? '0') ?? 0;
            print("lowBalanceLimit --=-=-=-=-=-  ${currentBalance} --=-==--=-==- ${lowBalanceLimit}");
            if (currentBalance < lowBalanceLimit && !_lowBalanceDialogShown) {
              _lowBalanceDialogShown = true;
              String? isImage = state.user.data?.isImage;

              showDialog(
                context: context,
                barrierDismissible: true,
                builder:
                    (_) => Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      backgroundColor: Colors.transparent,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final horizontalPadding = screenWidth * 0.1; // 10% of screen width

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background Image
                              isImage == null ? Image.asset('asset/icons/wallet-offer.png') : Image.network(isImage),

                              // Responsive Text (Centered)
                              if (isImage == null)
                                Positioned(
                                  top: constraints.maxHeight * 0.23, // 40% from top
                                  left: constraints.maxWidth * 0.25,
                                  right: constraints.maxWidth * 0.25,
                                  child: Center(
                                    child: Text(
                                      state.user?.data?.lowBalanceAmountText ?? "Your balance is low.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
                                    ),
                                  ),
                                ),

                              // Button Text at Bottom
                              Positioned(
                                bottom: constraints.maxHeight * 0.045,
                                left: horizontalPadding,
                                right: horizontalPadding,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddFundScreen()));
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        "Claim Bonus Now",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 2)],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
              );
            }
          } catch (e) {
            print(state.isVersionChanged.toString() + "---s--s-s-s-s-s" + " state error--> $e");
          }
        }
        // TODO: implement listener
      },
      builder: (context, profileState) {
        return WillPopScope(
          onWillPop: () => _onBackPressed(),
          child: BlocConsumer<MarketCubit, MarketState>(
            listener: (context, marketState) async {
              if (marketState is InValidTokenState) {
                Fluttertoast.showToast(msg: translate("session_expired"));
                final removedKey = await pref.remove("key");
                final removedApiToken = await pref.remove(sharedPrefAPITokenKey);
                debugPrint("removed key: $removedKey, removedApiToken: $removedApiToken");
                context.read<LogOutCubit>().logOutApiCall();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => GetStartedScreen()), (route) => false);
              }
            },
            builder: (context, marketState) {
              print("------------------------------>>>>>>>>> marketState $marketState");
              return Scaffold(
                backgroundColor: whiteColor,
                drawer: const DrawerWidget(),
                appBar: AppBar(
                  backgroundColor: lightBlueColor,
                  automaticallyImplyLeading: false, // Hide default drawer icon
                  titleSpacing: 5,
                  centerTitle: false,
                  title: Row(
                    children: [
                      Builder(
                        builder:
                            (context) => IconButton(
                              icon: Icon(FontAwesomeIcons.barsStaggered),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            ),
                      ),
                      const SizedBox(width: 8),
                      Text(appName, style: whiteStyle),
                    ],
                  ),
                  iconTheme: IconThemeData(color: whiteColor),
                  actions: [
                    (marketState is MarketUnAuthorizedState || marketState is MarketLoadingState)
                        ? const SizedBox()
                        : Container(
                          padding: const EdgeInsets.all(4.0),
                          margin: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: whiteColor, width: 1)),
                              backgroundColor: Colors.transparent,
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddFundScreen()));
                            },
                            label: BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
                              builder: (context, state) {
                                if (state is UserProfileFetchedState) {
                                  return Text("${state.user.data?.balance ?? "0"}", style: whiteStyle.copyWith(fontSize: 14));
                                }
                                return Text("0", style: whiteStyle.copyWith(fontSize: 14));
                              },
                            ),
                            icon: Icon(Icons.account_balance_wallet, color: whiteColor),
                          ),
                        ),
                  ],
                ),
                body:
                    (marketState is MarketLoadingState)
                        ? Center(child: CircularProgressIndicator(color: blackColor))
                        : RefreshIndicator(
                          onRefresh: () async {
                            fetchData();
                          },
                          child:
                              (marketState is MarketLoadingState)
                                  ? const SizedBox()
                                  : Column(
                                    children: [
                                      Container(
                                        decoration: blueBoxDecoration(),
                                        child: Column(
                                          children: [
                                            BlocBuilder<HomeTextBloc, HomeTextState>(
                                              builder: (context, state) {
                                                if (state is HomeTextLoadedState) {
                                                  return Container(
                                                    width: MediaQuery.sizeOf(context).width,
                                                    height: 35,
                                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          (state.model.type != null && state.model.type == "result") ? const Color(0xFFF6F9FC) : null,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),

                                                    child: ZoSnakeBorder(
                                                      duration: 6,
                                                      glowOpacity: 0,
                                                      snakeHeadColor:
                                                          (state.model.type != null && state.model.type == "result")
                                                              ? Colors.red
                                                              : Colors.transparent,
                                                      snakeTailColor:
                                                          (state.model.type != null && state.model.type == "result")
                                                              ? Colors.blue
                                                              : Colors.transparent,
                                                      snakeTrackColor:
                                                          (state.model.type != null && state.model.type == "result") ? playColor : Colors.transparent,
                                                      borderWidth: (state.model.type != null && state.model.type == "result") ? 2 : 0,
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Padding(
                                                        padding: EdgeInsets.all(5),
                                                        child:
                                                            (state.model.type != null && state.model.type == "result")
                                                                ? Text(
                                                                  "${state.model.homeText != null && state.model.homeText!.isNotEmpty ? state.model.homeText! : "$appName Welcomes You"}",
                                                                  style: blackStyle.copyWith(fontSize: 14, color: Colors.orange),
                                                                )
                                                                : Marquee(
                                                                  text:
                                                                      "${state.model.homeText != null && state.model.homeText!.isNotEmpty ? state.model.homeText! : "$appName Welcomes You"}",
                                                                  scrollAxis: Axis.horizontal,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  blankSpace: 10,
                                                                  velocity: 100,
                                                                  numberOfRounds: 100,
                                                                  pauseAfterRound: Duration(seconds: 1),
                                                                  startPadding: 10,
                                                                  accelerationDuration: Duration(seconds: 1),
                                                                  accelerationCurve: Curves.linear,
                                                                  decelerationDuration: Duration(milliseconds: 50),
                                                                  decelerationCurve: Curves.easeOut,
                                                                  style: whiteStyle.copyWith(fontSize: 14),
                                                                ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return Container();
                                              },
                                            ),

                                            if (marketState is MarketLoadedState &&
                                                profileState is UserProfileFetchedState &&
                                                profileState.user.data?.starlineStatus.toString() == "true")
                                              Container(
                                                height: 85,
                                                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const StarLineScreen()));
                                                  },
                                                  child: Stack(
                                                    alignment: Alignment.topCenter,
                                                    children: [
                                                      Container(
                                                        height: 60,
                                                        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
                                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Icon(Icons.play_arrow, color: Colors.white),
                                                            const SizedBox(width: 8),
                                                            Text(
                                                              translate("dashboard.starline"),
                                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // "PLAY NOW" overlapping button
                                                      Positioned(
                                                        bottom: 0,
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(8),
                                                            boxShadow: [
                                                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: Offset(0, 2)),
                                                            ],
                                                          ),
                                                          child: Text(
                                                            translate("dashboard.play_now"),
                                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            if (marketState is MarketLoadedState)
                                              if (profileState is UserProfileFetchedState &&
                                                  profileState.user.data?.starlineStatus.toString() != "true")
                                                const SizedBox(height: 10),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Row(
                                                children: [
                                                  // Add Money Button
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: const Color(0xFFF6F9FC),
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFundScreen()));
                                                      },
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Image.asset('asset/icons/add_wallet.png', width: 24, height: 24),
                                                          const SizedBox(width: 8),
                                                          Flexible(
                                                            child: Text(
                                                              translate("dashboard.add_money"),
                                                              overflow: TextOverflow.ellipsis,
                                                              softWrap: false,
                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: lightTextColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  const SizedBox(width: 12),

                                                  // Withdraw Button
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: const Color(0xFFF6F9FC),
                                                        elevation: 0,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const WithdrawalScreen()));
                                                      },
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Image.asset('asset/icons/withdraw_wallet.png', width: 24, height: 24),
                                                          const SizedBox(width: 8),
                                                          Flexible(
                                                            child: Text(
                                                              translate("dashboard.withdraw"),
                                                              overflow: TextOverflow.ellipsis,
                                                              softWrap: false,
                                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: lightTextColor),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 8),

                                            // ///Call Whatsapp and telegram
                                            // BlocBuilder<SettingCubit, SettingState>(
                                            //   builder: (context, settingState) {
                                            //     return Padding(
                                            //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            //       child: Row(
                                            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //         children: [
                                            //           // Call Button
                                            //           Expanded(
                                            //             child: ElevatedButton.icon(
                                            //               style: ElevatedButton.styleFrom(
                                            //                 backgroundColor: const Color(0xFFF6F9FC), // light background
                                            //                 elevation: 0, // no shadow
                                            //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            //                 padding: const EdgeInsets.symmetric(vertical: 12),
                                            //               ),
                                            //               onPressed: () async {
                                            //                 if (settingState is SettingLoadedState) {
                                            //                   final Uri phoneUri = Uri.parse("tel:${settingState.model.data![0].whatsappNo}");
                                            //                   if (await canLaunchUrl(phoneUri)) {
                                            //                     await launchUrl(phoneUri);
                                            //                   } else {
                                            //                     ScaffoldMessenger.of(
                                            //                       context,
                                            //                     ).showSnackBar(const SnackBar(content: Text("No Valid Url")));
                                            //                   }
                                            //                 }
                                            //               },
                                            //               icon: const Icon(Icons.call, color: lightTextColor), // muted icon color
                                            //               label: const Text(
                                            //                 "Call",
                                            //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: lightTextColor),
                                            //               ),
                                            //             ),
                                            //           ),
                                            //           const SizedBox(width: 8),
                                            //
                                            //           // Whatsapp Button
                                            //           Expanded(
                                            //             child: ElevatedButton.icon(
                                            //               style: ElevatedButton.styleFrom(
                                            //                 backgroundColor: const Color(0xFFF6F9FC),
                                            //                 elevation: 0,
                                            //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            //                 padding: const EdgeInsets.symmetric(vertical: 12),
                                            //               ),
                                            //               onPressed: () {
                                            //                 if (settingState is SettingLoadedState) {
                                            //                   openWhatsapp(settingState.model.data?[0].whatsappNo);
                                            //                 }
                                            //               },
                                            //               icon: const Icon(FontAwesomeIcons.whatsapp, color: lightTextColor),
                                            //               label: const Text(
                                            //                 "Whatsapp",
                                            //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: lightTextColor),
                                            //               ),
                                            //             ),
                                            //           ),
                                            //           const SizedBox(width: 8),
                                            //
                                            //           // Telegram Button
                                            //           Expanded(
                                            //             child: ElevatedButton.icon(
                                            //               style: ElevatedButton.styleFrom(
                                            //                 backgroundColor: const Color(0xFFF6F9FC),
                                            //                 elevation: 0,
                                            //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            //                 padding: const EdgeInsets.symmetric(vertical: 12),
                                            //               ),
                                            //               onPressed: () {
                                            //                 if (settingState is SettingLoadedState) {
                                            //                   final link = settingState.model.data![0].telegramLink;
                                            //                   if (Uri.parse(link ?? "").isAbsolute) {
                                            //                     _launchUrl(link ?? "");
                                            //                   } else {
                                            //                     ScaffoldMessenger.of(
                                            //                       context,
                                            //                     ).showSnackBar(const SnackBar(content: Text("No Valid Url")));
                                            //                   }
                                            //                 }
                                            //               },
                                            //               icon: const Icon(FontAwesomeIcons.telegram, color: lightTextColor),
                                            //               label: const Text(
                                            //                 "Telegram",
                                            //                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: lightTextColor),
                                            //               ),
                                            //             ),
                                            //           ),
                                            //         ],
                                            //       ),
                                            //     );
                                            //   },
                                            // ),
                                            //
                                            // const SizedBox(height: 8),
                                          ],
                                        ),
                                      ),

                                      Builder(
                                        builder: (context) {
                                          if (marketState is MarketUnAuthorizedState) {
                                            print("------->>>> state --->>> $marketState ---${marketState.model.data?.length}");
                                            return Expanded(child: UnAuthorizedScreen());
                                          }

                                          if (marketState is MarketLoadedState) {
                                            return Expanded(
                                              child: RefreshIndicator(
                                                onRefresh: () async {
                                                  context.read<MarketCubit>().emitLoading();
                                                  fetchData();
                                                },
                                                child: ListView.builder(
                                                  physics: const AlwaysScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: marketState.market.data?.length,
                                                  itemBuilder: (context, index) {
                                                    bool isPlayPressed = false;
                                                    bool isChartPressed = false;
                                                    return Column(
                                                      children: [
                                                        if (index == 0) const SizedBox(height: 12),

                                                        ///Main card
                                                        Container(
                                                          margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                                          child: ZoSnakeBorder(
                                                            duration: 6,
                                                            glowOpacity: 0,
                                                            snakeHeadColor: Colors.red,
                                                            snakeTailColor: Colors.blue,
                                                            snakeTrackColor: playColor,
                                                            borderWidth: 1,
                                                            borderRadius: BorderRadius.circular(20),
                                                            child: Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                                              decoration: BoxDecoration(
                                                                color: const Color(0xFFF8F9FB),
                                                                borderRadius: BorderRadius.circular(20),
                                                                border: Border.all(color: Color(0x40B3B3B3), width: 0.5),
                                                                boxShadow: [
                                                                  BoxShadow(color: Colors.white, blurRadius: 6, offset: const Offset(0, 3)),
                                                                  BoxShadow(
                                                                    color: const Color(0x40494949), // 25% opacity black
                                                                    offset: const Offset(6, 6),
                                                                    blurRadius: 6,
                                                                    spreadRadius: 0,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  /// Top Row: Game Title, Result, Icons
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      /// Game Name + Result
                                                                      Expanded(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "${marketState.market.data?[index].marketName}",
                                                                              style: TextStyle(
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Color(0xFF003366),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(height: 10),
                                                                            Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFF5F8FC), // Light grey background
                                                                                borderRadius: BorderRadius.circular(12),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: const Color(0x40474747), // 25% opacity black
                                                                                    offset: const Offset(6, 6),
                                                                                    blurRadius: 15,
                                                                                    spreadRadius: 1,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              child: Text(
                                                                                "${marketState.market.data?[index].result}",
                                                                                style: TextStyle(
                                                                                  fontSize: 18,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Color(0xFFFF8C00),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),

                                                                      /// Icons
                                                                      Expanded(
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  StatefulBuilder(
                                                                                    builder: (context, setInnerState) {
                                                                                      return Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          GestureDetector(
                                                                                            onTapDown: (_) async {
                                                                                              setInnerState(() {
                                                                                                isChartPressed = true;
                                                                                              });
                                                                                            },
                                                                                            onTapUp: (_) async {
                                                                                              setInnerState(() {
                                                                                                isChartPressed = false;
                                                                                              });
                                                                                              // Your button action
                                                                                              print("PANEL CHART tapped for index $index");
                                                                                              log("${marketState.market.data?[index].url}");
                                                                                              if (marketState.market.data?[index].url != null) {
                                                                                                Navigator.push(
                                                                                                  context,
                                                                                                  MaterialPageRoute(
                                                                                                    builder:
                                                                                                        (context) => WebViewApp(
                                                                                                          title:
                                                                                                              marketState
                                                                                                                  .market
                                                                                                                  .data?[index]
                                                                                                                  .marketName ??
                                                                                                              "",
                                                                                                          chatUrl:
                                                                                                              marketState.market.data?[index].url ??
                                                                                                              "",
                                                                                                        ),
                                                                                                  ),
                                                                                                );
                                                                                              } else {
                                                                                                Fluttertoast.showToast(msg: "No URL Found");
                                                                                              }
                                                                                            },
                                                                                            onTapCancel: () {
                                                                                              setInnerState(() {
                                                                                                isChartPressed = false;
                                                                                              });
                                                                                            },
                                                                                            child: AnimatedContainer(
                                                                                              duration: Duration(milliseconds: 100),
                                                                                              padding: const EdgeInsets.all(6),
                                                                                              decoration: BoxDecoration(
                                                                                                color: Colors.white,
                                                                                                shape: BoxShape.circle,

                                                                                                boxShadow:
                                                                                                    isChartPressed
                                                                                                        ? [
                                                                                                          BoxShadow(
                                                                                                            color: Colors.black12,
                                                                                                            blurRadius: 2,
                                                                                                            offset: Offset(3, 1),
                                                                                                          ),
                                                                                                        ]
                                                                                                        : [
                                                                                                          BoxShadow(
                                                                                                            color: const Color(
                                                                                                              0x405E5A5A,
                                                                                                            ), // 25% opacity black
                                                                                                            offset: const Offset(6, 8),
                                                                                                            blurRadius: 12,
                                                                                                            spreadRadius: 2,
                                                                                                          ),
                                                                                                        ],
                                                                                              ),
                                                                                              child: circleIcon(Icons.bar_chart),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                  const SizedBox(height: 4),
                                                                                  Text(
                                                                                    translate("dashboard.panel_chart"),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(fontSize: 12, color: Color(0xFF003366)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 16),
                                                                            Expanded(
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  StatefulBuilder(
                                                                                    builder: (context, setInnerState) {
                                                                                      return Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          GestureDetector(
                                                                                            onTapDown: (_) async {
                                                                                              setInnerState(() {
                                                                                                isPlayPressed = true;
                                                                                              });
                                                                                            },
                                                                                            onTapUp: (_) async {
                                                                                              setInnerState(() {
                                                                                                isPlayPressed = false;
                                                                                              });
                                                                                              // Your button action
                                                                                              log("Play Game tapped for index $index");
                                                                                              await onGameClickFunction(marketState, index);
                                                                                            },
                                                                                            onTapCancel: () {
                                                                                              setInnerState(() {
                                                                                                isPlayPressed = false;
                                                                                              });
                                                                                            },
                                                                                            child: AnimatedContainer(
                                                                                              duration: Duration(milliseconds: 100),
                                                                                              padding: const EdgeInsets.all(6),
                                                                                              decoration: BoxDecoration(
                                                                                                shape: BoxShape.circle,
                                                                                                color: const Color(
                                                                                                  0xFFF5F8FC,
                                                                                                ), // Light grey background

                                                                                                boxShadow:
                                                                                                    isPlayPressed
                                                                                                        ? [
                                                                                                          BoxShadow(
                                                                                                            color: Colors.black12,
                                                                                                            blurRadius: 2,
                                                                                                            offset: Offset(3, 1),
                                                                                                          ),
                                                                                                        ]
                                                                                                        : [
                                                                                                          BoxShadow(
                                                                                                            color: const Color(
                                                                                                              0x405E5A5A,
                                                                                                            ), // 25% opacity black
                                                                                                            offset: const Offset(6, 8),
                                                                                                            blurRadius: 15,
                                                                                                            spreadRadius: 2,
                                                                                                          ),
                                                                                                        ],
                                                                                              ),
                                                                                              child:
                                                                                                  marketState.market.data?[index].marketStatusToday
                                                                                                              .toString() ==
                                                                                                          "close"
                                                                                                      ? disabledCircleIcon(Icons.play_arrow)
                                                                                                      : marketState.market.data?[index].marketStatus
                                                                                                              ?.toLowerCase() ==
                                                                                                          "open"
                                                                                                      ? circleIcon(Icons.play_arrow)
                                                                                                      : disabledCircleIcon(Icons.play_arrow),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                  const SizedBox(height: 4),
                                                                                  Text(
                                                                                    translate("dashboard.play_game"),
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(fontSize: 12, color: Color(0xFF003366)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                  const SizedBox(height: 8),

                                                                  /// Bottom Text
                                                                  Divider(color: lightTextColor),
                                                                  const SizedBox(height: 8),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "${marketState.market.data?[index].opencloseTime}",
                                                                            style: TextStyle(
                                                                              color: primaryColor,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            translate("dashboard.open_time"),
                                                                            style: TextStyle(color: primaryColor, fontSize: 12),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "${marketState.market.data?[index].closeTime}",
                                                                            style: TextStyle(
                                                                              color: primaryColor,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            translate("dashboard.close_time"),
                                                                            style: TextStyle(color: primaryColor, fontSize: 12),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      BlinkingText(
                                                                        status:
                                                                            marketState.market.data?[index].marketStatusToday.toString() == "close"
                                                                                ? "close"
                                                                                : marketState.market.data?[index].marketStatus ?? "",
                                                                      ),
                                                                      // Text(
                                                                      //   marketState.market.data?[index].marketStatusToday.toString() == "close"
                                                                      //       ? "Betting is close for today"
                                                                      //       : marketState.market.data?[index].marketStatus == "OPEN"
                                                                      //       ? "Running"
                                                                      //       : "Betting is close for today",
                                                                      //   style: TextStyle(
                                                                      //     color:
                                                                      //         marketState.market.data?[index].marketStatusToday.toString() == "close"
                                                                      //             ? Colors.redAccent
                                                                      //             : marketState.market.data?[index].marketStatus == "OPEN"
                                                                      //             ? Colors.green
                                                                      //             : Colors.redAccent,
                                                                      //     fontWeight: FontWeight.w600,
                                                                      //     fontSize: 14,
                                                                      //   ),
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        if (index + 1 == marketState.market.data?.length) const SizedBox(height: 30),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            );

                                            /*return Expanded(
                                              child: RefreshIndicator(
                                                onRefresh: () async {
                                                  context.read<MarketCubit>().emitLoading();
                                                  fetchData();
                                                },
                                                child: ListView.builder(
                                                  physics: const AlwaysScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemCount: marketState.market.data?.length,
                                                  itemBuilder: (context, index) {
                                                    return Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap:
                                                              marketState.market.data?[index].marketStatusToday == "close"
                                                                  ? () async {
                                                                    await vibrationsFunc();
                                                                    Fluttertoast.showToast(msg: "can't place bid");
                                                                  }
                                                                  : marketState.market.data?[index].marketStatus == "OPEN"
                                                                  ? () {
                                                                    context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());

                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) => KalyanDashboard(market: marketState.market, index: index),
                                                                      ),
                                                                    );
                                                                  }
                                                                  : () {
                                                                    Fluttertoast.showToast(msg: "Betting is Closed");
                                                                  },
                                                          child: Card(
                                                            color: parseColor(marketState.market.data?[index].color),
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  const SizedBox(width: 5),
                                                                  Container(
                                                                    padding: EdgeInsets.all(2.0),
                                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                                                                    child: IconButton(
                                                                      style: IconButton.styleFrom(padding: EdgeInsets.zero),
                                                                      onPressed: () {
                                                                        log("${marketState.market.data?[index].url}");
                                                                        if (marketState.market.data?[index].url != null) {
                                                                          Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder:
                                                                                  (context) => WebViewApp(
                                                                                    title: marketState.market.data?[index].marketName ?? "",
                                                                                    chatUrl: marketState.market.data?[index].url ?? "",
                                                                                  ),
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          Fluttertoast.showToast(msg: "No URL Found");
                                                                        }
                                                                      },
                                                                      icon: Icon(Icons.bar_chart, color: whiteColor),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 10),
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                      children: [
                                                                        Text(
                                                                          "${marketState.market.data?[index].marketName}",
                                                                          style: blackStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                                                                        ),
                                                                        const SizedBox(height: 4),
                                                                        Text(
                                                                          "${marketState.market.data?[index].result}",
                                                                          style: blueStyle.copyWith(
                                                                            fontSize: 16,
                                                                            color: Colors.red,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 8),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            RichText(
                                                                              text: TextSpan(
                                                                                children: [
                                                                                  TextSpan(
                                                                                    text: "Open Time:\n",
                                                                                    style: blackStyle.copyWith(
                                                                                      fontSize: 12,
                                                                                      color: greyColor,
                                                                                      fontWeight: FontWeight.normal,
                                                                                    ),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: "${marketState.market.data?[index].opencloseTime}",
                                                                                    style: blackStyle.copyWith(
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 20),
                                                                            RichText(
                                                                              textAlign: TextAlign.end,
                                                                              text: TextSpan(
                                                                                children: [
                                                                                  TextSpan(
                                                                                    text: "Close Time:\n",
                                                                                    style: blackStyle.copyWith(
                                                                                      fontSize: 12,
                                                                                      color: greyColor,
                                                                                      fontWeight: FontWeight.normal,
                                                                                    ),
                                                                                  ),
                                                                                  TextSpan(
                                                                                    text: "${marketState.market.data?[index].closeTime}",
                                                                                    style: blackStyle.copyWith(
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 10),
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        marketState.market.data?[index].marketStatusToday.toString() == "close"
                                                                            ? "Closed"
                                                                            : marketState.market.data?[index].marketStatus == "OPEN"
                                                                            ? "Running"
                                                                            : "Closed",
                                                                        style:
                                                                            marketState.market.data?[index].marketStatusToday.toString() == "close"
                                                                                ? redStyle.copyWith(fontSize: 10)
                                                                                : marketState.market.data?[index].marketStatus == "OPEN"
                                                                                ? greenStyle.copyWith(fontSize: 10)
                                                                                : redStyle.copyWith(fontSize: 10),
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          const SizedBox(height: 5),
                                                                          InkWell(
                                                                            child: Icon(
                                                                              Icons.play_circle,
                                                                              size: 50,
                                                                              color:
                                                                                  marketState.market.data?[index].marketStatusToday.toString() ==
                                                                                          "close"
                                                                                      ? greyColor
                                                                                      : marketState.market.data?[index].marketStatus == "OPEN"
                                                                                      ? redColor
                                                                                      : greyColor,
                                                                            ),
                                                                            onTap:
                                                                                marketState.market.data?[index].marketStatusToday == "close"
                                                                                    ? () async {
                                                                                      await vibrationsFunc();
                                                                                      BidCloseAlert.showClosedForTodayDialog(
                                                                                        context,
                                                                                        message: "Today is holiday, Can't Place Bid",
                                                                                        // marketTitle:
                                                                                        //     marketState
                                                                                        //         .market
                                                                                        //         .data?[index]
                                                                                        //         .marketName,
                                                                                        // openBidLastTime:
                                                                                        //     marketState
                                                                                        //         .market
                                                                                        //         .data?[index]
                                                                                        //         .openOpenTime,
                                                                                        // openResultTime:
                                                                                        //     marketState
                                                                                        //         .market
                                                                                        //         .data?[index]
                                                                                        //         .openTime,
                                                                                        // closeBidLastTime:
                                                                                        //     marketState
                                                                                        //         .market
                                                                                        //         .data?[index]
                                                                                        //         .closeCloseTime,
                                                                                        // closeResultTime:
                                                                                        //     marketState
                                                                                        //         .market
                                                                                        //         .data?[index]
                                                                                        //         .closeTime,
                                                                                      );
                                                                                    }
                                                                                    : marketState.market.data?[index].marketStatus == "OPEN"
                                                                                    ? () {
                                                                                      context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
                                                                                      Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(
                                                                                          builder:
                                                                                              (context) => KalyanDashboard(
                                                                                                market: marketState.market,
                                                                                                index: index,
                                                                                              ),
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    : () async {
                                                                                      await vibrationsFunc();
                                                                                      BidCloseAlert.showClosedForTodayDialog(
                                                                                        context,
                                                                                        message: "Closed for Today",
                                                                                        // marketTitle:
                                                                                        //     marketState
                                                                                        //         .market
                                                                                        //         .data?[index]
                                                                                        //         .marketName,
                                                                                        // openBidLastTime:
                                                                                        //     marketState
                                                                                        //         .market
                                                                                        //         .data?[index]
                                                                                        //         .openOpenTime,
                                                                                        // openResultTime:
                                                                                        //     marketState
                                                                                        //         .market
                                                                                        //         .data?[index]
                                                                                        //         .openTime,
                                                                                        // closeBidLastTime:
                                                                                        //     marketState
                                                                                        //         .market
                                                                                        //         .data?[index]
                                                                                        //         .closeCloseTime,
                                                                                        // closeResultTime:
                                                                                        //     marketState
                                                                                        //         .market
                                                                                        //         .data?[index]
                                                                                        //         .closeTime,
                                                                                      );
                                                                                    },
                                                                          ),
                                                                          const SizedBox(height: 5),
                                                                          Text(
                                                                            "Play Game",
                                                                            style: blackStyle.copyWith(
                                                                              fontSize: 12,
                                                                              color: primaryColor,
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(width: 2),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (index + 1 == marketState.market.data?.length) const SizedBox(height: 30),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            );*/
                                          }
                                          return Container();
                                        },
                                      ),
                                    ],
                                  ),
                        ),
              );
            },
          ),
        );
      },
    );
  }
}
