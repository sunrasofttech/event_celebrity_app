import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobi_user/Bloc/AccountBloc/AccountCubit.dart';
import 'package:mobi_user/Bloc/Auth/LoginBloc/LoginCubit.dart';
import 'package:mobi_user/Bloc/Auth/RegisterBloc/RegisterCubit.dart';
import 'package:mobi_user/Bloc/BannerBloc/BannerCubit.dart';
import 'package:mobi_user/Bloc/BidHistoryBloc/BidHistoryCubit.dart';
import 'package:mobi_user/Bloc/BidSelectorBloc/BidSelectorBloc.dart';
import 'package:mobi_user/Bloc/CheckBankBloc/CheckBankCubit.dart';
import 'package:mobi_user/Bloc/DepositListBloc/DepositListBloc.dart';
import 'package:mobi_user/Bloc/EditProfileBloc/EditProfileBloc.dart';
import 'package:mobi_user/Bloc/GameRateBloc/GameRateCubit.dart';
import 'package:mobi_user/Bloc/InstructionBloc/InstructionBloc.dart';
import 'package:mobi_user/Bloc/NotificationBloc/NotificationCubit.dart';
import 'package:mobi_user/Bloc/PanaBloc/PanaBloc.dart';
import 'package:mobi_user/Bloc/PattiListBloc/PattiListBloc.dart';
import 'package:mobi_user/Bloc/PaymentBloc/PaymentBloc.dart';
import 'package:mobi_user/Bloc/PopupBloc/PopupBloc.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingCubit.dart';
import 'package:mobi_user/Bloc/SuggestionListBloc/SuggestionListBloc.dart';
import 'package:mobi_user/Bloc/WalletBloc/AddMoneyBloc/AddMoneyCubit.dart';
import 'package:mobi_user/Bloc/bidBloc/bidBloc.dart';
import 'package:mobi_user/Bloc/changePassword/changeBloc.dart';
import 'package:mobi_user/Bloc/gameType/gameTypeBloc.dart';
import 'package:mobi_user/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import 'package:mobi_user/Bloc/winHistory/win_history_bloc.dart';
import 'package:mobi_user/Repository/repository.dart';
import 'package:mobi_user/UI/SplashScreen.dart';
import 'package:mobi_user/Utility/AppTheme.dart';
import 'package:mobi_user/Utility/CustomFont.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Bloc/CheckUserExistBloc/CheckUserExistCubit.dart';
import 'Bloc/GetPhoneNumberBloc/GetPhoneNumberCubit.dart';
import 'Bloc/HomeTextBloc/HomeTextBloc.dart';
import 'Bloc/LogOutCubit/LogOutCubit.dart';
import 'Bloc/MarketBloc/MarketCubit.dart';
import 'Bloc/OddEvenBloc/OddEvenBloc.dart';
import 'Bloc/PanaByAnkBloc/PanaByAnkBloc.dart';
import 'Bloc/RedJodiBloc/RedJodiBloc.dart';
import 'Bloc/ReferCubit/ReferCubit.dart';
import 'Bloc/SendOtpBloc/sendotp_cubit.dart';
import 'Bloc/subscription_bloc/subscription_cubit.dart';
import 'Bloc/withdrwaDetails/withdraw_details_bloc.dart';
import 'Utility/CustomNotification.dart';
import 'Utility/const.dart';

Repository repository = Repository();
late SharedPreferences pref;
Future<void> backgroundHandler(RemoteMessage event) async {
  await Firebase.initializeApp(options: _firebaseOptions());
  debugPrint("Remote Message:${event.data}");

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log("Message token");
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);

      //print(message.notification!.android!.count);
      FirebaseMessaging.instance.getToken().then((token) {
        log("Device Token: $token");
      });
    }
  });
}

