import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobi_user/Bloc/PanaBloc/PanaEvent.dart';
import 'package:mobi_user/Bloc/PanaBloc/PanaState.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingCubit.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingState.dart';
import 'package:mobi_user/Bloc/bidBloc/bidState.dart';
import 'package:mobi_user/UI/AddFundScreen.dart';
import 'package:mobi_user/error/api_failures.dart';
import 'package:mobi_user/model/BidModel.dart' as bid_model;

import '../../Bloc/PanaBloc/PanaBloc.dart';
import '../../Bloc/bidBloc/bidBloc.dart';
import '../../Bloc/bidBloc/bidEvent.dart';
import '../../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../../Utility/AppTheme.dart';
import '../../Utility/CustomFont.dart';
import '../../Utility/MainColor.dart';
import '../../Utility/Model.dart';
import '../../Utility/ProgressIndicator.dart';

class SingleDigitBulkScreen extends StatefulWidget {
  final String id;
  final String marketName;
  final String gameType;
  final bool isOnlyClose;

  const SingleDigitBulkScreen({Key? key, required this.id, required this.gameType, required this.isOnlyClose, required this.marketName})
    : super(key: key);

  @override
  State<SingleDigitBulkScreen> createState() => _SingleDigitBulkScreenState();
}

class _SingleDigitBulkScreenState extends State<SingleDigitBulkScreen> {
  HashSet<String> selectItem = HashSet();
  List<TextEditingController> controllers = [];
  List<Model> _controller = [];
  double total = 0;
  String gameType = "";
  bool isOpenTimeClosed = false;
  bool isshowDialog = false;
  bool loading = false;
  final amountController = TextEditingController();

  multiSelect(String title) {
    if (selectItem.contains(title)) {
      selectItem.remove(title);
      /* _controller.clear();
      for (final controller in controllers) {
        controller.clear();
      }*/
    } else {
      selectItem.clear();
      selectItem.add(title);
      print("Choose Session $title");
      /*  _controller.clear();
      for (final controller in controllers) {
        controller.clear();
      }*/
    }
    setState(() {});
  }

