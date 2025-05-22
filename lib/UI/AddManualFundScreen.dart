import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:mobi_user/Bloc/DepositListBloc/DepositListBloc.dart';
import 'package:mobi_user/Bloc/InstructionBloc/InstructionBloc.dart';
import 'package:mobi_user/Bloc/InstructionBloc/InstructionEvent.dart';
import 'package:mobi_user/Bloc/InstructionBloc/InstructionState.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingCubit.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingState.dart';
import 'package:mobi_user/Bloc/WalletBloc/AddMoneyBloc/AddMoneyCubit.dart';
import 'package:mobi_user/Bloc/WalletBloc/AddMoneyBloc/AddMoneyState.dart';
import 'package:mobi_user/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import 'package:mobi_user/Utility/CustomFont.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:mobi_user/Utility/const.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Bloc/DepositListBloc/DepositListEvent.dart';

class AddManualFundScreen extends StatefulWidget {
  const AddManualFundScreen({Key? key}) : super(key: key);

  @override
  State<AddManualFundScreen> createState() => _AddManualFundScreenState();
}

class _AddManualFundScreenState extends State<AddManualFundScreen> {
  late TextEditingController _amount;
  final _loading = ValueNotifier(false);
  bool isAutoRechargeSelected = true;
  final PageController _controller = PageController();
  GlobalKey<FormState> addFundKey = GlobalKey<FormState>();

