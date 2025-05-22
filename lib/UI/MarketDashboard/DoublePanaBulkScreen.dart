import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobi_user/Bloc/PanaBloc/PanaEvent.dart';
import 'package:mobi_user/Bloc/PanaBloc/PanaState.dart';
import 'package:mobi_user/Bloc/bidBloc/bidState.dart';
import 'package:mobi_user/UI/AddFundScreen.dart';
import 'package:mobi_user/Utility/ProgressIndicator.dart';
import 'package:mobi_user/error/api_failures.dart';
import 'package:mobi_user/model/BidModel.dart' as bid_model;

import '../../Bloc/PanaBloc/PanaBloc.dart';
import '../../Bloc/SettingBloc/SettingCubit.dart';
import '../../Bloc/SettingBloc/SettingState.dart';
import '../../Bloc/bidBloc/bidBloc.dart';
import '../../Bloc/bidBloc/bidEvent.dart';
import '../../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../../Utility/AppTheme.dart';
import '../../Utility/CustomFont.dart';
import '../../Utility/MainColor.dart';
import '../../Utility/Model.dart';

class DoublePanaBulkScreen extends StatefulWidget {
  final String id;
  final String gameType;
  final String marketName;
  final bool isOnlyClose;

  const DoublePanaBulkScreen({Key? key, required this.id, required this.gameType, required this.isOnlyClose, required this.marketName})
    : super(key: key);

  @override
  State<DoublePanaBulkScreen> createState() => _DoublePanaBulkScreenState();
}

class _DoublePanaBulkScreenState extends State<DoublePanaBulkScreen> {
  HashSet<String> selectItem = HashSet();
  HashSet<String> chooseItem = HashSet();
  String gameType = "open";
  List<TextEditingController> controllers = [];
  List<Model> _controller = [];
  double total = 0;
  final amountController = TextEditingController();
  bool isOpenTimeClosed = false;
  bool loading = false;

  //

  //

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

  _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
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

  multiSelect(String title) {
    if (selectItem.contains(title)) {
      selectItem.remove(title);
      /* _controller.clear();
      for (final controller in controllers) {
        controller.clear();
      }*/
    } else {
      selectItem.clear();
      /* _controller.clear();
      for (final controller in controllers) {
        controller.clear();
      }*/
      selectItem.add(title);
    }
    setState(() {});
  }

  choosemultiSelect(String title) {
    if (chooseItem.contains(title)) {
      chooseItem.remove(title);
      _controller.clear();
      for (final controller in controllers) {
        controller.clear();
      }
    } else {
      chooseItem.clear();
      _controller.clear();
      for (final controller in controllers) {
        controller.clear();
      }
      chooseItem.add(title);
    }
    setState(() {});
  }

  @override
  void initState() {
    BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());

