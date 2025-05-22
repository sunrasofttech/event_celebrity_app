import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:mobi_user/Bloc/DepositListBloc/DepositListBloc.dart';
import 'package:mobi_user/Bloc/DepositListBloc/DepositListState.dart';
import 'package:mobi_user/Bloc/InstructionBloc/InstructionBloc.dart';
import 'package:mobi_user/Bloc/InstructionBloc/InstructionEvent.dart';
import 'package:mobi_user/Bloc/InstructionBloc/InstructionState.dart';
import 'package:mobi_user/Bloc/PaymentBloc/PaymentBloc.dart';
import 'package:mobi_user/Bloc/PaymentBloc/PaymentState.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingCubit.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingState.dart';
import 'package:mobi_user/Bloc/WalletBloc/AddMoneyBloc/AddMoneyCubit.dart';
import 'package:mobi_user/Bloc/WalletBloc/AddMoneyBloc/AddMoneyState.dart';
import 'package:mobi_user/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import 'package:mobi_user/Utility/CustomFont.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:mobi_user/Widget/ButtonWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Bloc/DepositListBloc/DepositListEvent.dart';
import '../Bloc/PaymentBloc/PaymentEvent.dart';
import 'AddManualFundScreen.dart';
import 'InAppWebView.dart';
import 'UpiIntentScreen.dart';

class AddFundScreen extends StatefulWidget {
  const AddFundScreen({Key? key}) : super(key: key);

  @override
  State<AddFundScreen> createState() => _AddFundScreenState();
}

class _AddFundScreenState extends State<AddFundScreen> {
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

  Future<void> _postFormData({required String spURL, required String encData, required String clientCode}) async {
    try {
      final response = await http.post(
        Uri.parse(spURL),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'encData': encData, 'clientCode': clientCode},
      );
      final html = utf8.decode(response.bodyBytes);
      log("RESPONSEEEE:----- $html");
      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => InAppWebViewScreen(Url: 'about:blank')));
      } else {
        Fluttertoast.showToast(msg: 'Failed to load: ${response.statusCode}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
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
          flexibleSpace: Container(decoration: blueBoxDecoration()),
          backgroundColor: Colors.transparent,
          title: Text(translate("add_funds")),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: BlocListener<InstructionBloc, InstructionState>(
            listener: (context, state) async {
              if (state is InstructionLoadedState) {
                await popupDepositBanner(context);
              }
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
                      child: Form(
                        key: addFundKey,
                        child: ListView(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
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

                            ///textfield
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [Text(translate("enter_deposit_amount"), style: blackStyle.copyWith(fontWeight: FontWeight.bold))],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                controller: _amount,
                                keyboardType: TextInputType.number,
                                validator: (val) => val!.isEmpty ? translate("please_enter_amount") : null,
                                style: blackStyle,
                                decoration: InputDecoration(
                                  hintText: translate("hint_enter_amount"),
                                  hintStyle: blackStyle.copyWith(color: Colors.grey),
                                  prefixIcon: const Icon(Icons.currency_rupee, color: Colors.black),
                                  contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: primaryColor, width: 1.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            BlocBuilder<DepositListBloc, DepositListState>(
                              builder: (context, state) {
                                if (state is DepositLoadingState) {
                                  return SizedBox(height: 60, child: Center(child: CircularProgressIndicator()));
                                } else if (state is DepositLoadedState) {
                                  print("Deposit Loaded");
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Wrap(
                                      spacing: 15,
                                      runSpacing: 10,
                                      alignment: WrapAlignment.center,
                                      children: List.generate(state.model.data!.length, (index) {
                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              _amount.text = state.model.data![index].price.toString();
                                            });
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width / 3 - 24, // 3 per row approx.
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF3F6FA),
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: onlyShadow(),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "\u{20B9} ${state.model.data![index].price}",
                                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ValueListenableBuilder(
                                valueListenable: _loading,
                                builder: (context, bool loading, _) {
                                  return BlocConsumer<PaymentBloc, PaymentState>(
                                    listener: (context, state) async {
                                      if (state is LoadedState) {
                                        print("Url=>${state.model.data?.paymentUrl.toString()}");
                                        if (context.mounted) _loading.value = true;
                                        if (settingsState is SettingLoadedState) {
                                          if (settingsState.model.data?[0].paymentMode == "intentgateway") {
                                            await addPayment(
                                              state.model.data?.paymentUrl.toString() ?? "",
                                              state.model.data?.merchantTransactionId.toString() ?? "",
                                            );
                                          } else if (settingsState.model.data?[0].paymentMode == "webviewwithapi") {
                                            // _postFormData(
                                            //   spURL: state.model.data?.spURL ?? "",
                                            //   encData: state.model.data?.encData ?? "",
                                            //   clientCode: state.model.data?.clientCode ?? "",
                                            // );
                                            var encData = state.model.data?.encData ?? "";
                                            var clientCode = state.model.data?.clientCode ?? "";
                                            var spURL = state.model.data?.spURL ?? "";
                                            var url =
                                                "https://api.mobiii.shop/app/deposit/subpaisaredirect?encData=$encData&clientCode=$clientCode&spURL=$spURL";

                                            log("URL-> $url");
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => InAppWebViewScreen(Url: url)));
                                          } else if (settingsState.model.data?[0].paymentMode == "httpsgateway") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => InAppWebViewScreen(Url: state.model.data?.paymentUrl?.toString() ?? ""),
                                              ),
                                            );
                                          }
                                        }
                                      } else if (state is ErrorState) {
                                        Fluttertoast.showToast(msg: state.error);
                                      }
                                      if (context.mounted) _loading.value = false;
                                    },
                                    builder: (context, state) {
                                      if (state is LoadingState || loading) {
                                        return Center(child: CircularProgressIndicator());
                                      }
                                      return ButtonWidget(
                                        title: Text(translate("button_add_funds"), style: whiteStyle),
                                        primaryColor: playColor,
                                        callback: () async {
                                          if (addFundKey.currentState!.validate()) {
                                            if (settingsState is SettingLoadedState) {
                                              log("settingsState.model.data?[0].paymentMode ===> ${settingsState.model.data?[0].paymentMode}");
                                              print("Deposit Limit" + settingsState.model.data![0].minimumDeposit.toString());
                                              if (int.parse(_amount.text) >= settingsState.model.data![0].minimumDeposit!.toInt()) {
                                                ///IF payment mode is UPI
                                                if (settingsState.model.data?[0].paymentMode == "upi") {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) => UPIIntentScreen(
                                                            amount: _amount.text,
                                                            upiName: settingsState.model.data?[0].razorPayAppKey ?? "",
                                                            upiId: settingsState.model.data?[0].razorPayAppId ?? "",
                                                          ),
                                                    ),
                                                  );
                                                } else {
                                                  ///IF payment mode is GATEWAY
                                                  context.read<PaymentBloc>().add(GeneratePayment(_amount.text));
                                                }
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      contentPadding: EdgeInsets.only(bottom: 5, top: 20, left: 20, right: 20),
                                                      content: Text(
                                                        translate(
                                                          "minimum_deposit_error",
                                                          args: {"amount": settingsState.model.data![0].minimumDeposit.toString()},
                                                        ),
                                                        style: blackStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: maroonColor,
                                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text(translate("ok"), style: whiteStyle),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                              addFundKey.currentState!.save();
                                            }
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AddManualFundScreen()));
                              },
                              child: Text(translate("manual_deposit"), style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
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