  openwhatsapp(number) async {
    var whatsapp = number;
    var whatsappURl_android = "whatsapp://send?phone=" + whatsapp + "&text=hello";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatappURL_ios))) {
        await launchUrl(Uri.parse(whatappURL_ios));
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

        _amount.clear();
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

        _amount.clear();
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
      /* context.read<AddMoneyCubit>().addWalletMoney(
        uid: uid,
        merchantTxnId: txnId,
        paymentStatus:"pending",
      );*/
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong")));
    }
  }

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

  Future<void> popupDepositBanner(BuildContext context) async {
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
                const Text("Important Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Lottie.asset("asset/video/imp_alert.json", width: 50, height: 50),
                const SizedBox(height: 16),
                BlocBuilder<InstructionBloc, InstructionState>(
                  builder: (context, state) {
                    if (state is InstructionLoadedState) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 400, // Adjust maxHeight as needed
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.model.data!.length,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Text(
                              "${state.model.data![index].message.toString()}",
                              textAlign: TextAlign.justify,
                              style: blackStyle.copyWith(fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel", style: TextStyle(color: Colors.red))),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Ok", style: TextStyle(color: Colors.green)),
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

  @override
  void initState() {
    context.read<DepositListBloc>().add(DepositListDataEvent());
    BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());

    context.read<SettingCubit>().getSettingsApiCall();
    _amount = TextEditingController();
    /* Provider.of<CheckUpi>(context, listen: false).getUpi();*/
    context.read<InstructionBloc>().add(FetchInstructionEvent("deposit"));
    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (c) => false);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(translate("add_manual_funds")),
          flexibleSpace: Container(decoration: blueBoxDecoration()),

          backgroundColor: Colors.transparent,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          child: BlocListener<InstructionBloc, InstructionState>(
            listener: (context, state) async {
              // if (state is InstructionLoadedState) {
              //   await popupDepositBanner(context);
              // }
            },
            child: BlocConsumer<AddMoneyCubit, AddMoneyState>(
              listener: (context, moneyState) {
                if (moneyState is AddMoneyLoadedState) {
                  Fluttertoast.showToast(msg: moneyState.message);
                  context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
                }

                if (moneyState is AddMoneyErrState) {
                  Fluttertoast.showToast(msg: moneyState.error);
                }
              },
              builder: (context, moneyState) {
                return BlocBuilder<SettingCubit, SettingState>(
                  builder: (context, settingsState) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
                      },
                      child: ListView(
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: Text(translate("current_balance"), style: blackStyle.copyWith(fontWeight: FontWeight.bold, color: primaryColor)),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(35),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: onlyShadow()),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("asset/icons/purse 1.png", height: 50),
                                const SizedBox(height: 12),
                                BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
                                  builder: (context, state) {
                                    if (state is UserProfileFetchedState) {
                                      return Text(
                                        "Rs.${state.user.data?.balance ?? "0"}",
                                        style: whiteStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: playColor),
                                      );
                                    }
                                    return Text("Rs.0", style: whiteStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: playColor));
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                translate("welcome_to_app", args: {"appName": appName}),
                                style: blackStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(2),
                            child: BlocBuilder<SettingCubit, SettingState>(
                              builder: (context, state) {
                                if (state is SettingLoadedState) {
                                  return Wrap(
                                    alignment: WrapAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    direction: Axis.vertical,
                                    children: [
                                      Text(
                                        translate("manual_recharge_note") + "\n",
                                        textAlign: TextAlign.center,
                                        style: blueStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        translate(
                                          "step_instruction",
                                          args: {"step1": state.model.data?[0].step1 ?? "" + "\n", "step2": state.model.data?[0].step2 ?? ""},
                                        ),

                                        textAlign: TextAlign.center,
                                        style: blackStyle.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BlocBuilder<SettingCubit, SettingState>(
                              builder: (context, state) {
                                if (state is SettingLoadedState) {
                                  print("Setting Loaded");
                                  return OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        side: BorderSide(color: Colors.grey.shade300),
                                      ),
                                    ),
                                    icon: Image.asset("asset/icons/whatsapp.png", width: 30, height: 30),
                                    onPressed: () {
                                      openwhatsapp("${state.model.data?[0].whatsappNo}");
                                    },
                                    label: Text("${state.model.data?[0].whatsappNo}"),
                                  );
                                }

                                return Container();
                              },
                            ),
                          ),
                          BlocBuilder<SettingCubit, SettingState>(
                            builder: (context, state) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                                child: DottedBorder(
                                  radius: Radius.circular(20),
                                  dashPattern: [5, 4],
                                  color: Colors.grey.shade400,
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Center(child: Text((state is SettingLoadedState) ? "${state.model.data?[0].upiName}" : "")),
                                    trailing: IconButton(
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(text: (state is SettingLoadedState) ? "${state.model.data?[0].upiName}" : ""),
                                        );
                                      },
                                      icon: Icon(Icons.copy),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(translate("how_to_add_funds"), style: blackStyle),
                                BlocBuilder<SettingCubit, SettingState>(
                                  builder: (context, state) {
                                    return TextButton(
                                      onPressed: () async {
                                        if (state is SettingLoadedState) {
                                          if (!await launchUrl(Uri.parse(state.model.data?[0].videolink ?? ""))) {
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("failed to load url")));
                                            throw Exception('Could not launch ${state.model.data?[0].videolink}');
                                          } else {
                                            await launchUrl(Uri.parse(state.model.data?[0].videolink ?? ""));
                                          }
                                        }
                                      },
                                      child: Text(
                                        translate("click_here"),
                                        style: blackStyle.copyWith(fontSize: 12, decoration: TextDecoration.underline),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          BlocBuilder<SettingCubit, SettingState>(
                            builder: (context, state) {
                              if (state is SettingLoadedState) {
                                return CachedNetworkImage(
                                  width: 250,
                                  height: 250,
                                  imageUrl: "${Constants.baseUrl}${state.model.data?[0].qrImage}",
                                  imageBuilder: (c, image) {
                                    return Container(decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.contain, image: image)));
                                  },
                                  errorWidget: (c, _, i) {
                                    return Center(child: Text(translate("no_image")));
                                  },
                                );
                              }
                              return Container();
                            },
                          ),
                          Text(translate("scan_qr_to_pay"), style: TextStyle(color: Colors.grey[600], letterSpacing: 1.2)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
