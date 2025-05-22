import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:mobi_user/error/api_failures.dart';
import 'package:mobi_user/model/BidModel.dart' as bid_model;

import '../../Bloc/PanaBloc/PanaBloc.dart';
import '../../Bloc/PanaBloc/PanaEvent.dart';
import '../../Bloc/PanaBloc/PanaState.dart';
import '../../Bloc/bidBloc/bidBloc.dart';
import '../../Bloc/bidBloc/bidEvent.dart';
import '../../Bloc/bidBloc/bidState.dart';
import '../../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../../Utility/AppTheme.dart';
import '../../Utility/CustomFont.dart';
import '../../Utility/MainColor.dart';
import '../../Utility/ProgressIndicator.dart';
import '../../model/PanaModel.dart';
import '../AddFundScreen.dart';

class SpMotorScreen extends StatefulWidget {
  final String id;
  final String gameType;
  final String marketName;
  final bool isOnlyClose;

  const SpMotorScreen({Key? key, required this.id, required this.gameType, required this.isOnlyClose, required this.marketName}) : super(key: key);

  @override
  State<SpMotorScreen> createState() => _SpMotorScreenState();
}

class _SpMotorScreenState extends State<SpMotorScreen> {
  String gameType = "open";
  bool isOpenTimeClosed = false;
  bool loading = false;

  List<Datum> numbers = [];

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

  HashSet<String> selectItem = HashSet();

  multiSelect(String title) {
    if (selectItem.contains(title)) {
      selectItem.remove(title);
    } else {
      selectItem.clear();
      selectItem.add(title);
    }
    setState(() {});
  }

  GlobalKey<FormState> spmKey = GlobalKey<FormState>();
  late TextEditingController digitController;
  late TextEditingController pointController;

  String substring(String original, {required int start, int? end}) {
    if (end == null) {
      return original.substring(start);
    }
    if (original.length < end) {
      return original.substring(start, original.length);
    }
    return original.substring(start, end);
  }