  _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Bid placed'),
          content: SingleChildScrollView(child: ListBody(children: const <Widget>[Text('Your bid has been placed successfully.')])),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
    context.read<PanaBloc>().add(PanaListEvent("sd", ""));
    context.read<SettingCubit>().getSettingsApiCall();
    //context.read<CheckOpenCloseTimeCubit>().checkOpenCloseTimeData(widget.id);
    setState(() {
      gameType = widget.gameType;
      isOpenTimeClosed = widget.isOnlyClose;
    });
    if (gameType == "open") {
      multiSelect(gameType);
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.isOnlyClose) {
      setState(() {
        gameType = "close";
      });
      multiSelect(gameType);
    }
    super.didChangeDependencies();
  }

  double calculateTotal() {
    double total = 0.0;
    print("Length ${controllers.length}");

    for (int i = 0; i < controllers.length; i++) {
      // print("Number ${controllers[i].text}");
      double value = double.tryParse(controllers[i].text) ?? 0;
      total += value;
    }
    print("total Amount =>$total & Length ${controllers.length}");
    return total;
  }

  bool isAlertShow = false;

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    amountController.dispose();
    _controller.clear();
    controllers.clear();
    super.dispose();
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    print("Open Time is Close=>" + widget.isOnlyClose.toString());

    return Scaffold(
      backgroundColor: Color(0xFFEEF2F6),
      appBar: AppBar(
        flexibleSpace: Container(decoration: blueBoxDecoration()),
        backgroundColor: Colors.transparent,
        title: Text("Single Digit Bulk"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.white, width: 1.2)),
                backgroundColor: maroonColor,
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
              icon: Icon(Icons.account_balance_wallet, color: whiteColor),
            ),
          ),
        ],
      ),
      body: BlocListener<BidBloc, BidState>(
        listenWhen: (prev, current) => prev != current,
        listener: (context, state) {
          if (state is BidNowPlacedState) {
            BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());

            state.apiFailureOrSuccessOption.fold(
              () => null,
              (either) => either.fold(
                (failure) {
                  final failureMessage = failure.failureMessage;
                  _controller.clear();
                  print("Count=> ${count++}, failureMessage $failureMessage");
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(failureMessage),
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
                },
                (right) async {
                  _controller.clear();
                  Navigator.pop(context);
                  await _showAlertDialog();
                },
              ),
            );
          }
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                // decoration: blueBoxDecoration(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(widget.marketName, style: AppTheme().pinkStyle.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(children: [Text("Date", style: AppTheme().primaryStyle.copyWith(fontSize: 14))]),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.date_range, color: primaryColor),
                        title: Text(
                          "${DateFormat("EEEE,dd MMMM yyyy").format(DateTime.now())}",
                          style: AppTheme().primaryStyle.copyWith(fontWeight: FontWeight.bold),
                        ),
                        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(children: [Text(translate("choose_session"), style: AppTheme().primaryStyle.copyWith(fontWeight: FontWeight.bold))]),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        side: BorderSide(color: playColor),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor:
                            widget.isOnlyClose || isOpenTimeClosed
                                ? AppTheme().greyColor
                                : selectItem.contains("open")
                                ? playColor
                                : AppTheme().whiteColor,
                      ),
                      child: Text(
                        translate("open"),
                        style:
                            widget.isOnlyClose || isOpenTimeClosed
                                ? AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold)
                                : selectItem.contains("open")
                                ? AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold)
                                : AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (widget.isOnlyClose) {
                        } else {
                          setState(() {
                            gameType = "open";
                          });
                          multiSelect(gameType);
                        }
                      },
                    ),
                    OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        side: BorderSide(color: playColor),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: selectItem.contains("close") ? playColor : AppTheme().whiteColor,
                      ),
                      child: Text(
                        translate("close"),
                        style:
                            selectItem.contains("close")
                                ? AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold)
                                : AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        if (widget.isOnlyClose) {
                        } else {
                          setState(() {
                            gameType = "close";
                          });
                          multiSelect(gameType);
                        }
                      },
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                  decoration: InputDecoration(labelText: "Enter Amount", border: OutlineInputBorder()),
                ),
              ),

              ///TextField Widgets
              BlocConsumer<PanaBloc, PanaState>(
                listener: (context, state) {
                  if (state is PanaLoadedState) {
                    for (int i = 0; i < state.model.data!.length; i++) {
                      controllers.add(TextEditingController());
                    }
                  }
                },
                builder: (context, state) {
                  if (state is PanaLoadingState) {
                    return Padding(padding: EdgeInsets.only(top: 60), child: Center(child: CircularProgressIndicator()));
                  }

                  if (state is PanaLoadedState) {
                    return controllers.isEmpty
                        ? Container()
                        : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            itemCount: state.model.data?.length ?? 0,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 0,
                              crossAxisCount: 5,
                            ),
                            itemBuilder: (context, index) {
                              final digit = index == 9 ? "0" : "${index + 1}";
                              final existingAmount =
                                  _controller
                                      .firstWhere((e) => e.id == index, orElse: () => Model(id: index, amount: "", digit: digit, type: gameType))
                                      .amount;

                              return GestureDetector(
                                onTap: () {
                                  final amount = amountController.text.trim();
                                  if (amount.isEmpty || int.tryParse(amount) == null || int.parse(amount) <= 0) {
                                    Fluttertoast.showToast(msg: "Please Add Valid Amount");
                                    return;
                                  }
                                  final newAmount = int.parse(amount);

                                  // Get existing model if it exists
                                  final existingModel = _controller.firstWhere(
                                    (e) => e.id == index,
                                    orElse: () => Model(id: index, amount: "0", digit: digit, type: gameType),
                                  );

                                  final existing = int.tryParse(existingModel.amount) ?? 0;
                                  final totalAmount = existing + newAmount;

                                  // Update the controller
                                  _controller.removeWhere((e) => e.id == index);
                                  _controller.add(Model(id: index, amount: totalAmount.toString(), digit: digit, type: gameType));

                                  setState(() {});
                                },
                                child: Container(
                                  margin: EdgeInsets.all(4),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme().greyColor),
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppTheme().greyColor.withOpacity(0.1),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(digit, style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold)),
                                        if (existingAmount.isNotEmpty)
                                          Column(
                                            children: [
                                              const SizedBox(height: 2),
                                              Text("₹$existingAmount", style: AppTheme().blackStyle.copyWith(fontSize: 12)),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                  }
                  return Container();
                },
              ),

              ///
              const SizedBox(height: 10),
              BlocBuilder<SettingCubit, SettingState>(
                builder: (context, settingState) {
                  if (settingState is SettingLoadedState) {
                    return BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
                      builder: (context, state) {
                        return BlocBuilder<BidBloc, BidState>(
                          builder: (context, bidState) {
                            return InkWell(
                              onTap: () {
                                if (state is UserProfileFetchedState) {
                                  total = calculateTotal();

                                  print(
                                    "Balance=> ${double.parse(state.user.data?.balance.toString() ?? "0")} "
                                    "Check Condition => ${double.parse(state.user.data?.balance.toString() ?? "0").truncate() >= total.truncate()}",
                                  );

                                  num checkBidOrCalculated =
                                      (bidState is BidNowState)
                                          ? double.parse(bidState.total.toString()).truncate()
                                          : double.parse(total.toString()).truncate();
                                  debugPrint("----> checkBidOrCalculated $checkBidOrCalculated");
                                  if (double.parse(state.user.data?.balance.toString() ?? "0").truncate() >= checkBidOrCalculated) {
                                    if (selectItem.isNotEmpty) {
                                      for (int i = 0; i < _controller.length; i++) {
                                        final item = _controller[i];
                                        print(
                                          "Item ${settingState.model.data![0].minimumSdBidAmount.toString()} ${int.parse(settingState.model.data![0].minimumSdBidAmount.toString()) >= int.parse(item.amount)}",
                                        );
                                        if (int.parse(settingState.model.data![0].minimumSdBidAmount.toString()) <= int.parse(item.amount)) {
                                          BlocProvider.of<BidBloc>(
                                            context,
                                          ).add(AddBidEvent(mType: "sd", digit: item.digit, price: item.amount, status: gameType, pana: ""));
                                        } else {
                                          print("Amount=> " + item.amount);

                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                contentPadding: EdgeInsets.only(bottom: 5, top: 20, left: 20, right: 20),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Minimum Bid Amount Must Be Greater Than \u{20B9} ${settingState.model.data![0].minimumSdBidAmount.toString()}",
                                                      style: blackStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                                                    ),
                                                    SizedBox(height: 20),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: maroonColor,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Ok", style: whiteStyle),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ).whenComplete(() => print("Complete"));
                                          break;
                                        }
                                        print(item.type);
                                      }
                                      for (final controller in controllers) {
                                        controller.clear();
                                      }
                                      _controller.clear();
                                      amountController.clear();
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(translate("choose_session") + " !!!"),
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
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(translate("insufficient_balance") + " !!!"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AddFundScreen()));
                                              },
                                              child: Text(translate("ok")),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                                FocusScope.of(context).unfocus();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                                decoration: BoxDecoration(color: AppTheme().appColor, borderRadius: BorderRadius.circular(4)),
                                child: Text(translate("add_bids"), style: TextStyle(color: AppTheme().whiteColor)),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 10),
              BlocBuilder<BidBloc, BidState>(
                builder: (context, state) {
                  if (state is BidNowState) {
                    return DataTable(
                      columnSpacing: 20,
                      border: TableBorder.all(
                        color: Colors.blue,
                        width: .2,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      ),
                      decoration: BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                      columns: [
                        DataColumn(label: Text(translate("digit"))),
                        DataColumn(label: Text(translate("points"))),
                        DataColumn(label: Text(translate("type"))),
                        DataColumn(label: Text(translate("action"))),
                      ],
                      rows:
                          List.generate(
                            state.bidList.length,
                            (index) => DataRow(
                              cells: [
                                DataCell(Text(state.bidList[index].digit.toString())),
                                DataCell(Text(state.bidList[index].points.toString())),
                                DataCell(Text(state.bidList[index].session.toString())),
                                DataCell(
                                  IconButton(
                                    onPressed: () {
                                      debugPrint("This is State:- $state");
                                      BlocProvider.of<BidBloc>(context).add(DeleteBid(index: index));

                                      /* setState(() {
                                        total = calculateTotal();
                                      });*/
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ).toList(),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Wrap(
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              direction: Axis.vertical,
              children: [
                BlocBuilder<BidBloc, BidState>(
                  builder: (context, state) {
                    if (state is BidNowState) {
                      return Padding(
                        padding: EdgeInsets.all(2),
                        child: Text("\u{20B9} ${state.total}", style: AppTheme().primaryStyle.copyWith(fontWeight: FontWeight.bold)),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.all(2),
                      child: Text("\u{20B9} 0", style: AppTheme().primaryStyle.copyWith(fontWeight: FontWeight.bold)),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(translate("total_amount"), style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
            builder: (context, state) {
              return BlocConsumer<BidBloc, BidState>(
                listener: (context, bidState) {
                  debugPrint("[Single Digit] Bid State:- $bidState");
                  if (bidState is BidNowPlacedState) {
                    setState(() {
                      loading = false;
                    });
                  }
                },
                builder: (context, bidState) {
                  if (bidState is BidNowState) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          //BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
                          if (loading) return;
                          if (state is UserProfileFetchedState) {
                            //total = calculateTotal();
                            print(
                              "Balance=> ${double.parse(state.user.data?.balance.toString() ?? "0")} "
                              "Check Condition => ${double.parse(state.user.data?.balance.toString() ?? "0").truncate() >= total.truncate()}",
                            );

                            if (double.parse(state.user.data?.balance.toString() ?? "0").truncate() >=
                                double.parse(bidState.total.toString()).truncate()) {
                              if (selectItem.isNotEmpty) {
                                print("Select Item ${bidState.bidList.length}");
                                setState(() {
                                  loading = true;
                                });
                                List<bid_model.Datum> data = [];
                                for (int i = 0; i < bidState.bidList.length; i++) {
                                  data.add(
                                    bid_model.Datum(
                                      digit: bidState.bidList[i].digit,
                                      pana: "",
                                      points: bidState.bidList[i].points,
                                      session: bidState.bidList[i].session,
                                      game: "sd",
                                      marketId: widget.id,
                                    ),
                                  );
                                }
                                // for (int i = 0; i < bidState.bidList.length; i++) {
                                //   final item = bidState.bidList[i];
                                //   print("Item $item");
                                //   print("DIGIT => ${item.digit} \n GameType=>${item.mType} points=>${item.points}");
                                BlocProvider.of<BidBloc>(context).add(
                                  GetBidEvent(
                                    id: widget.id,
                                    data: data,
                                    // index: i,
                                    // mType: "sd",
                                    // digit: item.digit,
                                    // points: item.points,
                                    // type: item.session,
                                    // pana1: "",
                                  ),
                                );
                                //   print(item.mType);
                                // }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(translate("choose_session") + " !!!"),
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
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(translate("insufficient_balance") + " !!!"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AddFundScreen()));
                                        },
                                        child: Text(translate("ok")),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          height: 60,
                          decoration: BoxDecoration(color: AppTheme().maroon, borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child:
                                loading
                                    ? CustomProgressIndicator()
                                    : Text(translate("continue"), style: AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: GestureDetector(
                      onTap: null,
                      child: Container(
                        margin: EdgeInsets.all(8),
                        height: 60,
                        decoration: BoxDecoration(color: AppTheme().greyColor, borderRadius: BorderRadius.circular(8)),

                        child: Center(
                          child:
                              loading
                                  ? CustomProgressIndicator()
                                  : Text(translate("continue"), style: AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
