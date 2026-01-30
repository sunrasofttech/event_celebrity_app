import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planner_celebrity/Bloc/AccountBloc/AccountCubit.dart';
import 'package:planner_celebrity/Bloc/AppContentsBloc/UserAppContentCubit.dart';
import 'package:planner_celebrity/Bloc/Auth/LoginBloc/LoginCubit.dart';
import 'package:planner_celebrity/Bloc/CheckBankBloc/CheckBankCubit.dart';
import 'package:planner_celebrity/Bloc/EditProfileBloc/EditProfileBloc.dart';
import 'package:planner_celebrity/Bloc/NotificationBloc/NotificationCubit.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingCubit.dart';
import 'package:planner_celebrity/Bloc/SuggestionListBloc/SuggestionListBloc.dart';
import 'package:planner_celebrity/Bloc/WalletBloc/AddMoneyBloc/AddMoneyCubit.dart';
import 'package:planner_celebrity/Bloc/add_gallery_image/add_gallery_images_cubit.dart';
import 'package:planner_celebrity/Bloc/avaibility/get_avalibility/get_avalibility_cubit.dart';
import 'package:planner_celebrity/Bloc/avaibility/set_ava/set_availbilty_cubit.dart';
import 'package:planner_celebrity/Bloc/delete_gallery_image/delete_gallery_image_cubit.dart';
import 'package:planner_celebrity/Bloc/get_all_earing/get_all_earing_cubit.dart';
import 'package:planner_celebrity/Bloc/get_all_events/get_all_events_cubit.dart';
import 'package:planner_celebrity/Bloc/get_dashboard/get_dashboard_cubit.dart';
import 'package:planner_celebrity/Bloc/get_profile/get_profile_cubit.dart';
import 'package:planner_celebrity/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import 'package:planner_celebrity/Repository/repository.dart';
import 'package:planner_celebrity/SecurityWatcher.dart';
import 'package:planner_celebrity/UI/SplashScreen.dart';
import 'package:planner_celebrity/Utility/CustomFont.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:planner_celebrity/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultra_secure_flutter_kit/ultra_secure_flutter_kit.dart';

import 'Bloc/CheckUserExistBloc/CheckUserExistCubit.dart';
import 'Bloc/LogOutCubit/LogOutCubit.dart';
import 'Bloc/ReferCubit/ReferCubit.dart';
import 'Bloc/SendOtpBloc/sendotp_cubit.dart';
import 'Bloc/subscription_bloc/subscription_cubit.dart';
import 'Utility/const.dart';

Repository repository = Repository();
late SharedPreferences pref;
Future<void> backgroundHandler(RemoteMessage event) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("Remote Message:${event.data}");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log("Message token");
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      //print(message.notification!.android!.count);
      FirebaseMessaging.instance.getToken().then((token) {
        log("Device Token: $token");
      });
    }
  });
}