  @override
  void initState() {
    digitController = TextEditingController();
    pointController = TextEditingController();
    /* context.read<CheckOpenCloseTimeCubit>().checkOpenCloseTimeData(widget.id);*/
    setState(() {
      gameType = widget.gameType;
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

  @override
  void dispose() {
    digitController.dispose();
    pointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF2F6),
      appBar: AppBar(
        flexibleSpace: Container(decoration: blueBoxDecoration()),
        backgroundColor: Colors.transparent,
        title: Text("SP Motor"),
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
                  await _showAlertDialog();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is PattiState && state.selectedPana != "") {
            state.apiFailureOrSuccessOption.fold(
              () => null,
              (either) => either.fold(
                (failure) {
                  final failureMessage = failure.failureMessage;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(failureMessage), duration: const Duration(milliseconds: 1000)));
                },
                (right) async {
                  await _showAlertDialog();
                  Navigator.pop(context);
                },
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Form(
            key: spmKey,
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
                        child: Row(
                          children: [Text(translate("choose_session"), style: AppTheme().primaryStyle.copyWith(fontWeight: FontWeight.bold))],
                        ),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: TextFormField(
                    style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold),
                    cursorColor: AppTheme().appColor,
                    controller: digitController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter number";
                      } else if (val.length < 4) {
                        return "minimum enter 4 digit";
                      }
                      return null;
                    },
                    maxLength: 7,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
                      hintText: "Number",
                      counterText: "",
                      contentPadding: EdgeInsets.all(15),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: TextFormField(
                    style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold),
                    cursorColor: AppTheme().appColor,
                    controller: pointController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please Enter points";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(r'^0+'), //users can't type 0 at 1st position
                      ),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: "Enter Point",
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                BlocListener<PanaBloc, PanaState>(
                  listener: (context, state) {
                    if (state is PanaLoadedState) {
                      RegExp regExp = RegExp('^[${digitController.text}]+\$');
                      print(regExp);
                      numbers =
                          state.model.data!.where((number) {
                            return number.digit!.startsWith(regExp);
                          }).toList();

                      //result.sort();
                      print("Number ${numbers.map((e) => e.digit).toList()}");
                    }
                    for (int i = 0; i < numbers.length; i++) {
                      context.read<BidBloc>().add(
                        AddBidEvent(digit: numbers[i].digit.toString(), price: pointController.text, status: gameType, pana: ""),
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: AppTheme().maroon,
                      ),
                      onPressed: () {
                        if (spmKey.currentState!.validate()) {
                          numbers.clear();
                          context.read<BidBloc>().add(InitialBidEvent());
                          context.read<PanaBloc>().add(PanaListEvent("spm", ""));
                          FocusScope.of(context).unfocus();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Generate", style: AppTheme().whiteStyle)]),
                      ),
                    ),
                  ),
                ),
                BlocBuilder<BidBloc, BidState>(
                  builder: (context, state) {
                    if (state is BidNowState) {
                      return DataTable(
                        columns: [
                          DataColumn(label: Text(translate("digit"))),
                          DataColumn(label: Text(translate("points"))),
                          DataColumn(label: Text(translate("delete"))),
                          DataColumn(label: Text(translate("action"))),
                        ],
                        rows: List.generate(
                          state.bidList.length,
                          (index) => DataRow(
                            cells: [
                              DataCell(Text(state.bidList[index].digit)),
                              DataCell(Text(state.bidList[index].points)),
                              DataCell(Text(state.bidList[index].session)),
                              DataCell(
                                IconButton(
                                  onPressed: () {
                                    context.read<BidBloc>().add(DeleteBid(index: index));
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BlocConsumer<BidBloc, BidState>(
        listener: (context, bidState) {
          debugPrint("[Sp Motor Screen] Bid State:- $bidState");
          if (bidState is BidNowPlacedState) {
            setState(() {
              loading = false;
            });
          }
        },
        builder: (context, state) {
          if (state is BidNowState) {
            return BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runAlignment: WrapAlignment.center,
                    direction: Axis.vertical,
                    children: [
                      Text("Bids"),
                      BlocBuilder<BidBloc, BidState>(
                        builder: (context, state) {
                          if (state is BidNowState) {
                            return Text("${state.bidList.length}");
                          }
                          return Text("0");
                        },
                      ),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runAlignment: WrapAlignment.center,
                    direction: Axis.vertical,
                    children: [
                      Text("Points"),
                      BlocBuilder<BidBloc, BidState>(
                        builder: (context, state) {
                          if (state is BidNowState) {
                            return Text("${state.total}");
                          }
                          return Text("0");
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: playColor,
                    ),
                    onPressed: () {
                      if (loading) return;
                      context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
                      /* context.read<CheckOpenCloseTimeCubit>().checkOpenCloseTimeData(widget.id);*/
                      var state = context.read<BidBloc>().state;
                      var states = context.read<UserProfileBlocBloc>().state;
                      if (state is BidNowState) {
                        if (state.bidList.isNotEmpty && states is UserProfileFetchedState) {
                          if (double.parse(state.total) <= double.parse(states.user.data?.balance.toString() ?? "0")) {
                            setState(() {
                              loading = true;
                              List<bid_model.Datum> data = [];
                              for (int i = 0; i < state.bidList.length; i++) {
                                data.add(
                                  bid_model.Datum(
                                    marketId: widget.id,
                                    digit: state.bidList[i].digit,
                                    pana: "",
                                    points: state.bidList[i].points,
                                    session: gameType,
                                    game: "spm",
                                  ),
                                );
                              }

                              context.read<BidBloc>().add(
                                GetBidEvent(
                                  id: widget.id,
                                  data: data,
                                  // digit: state.bidList[i].digit,
                                  // mType: "spm",
                                  // pana1: '',
                                  // index: i,
                                  // points: state.bidList[i].points,
                                  // type: gameType,
                                ),
                              );
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Insufficient Balance", style: AppTheme().blackStyle),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddFundScreen()));
                                      },
                                      child: Text(translate("ok")),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }
                    },
                    child: loading ? CustomProgressIndicator() : Text("Submit", style: AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          }
          return Container(height: 60, color: Colors.transparent);
        },
      ),
    );
  }
}
