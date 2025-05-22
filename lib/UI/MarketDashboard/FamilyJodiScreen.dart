import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobi_user/Bloc/PattiListBloc/PattiListBloc.dart';
import 'package:mobi_user/Bloc/PattiListBloc/PattiListEvent.dart';
import 'package:mobi_user/Bloc/PattiListBloc/PattiListState.dart';
import 'package:mobi_user/Bloc/bidBloc/bidBloc.dart';
import 'package:mobi_user/Bloc/bidBloc/bidState.dart';
import 'package:mobi_user/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import 'package:mobi_user/UI/AddFundScreen.dart';
import 'package:mobi_user/Utility/CustomFont.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:mobi_user/Utility/ProgressIndicator.dart';
import 'package:mobi_user/error/api_failures.dart';
import 'package:mobi_user/model/BidModel.dart' as bid_model;

import '../../Bloc/bidBloc/bidEvent.dart';
import '../../Utility/AppTheme.dart';

class FamilyJodiScreen extends StatefulWidget {
  final String id;
  final String gameType;
  final String marketName;
  final bool isOnlyClose;

  const FamilyJodiScreen({Key? key, required this.isOnlyClose, required this.id, required this.gameType, required this.marketName}) : super(key: key);

  @override
  State<FamilyJodiScreen> createState() => _FamilyPanaScreenState();
}

class _FamilyPanaScreenState extends State<FamilyJodiScreen> {
  HashSet<String> selectItem = HashSet();
  HashSet<String> chooseItem = HashSet();
  List<String> panaList = [];
  GlobalKey<FormFieldState> dropdownKey = GlobalKey<FormFieldState>();
  String gameType = "open";
  var data;
  GlobalKey<FormState> pattiKey = GlobalKey<FormState>();
  TextEditingController panaController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController digitController = TextEditingController();

  bool isOpenTimeClosed = false;
  bool loading = false;

  List<String> dropdownList = [];
  int totalBid = 0;

  multiSelect(String title) {
    if (selectItem.contains(title)) {
      selectItem.remove(title);
    } else {
      selectItem.clear();
      selectItem.add(title);
    }
    setState(() {});
  }

  choosemultiSelect(String title) {
    if (chooseItem.contains(title)) {
      chooseItem.remove(title);
    } else {
      chooseItem.clear();
      chooseItem.add(title);
    }
    setState(() {});
  }

  double total = 0;
  double totalBids = 0;

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

  @override
  void initState() {
    panaController = TextEditingController();
    priceController = TextEditingController();
    BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());