//TODO: Change This For Cloning
FirebaseOptions _firebaseOptions() {
  return FirebaseOptions(
    apiKey: "AIzaSyAMqwGlgEjFYjx6ewIjYYRgvPyxoTmkOh0",
    appId: "1:157751959487:android:ed69f7a9c60a3970f98b0a",
    messagingSenderId: "157751959487",
    projectId: "mobi-c6301",
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();
  CustomNotification().init();
  // await dotenv.load(fileName: "asset/prod.env");
  try {
    await Firebase.initializeApp(options: _firebaseOptions()).then((value) => log("Firebase Connected"));
    await FirebaseMessaging.instance.subscribeToTopic("all");
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      print(value);
      print("object called");
      if (value != null) {
        backgroundHandler(value);
      }
    });
    FirebaseMessaging.onMessage.listen((event) {
      log("Listen Message=>${event.data}");
      RemoteNotification? notification = event.notification;
      AndroidNotification? android = event.notification?.android;
      if (notification != null && android != null) {
        FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);
        CustomNotification().createNotification(event.notification!.title.toString(), event.notification!.body.toString());
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
    FirebaseMessaging.instance.getToken().then((value) async {
      log("Device FCM Token ${value}");
      if (value != null && value.toString().isNotEmpty) {
        await pref.setString(sharedPrefFCMTokenKey, value);
      }
    });
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    log("UserId=> ${pref.getString("key")}");
    log("Firebase FCM token => ${pref.getString(sharedPrefFCMTokenKey)}");
    log("Firebase API token => ${pref.getString(sharedPrefAPITokenKey)}");
  } catch (err) {
    debugPrint("Catch Error $err");
  }

  final savedLocale = pref.getString('selected_locale') ?? 'en_US';
  final delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: ['bn_IN', 'pa_IN', 'en_US', 'mr_IN', 'hi_IN', 'ta_IN', 'te_IN', 'gu_IN', 'kn_IN'],
    basePath: 'asset/Translation/',
  );
  delegate.changeLocale(Locale(savedLocale.split('_')[0], savedLocale.split('_')[1]));
  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SendOtpCubit()),
          BlocProvider(create: (context) => GetSubscriptionsCubit()),
          // BlocProvider(create: (context) => NetworkBloc()..add((NetworkObserve()))),
          BlocProvider(create: (context) => BidBloc()),
          BlocProvider(create: (context) => LoginCubit()),
          BlocProvider(create: (context) => RegisterCubit()),
          BlocProvider(create: (context) => SettingCubit()),
          BlocProvider(create: (context) => MarketCubit()),
          BlocProvider(create: (context) => BannerCubit()),
          BlocProvider(create: (context) => AddMoneyCubit()),
          BlocProvider(create: (context) => GetPhoneNumberCubit()),
          BlocProvider(create: (context) => CheckUserCubit()),
          /* ChangeNotifierProvider(create: (context) => CheckUpi()),*/
          BlocProvider(create: (context) => UserProfileBlocBloc()),
          BlocProvider(create: (context) => CheckBankCubit()),
          BlocProvider(create: (context) => WithdrawDetailsBloc()),
          BlocProvider(create: (context) => GameTypeBloc()),
          BlocProvider(create: (context) => NotificationCubit()),
          BlocProvider(create: (context) => ChangePasswordBloc()),
          BlocProvider(create: (context) => BidHistoryCubit()),
          /*This is Fund History below BlocProvider Account Cubit*/
          BlocProvider(create: (context) => AccountCubit()),
          BlocProvider(create: (context) => GameRateCubit()),
          BlocProvider(create: (context) => ReferCubit()),
          BlocProvider(create: (context) => SuggestionListBloc()),
          BlocProvider(create: (context) => WinHistoryBloc()),
          BlocProvider(create: (context) => BidSelectorBloc()),
          BlocProvider(create: (context) => EditProfileBloc()),
          BlocProvider(create: (context) => PopupBloc()),
          BlocProvider(create: (context) => PanaBloc()),
          BlocProvider(create: (context) => PanaByAnkBloc()),
          BlocProvider(create: (context) => RedJodiBloc()),
          BlocProvider(create: (context) => OddEvenBloc()),
          BlocProvider(create: (context) => PattiListBloc()),
          BlocProvider(create: (context) => InstructionBloc()),
          BlocProvider(create: (context) => DepositListBloc()),
          BlocProvider(create: (context) => PaymentBloc()),
          BlocProvider(create: (context) => HomeTextBloc()),
          BlocProvider(create: (context) => LogOutCubit()),
          /*  BlocProvider(create: (context) => CheckOpenCloseTimeCubit()),*/
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
            fontFamily: GoogleFonts.poppins().fontFamily,
            drawerTheme: const DrawerThemeData(shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            cardTheme: CardTheme(elevation: 10, shadowColor: Colors.white, surfaceTintColor: Colors.white, color: Colors.white),
            elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(elevation: 20, shadowColor: Colors.grey)),
            appBarTheme: AppBarTheme(backgroundColor: lightBlueColor, titleTextStyle: whiteStyle, iconTheme: IconThemeData(color: Colors.white)),
            splashColor: Colors.transparent,
            iconTheme: IconThemeData(color: primaryColor),
            radioTheme: RadioThemeData(fillColor: MaterialStateColor.resolveWith((states) => maroonColor)),
            switchTheme: SwitchThemeData(
              trackColor: MaterialStateColor.resolveWith((states) => Color(0xff007DFF)),
              thumbColor: MaterialStateColor.resolveWith((states) => Colors.black),
              trackOutlineColor: MaterialStateColor.resolveWith((states) => Colors.white),
            ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: EdgeInsets.symmetric(horizontal: 40),
              border: OutlineInputBorder(gapPadding: 20, borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppTheme().appColor)),
              enabledBorder: OutlineInputBorder(
                gapPadding: 20,
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppTheme().appColor),
              ),
              focusedBorder: OutlineInputBorder(
                gapPadding: 20,
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppTheme().appColor),
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
