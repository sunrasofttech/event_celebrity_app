import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:mobi_user/Bloc/InstructionBloc/InstructionBloc.dart';
import 'package:mobi_user/Bloc/InstructionBloc/InstructionState.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingCubit.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingState.dart';
import 'package:mobi_user/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import 'package:mobi_user/Bloc/withdrwaDetails/withdraw_details_bloc.dart';
import 'package:mobi_user/Bloc/withdrwaDetails/withdraw_details_state.dart';
import 'package:mobi_user/UI/AddFundScreen.dart';
import 'package:mobi_user/UI/FundHistory.dart';
import 'package:mobi_user/Utility/AppTheme.dart';
import 'package:mobi_user/Utility/CustomFont.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:mobi_user/Utility/const.dart';
import 'package:mobi_user/Widget/ButtonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Bloc/AccountBloc/AccountState.dart';
import '../Bloc/CheckBankBloc/CheckBankCubit.dart';
import '../Bloc/CheckBankBloc/CheckBankState.dart';
import '../Bloc/InstructionBloc/InstructionEvent.dart';
import '../Bloc/withdrwaDetails/withdraw_details_event.dart';
import '../model/bankDetailsModel.dart';
import 'AddBankDetailsScreen.dart';
import 'MainScreen.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  GlobalKey<FormState> addBankKey = GlobalKey<FormState>();

  _WithdrawalScreenState();

  TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var selectedValue = "bank";

  //final PagingController<int, account_model.Datum> _pagingController = PagingController(firstPageKey: 0);
  String startDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  String endDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  int pageSize = 40;
  int pageKey = 0;

  bool loading = false;

  void popupWithdrawBanner(BuildContext context) async {
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
                Text(translate("important_information"), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Lottie.asset("asset/video/imp_alert.json", width: 50, height: 50),
                const SizedBox(height: 16),
                BlocBuilder<InstructionBloc, InstructionState>(
                  builder: (context, state) {
                    if (state is InstructionLoadedDataState) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 300), // Adjust maxHeight as needed
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.model.data!.length,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          physics: NeverScrollableScrollPhysics(),
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
                      child: Text(translate("ok"), style: TextStyle(color: Colors.green)),
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

  openWhatsapp(number) async {
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

  @override
  void initState() {
    context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
    context.read<InstructionBloc>().add(FetchInstructionEvent("withdraw"));
    context.read<SettingCubit>().getSettingsApiCall();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String formatedTime(TimeOfDay selectedTime) {
    DateTime tempDate = DateFormat.Hms().parse(selectedTime.hour.toString() + ":" + selectedTime.minute.toString() + ":" + '0' + ":" + '0');
    var dateFormat = DateFormat("h:mm a");
    return (dateFormat.format(tempDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate("withdraw_methods")),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(decoration: blueBoxDecoration()),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.white, width: 1.2)),
                backgroundColor: primaryColor,
              ),
              onPressed: () {},
              label: BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
                builder: (context, state) {
                  if (state is UserProfileFetchedState) {
                    return Text("${state.user.data?.balance ?? "0"}", style: whiteStyle);
                  }
                  return Text("0", style: whiteStyle);
                },
              ),
              icon: Text("💳"),
            ),
          ),
        ],
      ),
      body: BlocListener<InstructionBloc, InstructionState>(
        listener: (context, state) {
          if (state is InstructionLoadedDataState) {
            popupWithdrawBanner(context);
          }
        },
        child: BlocConsumer<WithdrawDetailsBloc, WithdrawDetailsState>(
          listener: (context, state) {
            // TODO: implement listener
            print("This is State: $state");
            if (state is WithdrawRequested) {
              Navigator.pop(context);
              setState(() {
                loading = false;
              });
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("\u{1F449} \u{1F449} ${state.message}"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(translate("ok")),
                      ),
                    ],
                  );
                },
              );

              if (state.isError) {
                BlocProvider.of<WithdrawDetailsBloc>(context).add(FetchBankDetailsEvent());
              } else {
                BlocProvider.of<WithdrawDetailsBloc>(context).add(FetchBankDetailsEvent());
              }
              BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
              amountController.clear();
            }
          },
          builder: (context, state) {
            if (state is WithdrawDetailsInitial) {
              BlocProvider.of<WithdrawDetailsBloc>(context).add(FetchBankDetailsEvent());
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AccountAddedSuccessfullyState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
                    },
                    child: ListView(
                      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      children: [
                        BlocBuilder<SettingCubit, SettingState>(
                          builder: (context, state) {
                            if (state is SettingLoadedState) {
                              print("Loaded Setting=>${state.model.data![0].withdrawRequestText}");
                              return Card(
                                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                color: Colors.white,
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Marquee(
                                        text:
                                            state.model.data![0].withdrawRequestText?.isEmpty ?? true
                                                ? "$appName, $appName, $appName"
                                                : "${state.model.data![0].withdrawRequestText}",
                                        scrollAxis: Axis.horizontal,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        blankSpace: 10,
                                        velocity: 100,
                                        numberOfRounds: 1000,
                                        startPadding: 10,
                                        accelerationDuration: Duration(seconds: 1),
                                        accelerationCurve: Curves.linear,
                                        decelerationDuration: Duration(milliseconds: 500),
                                        decelerationCurve: Curves.easeOut,
                                        style: blackStyle.copyWith(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),

                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Withdraw Options" /*translate("withdraw_options")*/,
                            style: blackStyle.copyWith(fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
                                  // setState(() {
                                  //   selectedValue = "bank";
                                  //   print(selectedValue);
                                  // });

                                  addDetails(context: context, name: "Bank Account Details", details: state.bankDetails);
                                },
                                child: Image.asset("asset/icons/add_funds_options/add_bank_pic.png", height: 150),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
                                  // setState(() {
                                  //   selectedValue = "upi";
                                  //   print(selectedValue);
                                  // });
                                  addDetails(context: context, name: "UPI", details: state.bankDetails);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Opacity(
                                    opacity: state.bankDetails.accountNo!.isNotEmpty && state.bankDetails.ifsc!.isNotEmpty ? 1 : 0.8,
                                    child: Image.asset("asset/icons/add_funds_options/upi_option_pic.png", height: 150),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Select Withdraw In Bank/UPI" /*translate("withdraw_options")*/,
                            style: blackStyle.copyWith(fontWeight: FontWeight.w500, fontSize: 14, color: primaryColor),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
                          child: DropdownButton<String>(
                            value: selectedValue,
                            items: const [
                              DropdownMenuItem(value: "bank", child: Text("Bank Account Details")),
                              DropdownMenuItem(value: "upi", child: Text("UPI")),
                            ],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  selectedValue = newValue;
                                  print("Dropdown changed to: $selectedValue");
                                });

                                final title = newValue == "upi" ? "Withdraw at UPI" : "Withdraw at Bank Account Details";
                                // addDetails(context: context, name: title, details: state.bankDetails);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [Text(translate("withdraw_points"), style: blackStyle.copyWith(color: primaryColor))]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                          child: TextFormField(
                            cursorColor: blackColor,
                            style: blackStyle,
                            controller: amountController,
                            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^0+')), FilteringTextInputFormatter.digitsOnly],
                            keyboardType: TextInputType.number,
                            validator: (value) => value == null || value.isEmpty ? translate("please_enter_some_text") : null,
                            decoration: InputDecoration(
                              hintStyle: blackStyle.copyWith(color: Colors.grey),
                              prefixIcon: Icon(Icons.currency_rupee_sharp),
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
                              hintText: translate("enter_withdrawal_points"),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        BlocConsumer<CheckBankCubit, CheckBankState>(
                          listener: (context, state) {
                            log("--------------------->>>>>>>>>>>>>>>>> ${selectedValue}");
                            if (state is CheckLoadedState) {
                              //Fluttertoast.showToast(msg: "$selectedValue");
                              setState(() {
                                loading = true;
                              });
                              BlocProvider.of<WithdrawDetailsBloc>(
                                context,
                              ).add(WithdrawPaymentEvent(amount: amountController.text, account: selectedValue));
                            } else if (state is CheckErrorState) {
                              Fluttertoast.showToast(msg: state.error);
                              setState(() {
                                loading = false;
                              });
                            }
                          },
                          builder: (context, state) {
                            if (state is LoadingState) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return BlocBuilder<WithdrawDetailsBloc, WithdrawDetailsState>(
                              builder: (context, withdrawState) {
                                return BlocBuilder<SettingCubit, SettingState>(
                                  builder: (context, settingState) {
                                    return BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
                                      builder: (context, userState) {
                                        return ButtonWidget(
                                          callback: () async {
                                            if (loading) return;
                                            if (selectedValue == "bank" && withdrawState is AccountAddedSuccessfullyState) {
                                              if (withdrawState.bankDetails.ifsc == null || withdrawState.bankDetails.ifsc.toString().trim() == "") {
                                                Fluttertoast.showToast(msg: "Please Add Bank Details");
                                                return;
                                              }
                                            }

                                            if (selectedValue == "upi" &&
                                                withdrawState is AccountAddedSuccessfullyState &&
                                                (withdrawState.bankDetails.upi == null || withdrawState.bankDetails.upi.toString().trim() == "")) {
                                              Fluttertoast.showToast(msg: "Please Add UPI Details");
                                              return;
                                            }

                                            if (settingState is SettingLoadedState) {
                                              ///Is withdraw enabled
                                              if (settingState.model.data?[0].withdrawEnabled.toString() == "0") {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      content: Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            "Withdraw is disabled by admin currently please send request later",
                                                            style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                                                          ),
                                                          SizedBox(height: 20),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: primaryColor,
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            child: Text(translate("ok"), style: whiteStyle),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              } else {
                                                ///

                                                log("message ---> withdraw enabled ");
                                                SharedPreferences pref = await SharedPreferences.getInstance();
                                                if (_formKey.currentState!.validate()) {
                                                  if (userState is UserProfileFetchedState) {
                                                    print(
                                                      "-------->>>>>> ${double.parse(userState.user.data!.balance!.toString())} 77 ${double.parse(amountController.text)}",
                                                    );
                                                    if (double.parse(userState.user.data!.balance!.toString()) >=
                                                        double.parse(amountController.text)) {
                                                      setState(() {
                                                        loading = true;
                                                      });
                                                      context.read<CheckBankCubit>().fetchBankData(pref.getString("key").toString(), selectedValue);
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            content: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text(
                                                                  translate("insufficient_balance"),
                                                                  style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                                                                ),
                                                                SizedBox(height: 20),
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: primaryColor,
                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.pushReplacement(
                                                                      context,
                                                                      MaterialPageRoute(builder: (context) => AddFundScreen()),
                                                                    );
                                                                  },
                                                                  child: Text(translate("ok"), style: whiteStyle),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }
                                                  FocusScope.of(context).unfocus();
                                                }
                                              }
                                            }
                                          },
                                          title:
                                              loading
                                                  ? Center(
                                                    child: SizedBox(height: 15, width: 15, child: CircularProgressIndicator(color: Colors.white)),
                                                  )
                                                  : Text(translate("send_request"), style: whiteStyle),
                                          primaryColor: playColor,
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        SizedBox(height: 40),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => FundHistory()));
                            },
                            child: Padding(padding: EdgeInsets.all(10), child: Text(translate("transaction_history"), style: blackStyle)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  ///--------------------------

  void addDetails({required BuildContext context, required String name, required BankDetailsModel details}) {
    showDialog(
      context: context,
      useSafeArea: true,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: SizedBox(height: MediaQuery.of(context).size.height, child: AddBankDetailsScreen(details: details)),
        );
      },
    );
  }
}