    setState(() {
      gameType = widget.gameType;
      //isOpenTimeClosed = widget.isOnlyClose;
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
    panaController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF2F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(decoration: blueBoxDecoration()),
        title: Text("Family Jodi"),
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

                  print(" failureMessage $failureMessage");
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
                  debugPrint("[FAMILY JODI] BID PLACED SUCCESSFULLY ");
                  Navigator.pop(context);
                  await _showAlertDialog();
                },
              ),
            );
          }
          /*if (state is BidNowState) {
            BlocProvider.of<UserProfileBlocBloc>(context)
                .add(GetUserProfileEvent());
            state.apiFailureOrSuccessOption.fold(
              () => null,
              (either) => either.fold((failure) {
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
                              child: Text(translate("ok"))),
                        ],
                      );
                    });
              }, (right) async {
                Navigator.pop(context);
                await _showAlertDialog();
              }),
            );
          }
          else if (state is PattiState && state.selectedPana != "") {
            state.apiFailureOrSuccessOption.fold(
              () => null,
              (either) => either.fold((failure) {
                final failureMessage = failure.failureMessage;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(failureMessage),
                    duration: const Duration(milliseconds: 1000),
                  ),
                );
              }, (right) async {
                await _showAlertDialog();
                Navigator.pop(context);
              }),
            );
          }*/
        },
        child: SingleChildScrollView(
          child: Form(
            key: pattiKey,
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
                      /*Padding(
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
                      ),*/
                    ],
                  ),
                ),
                BlocBuilder<BidBloc, BidState>(
                  builder: (context, state) {
                    if (state is PattiState) {
                      return Center(child: Text(state.pitties, style: blackStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w900)));
                    }
                    return Container();
                  },
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
                      }

                      if (val.length < 2) {
                        return "Please enter 2 digits number";
                      }
                      return null;
                    },
                    maxLength: 5,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(r'^0+'), //users can't type 0 at 1st position
                      ),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: "Enter Digit",
                      counterText: "",
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    cursorColor: AppTheme().appColor,
                    style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold),
                    controller: priceController,
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
                BlocConsumer<PattiListBloc, PattiListState>(
                  listener: (context, state) {
                    if (state is ErrorPattiState) {
                      final msg = state.error;
                      if (msg == "Invalid pana") {
                        Fluttertoast.showToast(msg: "Invalid Pana, Please Play in Red Jodi");
                      } else {
                        Fluttertoast.showToast(msg: msg);
                      }
                    }

                    if (state is LoadedPattiState) {
                      log("--------> ${state.model.result.length}");
                      for (int i = 0; i < state.model.result.length; i++) {
                        log(">>>>>>> ${state.model.result[i].numbers} ///  ${state.model.result[i].digit}<<<<<<<<");
                        context.read<BidBloc>().add(
                          AddBidEvent(
                            digit: digitController.text,
                            price: priceController.text,
                            status: gameType,
                            pana: "${state.model.result[i].numbers}",
                          ),
                        );
                      }
                      digitController.clear();
                      priceController.clear();
                    }

                    if (state is ErrorPattiState) {
                      Fluttertoast.showToast(msg: state.error);
                    }
                  },
                  builder: (context, pattiState) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: AppTheme().maroon,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child:
                              (pattiState is LoadingPattiState)
                                  ? SizedBox(height: 25, width: 25, child: CircularProgressIndicator())
                                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Generate", style: AppTheme().whiteStyle)]),
                        ),
                        onPressed: () {
                          if (digitController.text.isEmpty || priceController.text.isEmpty) {
                            Fluttertoast.showToast(msg: "Please Add Digits and Points");
                            return;
                          }

                          if (digitController.text.length < 2) {
                            Fluttertoast.showToast(msg: "Please Add 2 Digits");
                            return;
                          }
                          if (pattiState is LoadingPattiState) return;
                          if (digitController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Please Add Digit"),
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
                          } else {
                            context.read<BidBloc>().add(InitialBidEvent());
                            context.read<PattiListBloc>().add(FetchPattiEvent("fj", digitController.text));
                          }
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    );
                  },
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
                              DataCell(Text(state.bidList[index].pana)),
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
          debugPrint("[Family Pana Screen] Bid State:- $bidState");
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
                      backgroundColor: primaryColor,
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
                              // for (int i = 0; i < state.bidList.length; i++) {
                              //   context.read<BidBloc>().add(
                              //       PlaceBudEventerForPitties(
                              //           marketId: widget.id,
                              //           digit: state.bidList[i].digit,
                              //           mType: "fj",
                              //           pana1: panaList[i],
                              //           points: state.bidList[i].points,
                              //           gameStatus: gameType));
                              // }
                            });
                            List<bid_model.Datum> data = [];
                            for (int i = 0; i < state.bidList.length; i++) {
                              data.add(
                                bid_model.Datum(
                                  digit: state.bidList[i].pana,
                                  pana: "0",
                                  points: state.bidList[i].points,
                                  session: state.bidList[i].session,
                                  game: "jd",
                                  marketId: widget.id,
                                ),
                              );
                            }

                            ///Call create bid
                            context.read<BidBloc>().add(
                              GetBidEvent(
                                id: widget.id,
                                data: data,
                                // index: i,
                                // digit: state.bidList[i].pana,
                                // mType: state.bidList[i].mType,
                                // type: state.bidList[i].status,
                                // points: state.bidList[i].points,
                              ),
                            );
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