    context.read<PanaBloc>().add(PanaListEvent("dp", "1"));
    choosemultiSelect("1");
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
    if (widget.isOnlyClose || isOpenTimeClosed) {
      setState(() {
        gameType = "close";
      });
      multiSelect(gameType);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    controllers.clear();
    amountController.dispose();
    _controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF2F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(decoration: blueBoxDecoration()),
        title: Text("Double Pana Bulk"),
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
              icon: Text("💳"),
            ),
          ),
        ],
      ),
      body: BlocListener<BidBloc, BidState>(
        listener: (context, state) {
          if (state is BidNowPlacedState) {
            BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());

            state.apiFailureOrSuccessOption.fold(
              () => null,
              (either) => either.fold(
                (failure) {
                  final failureMessage = failure.failureMessage;
                  Navigator.pop(context);
                  showDialog(
                    context: context,
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
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      color: AppTheme().appColor,
                      child: GridView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          crossAxisCount: 5,
                          childAspectRatio: 1.5,
                        ),
                        padding: EdgeInsets.all(10),
                        clipBehavior: Clip.hardEdge,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (index == 9) {
                                context.read<PanaBloc>().add(PanaListEvent("dp", "0"));
                                choosemultiSelect("0");
                              } else {
                                context.read<PanaBloc>().add(PanaListEvent("dp", "${index + 1}"));
                                choosemultiSelect("${index + 1}");
                              }
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: chooseItem.contains(index == 9 ? "0" : "${index + 1}") ? BorderRadius.circular(10) : BorderRadius.zero,
                                color: chooseItem.contains(index == 9 ? "0" : "${index + 1}") ? AppTheme().whiteColor : Colors.transparent,
                              ),
                              child: Center(
                                child: Text(
                                  index == 9 ? "0" : "${index + 1}",
                                  style:
                                      chooseItem.contains(index == 9 ? "0" : "${index + 1}")
                                          ? AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold)
                                          : AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
                      } else if (state is PanaLoadedState) {
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
                                  final digit = state.model.data?[index].digit?.toString() ?? "-";
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
                ],
              ),
              const SizedBox(height: 10),
              BlocBuilder<SettingCubit, SettingState>(
                builder: (context, settingState) {
                  print("0-0-=0-0-0-00---> $settingState");
                  if (settingState is SettingLoadedState) {
                    return BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: () {
                            if (state is UserProfileFetchedState) {
                              total = calculateTotal();
                              print(
                                "Balance=> ${double.parse(state.user.data?.balance.toString() ?? "0")} "
                                "Check Condition => ${double.parse(state.user.data?.balance.toString() ?? "0").truncate() >= total.truncate()}",
                              );

                              if (double.parse(state.user.data?.balance.toString() ?? "0").truncate() >= double.parse(total.toString()).truncate()) {
                                if (selectItem.isNotEmpty) {
                                  for (int i = 0; i < _controller.length; i++) {
                                    final item = _controller[i];
                                    print(
                                      "Item $item ${int.parse(settingState.model.data![0].minimumSpDpTpBidAmount.toString()) >= int.parse(item.amount)}",
                                    );
                                    if (int.parse(settingState.model.data![0].minimumSpDpTpBidAmount.toString()) <= int.parse(item.amount)) {
                                      BlocProvider.of<BidBloc>(
                                        context,
                                      ).add(AddBidEvent(mType: "dp", digit: item.digit, price: item.amount, status: item.type, pana: ""));
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
                                                  "Minimum Bid Amount Must Be Greater Than \u{20B9} ${settingState.model.data![0].minimumSpDpTpBidAmount.toString()}",
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
                                      );
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
                                      /* context.read<CheckOpenCloseTimeCubit>().checkOpenCloseTimeData(widget.id);*/
                                      debugPrint("This is State:- $state");
                                      BlocProvider.of<BidBloc>(context).add(DeleteBid(index: index));
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
                        child: Text("\u{20B9} ${state.total}", style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold)),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.all(2),
                      child: Text("\u{20B9} 0", style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold)),
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
          BlocConsumer<BidBloc, BidState>(
            listener: (context, bidState) {
              debugPrint("[Double Pana] Bid State:- $bidState");
              if (bidState is BidNowPlacedState) {
                setState(() {
                  loading = false;
                });
              }
            },
            builder: (context, bidState) {
              if (bidState is BidNowState) {
                return BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
                  builder: (context, state) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (loading) return;
                          // BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
                          if (state is UserProfileFetchedState) {
                            /*     total = calculateTotal();*/
                            print(
                              "Balance=> ${double.parse(state.user.data?.balance.toString() ?? "0")} "
                              "Check Condition => ${double.parse(state.user.data?.balance.toString() ?? "0") >= total}",
                            );
                            // context.read<CheckOpenCloseTimeCubit>().checkOpenCloseTimeData(widget.id);
                            if (double.parse(state.user.data?.balance.toString() ?? "0").truncate() >=
                                double.parse(bidState.total.toString()).truncate()) {
                              if (selectItem.isNotEmpty) {
                                setState(() {
                                  loading = true;
                                });
                                List<bid_model.Datum> data = [];
                                for (int i = 0; i < bidState.bidList.length; i++) {
                                  data.add(
                                    bid_model.Datum(
                                      digit: bidState.bidList[i].digit,
                                      pana: bidState.bidList[i].pana,
                                      points: bidState.bidList[i].points,
                                      session: bidState.bidList[i].session,
                                      game: "dp",
                                      marketId: widget.id,
                                    ),
                                  );
                                }
                                BlocProvider.of<BidBloc>(context).add(
                                  GetBidEvent(
                                    id: widget.id,
                                    data: data,
                                    // index: i,
                                    // type: item.session,
                                    // digit: item.digit,
                                    // points: item.points,
                                    // mType: "dp",
                                    // pana1: item.digit,
                                  ),
                                );
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
                          decoration: BoxDecoration(color: AppTheme().playAppColor, borderRadius: BorderRadius.circular(8)),
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
              }
              return Expanded(
                child: GestureDetector(
                  onTap: null,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    height: 60,
                    decoration: BoxDecoration(color: AppTheme().greyColor, borderRadius: BorderRadius.circular(8)),
                    child: Center(child: Text(translate("continue"), style: AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold))),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