//TODO: Change This For Cloning
// FirebaseOptions _firebaseOptions() {
//   return FirebaseOptions(
//     apiKey: "AIzaSyD8-f4QzysDtRVAaj-LUOZ98SlCx5oofm8",
//     appId: "1:914367922448:android:af4b5915703cdffddca595",
//     messagingSenderId: "914367922448",
//     projectId: "jio7-matka",
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await dotenv.load(fileName: "asset/.env");
  final securityKit = UltraSecureFlutterKit();
  if (kReleaseMode) {
    try {
      final config = SecurityConfig(
        mode: SecurityMode.strict,
        enableScreenshotBlocking: true,
        enableSSLPinning: true,
        enableSecureStorage: true,
        enableMITMDetection: true,
        enableDeveloperModeDetection: true,
        blockOnHighRisk: true,
        sslPinningConfig: SSLPinningConfig(
          mode: SSLPinningMode.strict,
          pinnedPublicKeys: [dotenv.get("KEY")],
        ),
        obfuscationConfig: ObfuscationConfig(
          enableDartObfuscation: true,
          enableStringObfuscation: true,
          enableClassObfuscation: true,
          enableMethodObfuscation: true,
          enableDebugPrintStripping: true,
          enableStackTraceObfuscation: true,
        ),
      );

      await securityKit.initializeSecureMonitor(config);

      // Quick check — if risky, exit or show blocking UI
      final deviceStatus = await securityKit.getDeviceSecurityStatus();
      final hasProxy = await securityKit.hasProxySettings();
      final hasVPN = await securityKit.hasVPNConnection();
      log(
        "DEVICE STATUS isEmulator:- ${deviceStatus.isEmulator}, obsucated ${deviceStatus.isCodeObfuscated},"
        " isSecure ${deviceStatus.isSecure}, riskScore ${deviceStatus.riskScore}, "
        "hasProxy: ${deviceStatus.hasProxy}, isSSLValid: ${deviceStatus.isSSLValid}, ",
      );
      log("has proxy setting: $hasProxy -------- has VPN setting:- $hasVPN");
      if (!deviceStatus.isSecure && config.mode == SecurityMode.strict) {
        // You can programmatically block usage here:
        log('BLOCKEDDDDD');
        return;
      }
    } catch (e, s) {
      // initialization failed — safe fallback
      log('Security kit initialize failed: $e, $s');
    }
  }

  // try {
  //   CustomNotification().init();
  //   await Firebase.initializeApp(options: _firebaseOptions()).then((value) => log("Firebase Connected"));
  //   await FirebaseMessaging.instance.subscribeToTopic("all");
  //   FirebaseMessaging.instance.getInitialMessage().then((value) {
  //     print(value);
  //     print("object called");
  //     if (value != null) {
  //       backgroundHandler(value);
  //     }
  //   });
  //   FirebaseMessaging.onMessage.listen((event) {
  //     log("Listen Message=>${event.data}");
  //     RemoteNotification? notification = event.notification;
  //     AndroidNotification? android = event.notification?.android;
  //     if (notification != null && android != null) {
  //       FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);
  //       CustomNotification().createNotification(
  //         event.notification!.title.toString(),
  //         event.notification!.body.toString(),
  //       );
  //     }
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('A new onMessageOpenedApp event was published!');
  //   });
  //   FirebaseMessaging.instance.getToken().then((value) async {
  //     log("Device FCM Token ${value}");
  //     if (value != null && value.toString().isNotEmpty) {
  //       await pref.setString(sharedPrefFCMTokenKey, value);
  //     }
  //   });
  //   FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  //   log("UserId=> ${pref.getString("key")}");
  //   log("Firebase FCM token => ${pref.getString(sharedPrefFCMTokenKey)}");
  //   log("Firebase API token => ${pref.getString(sharedPrefAPITokenKey)}");
  // } catch (err) {
  //   debugPrint("Catch Error $err");
  // }

  final savedLocale = pref.getString('selected_locale') ?? 'en_US';
  final delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: [
      'bn_IN',
      'pa_IN',
      'en_US',
      'mr_IN',
      'hi_IN',
      'ta_IN',
      'te_IN',
      'gu_IN',
      'kn_IN',
    ],
    basePath: 'asset/Translation/',
  );
  delegate.changeLocale(
    Locale(savedLocale.split('_')[0], savedLocale.split('_')[1]),
  );
  runApp(LocalizedApp(delegate, MyApp(securityKit: securityKit)));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.securityKit});
  final UltraSecureFlutterKit? securityKit;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    if (kReleaseMode) {
      SecurityWatcher().startWatching(widget.securityKit);
    }
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SendOtpCubit()),
          BlocProvider(create: (context) => GetSubscriptionsCubit()),
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => SettingCubit()),
          BlocProvider(create: (context) => AddMoneyCubit()),
          BlocProvider(create: (context) => CheckUserCubit()),
          /* ChangeNotifierProvider(create: (context) => CheckUpi()),*/
          BlocProvider(create: (context) => UserProfileBlocBloc()),
          BlocProvider(create: (context) => CheckBankCubit()),
          BlocProvider(create: (context) => NotificationCubit()),
          BlocProvider(create: (context) => AccountCubit()),
          BlocProvider(create: (context) => ReferCubit()),
          BlocProvider(create: (context) => SuggestionListBloc()),
          BlocProvider(create: (context) => EditProfileBloc()),
          BlocProvider(create: (context) => LogOutCubit()),
          BlocProvider(create: (context) => SetAvailbiltyCubit()),
          BlocProvider(create: (context) => GetAvalibilityCubit()),
          BlocProvider(create: (context) => DeleteGalleryImageCubit()),
          BlocProvider(create: (context) => AddGalleryImagesCubit()),
          BlocProvider(create: (context) => GetDashboardCubit()),
          BlocProvider(create: (context) => GetProfileCubit()),
          BlocProvider(create: (context) => GetUserAppContentCubit()),
          BlocProvider(create: (context) => GetAllEaringCubit()),
          BlocProvider(create: (context) => GetAllEventsCubit()),
        ],
        child: MaterialApp(
          title: appName,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            localizationDelegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          theme: ThemeData(
            fontFamily: GoogleFonts.inter().fontFamily,
            drawerTheme: const DrawerThemeData(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            cardTheme: CardThemeData(
              elevation: 10,
              shadowColor: Colors.white,
              surfaceTintColor: Colors.white,
              color: Colors.white,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 20,
                shadowColor: Colors.grey,
              ),
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              titleTextStyle: whiteStyle,
              iconTheme: IconThemeData(color: Colors.white),
            ),
            splashColor: Colors.transparent,
            scaffoldBackgroundColor: scaffoldBgColor,
            iconTheme: IconThemeData(color: greyColor),
            switchTheme: SwitchThemeData(
              trackColor: MaterialStateColor.resolveWith(
                (states) => primaryColor,
              ),
              thumbColor: MaterialStateColor.resolveWith(
                (states) => Colors.white,
              ),
              trackOutlineColor: MaterialStateColor.resolveWith(
                (states) => Colors.transparent,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(horizontal: 40),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: greyColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: greyColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: primaryColor),
              ),
            ),
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
