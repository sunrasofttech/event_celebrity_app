import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:mobi_user/error/api_failures.dart';
import 'package:mobi_user/model/BidModel.dart' as bid_model;

import '../../Bloc/OddEvenBloc/OddEvenBloc.dart';
import '../../Bloc/OddEvenBloc/OddEvenEvent.dart';
import '../../Bloc/OddEvenBloc/OddEvenState.dart';
import '../../Bloc/bidBloc/bidBloc.dart';
import '../../Bloc/bidBloc/bidEvent.dart';
import '../../Bloc/bidBloc/bidState.dart';
import '../../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../../Utility/AppTheme.dart';
import '../../Utility/CustomFont.dart';
import '../../Utility/ProgressIndicator.dart';
import '../../main.dart';
import '../AddFundScreen.dart';

class OddEvenScreen extends StatefulWidget {
  const OddEvenScreen({Key? key, required this.id, required this.gameType, required this.isOnlyClose, required this.marketName}) : super(key: key);
  final String id;
  final String marketName;
  final String gameType;
  final bool isOnlyClose;
  @override
  State<OddEvenScreen> createState() => _OddEvenScreenState();
}

class _OddEvenScreenState extends State<OddEvenScreen> {
  String gameType = "open";
  bool isOpenTimeClosed = false;
  bool loading = false;

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

  GlobalKey<FormState> sdmKey = GlobalKey<FormState>();
  late TextEditingController pointController;
  String flag1 = 'odd';

  @override
  void initState() {
    BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
    context.read<BidBloc>().add(InitialBidEvent());
    String uid = pref.getString("key").toString();

    pointController = TextEditingController();
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
        title: Text("Odd Even"),
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
                  debugPrint("BID PLACED SUCCESSFULLY");
                  Navigator.pop(context);
                  await _showAlertDialog();
                },
              ),
            );
          }

          // if (state is BidNowState) {
          //   state.apiFailureOrSuccessOption.fold(
          //     () => null,
          //     (either) => either.fold((failure) {
          //       final failureMessage = failure.failureMessage;
          //
          //       showDialog(
          //         context: context,
          //         builder: (context) {
          //           return AlertDialog(
          //             title: Text(failureMessage),
          //             actions: [
          //               TextButton(
          //                   onPressed: () {
          //                     Navigator.pop(context);
          //                   },
          //                   child: Text(translate("ok"))),
          //             ],
          //           );
          //         },
          //       );
          //     }, (right) async {
          //       Navigator.pop(context);
          //       await _showAlertDialog();
          //     }),
          //   );
          // }
          // else if (state is PattiState && state.selectedPana != "") {
          //   state.apiFailureOrSuccessOption.fold(
          //     () => null,
          //     (either) => either.fold((failure) {
          //       final failureMessage = failure.failureMessage;
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text(failureMessage),
          //           duration: const Duration(milliseconds: 1000),
          //         ),
          //       );
          //     }, (right) async {
          //       await _showAlertDialog();
          //       Navigator.pop(context);
          //     }),
          //   );
          // }
        },
        child: SingleChildScrollView(
          child: Form(
            key: sdmKey,
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
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text('Odd'),
                          leading: Radio<String>(
                            value: 'odd',
                            groupValue: flag1,
                            onChanged: (String? value) {
                              setState(() {
                                flag1 = value ?? "odd";
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text('Even'),
                          leading: Radio<String>(
                            value: 'even',
                            groupValue: flag1,
                            onChanged: (String? value) {
                              setState(() {
                                flag1 = value ?? "even";
                              });
                            },
                          ),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                      border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
                      hintText: "Enter Point",
                    ),
                  ),
                ),
                BlocConsumer<OddEvenBloc, OddEvenState>(
                  listener: (context, state) {
                    if (state is OddEvenLoadedState) {
                      for (int i = 0; i < state.model.data!.length; i++) {
                        context.read<BidBloc>().add(
                          AddBidEvent(digit: state.model.data?[i].number?.toString() ?? "-", price: pointController.text, status: gameType, pana: ""),
                        );
                      }
                      pointController.clear();
                      context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
                    }

                    if (state is OddEvenErrorState) {
                      Fluttertoast.showToast(msg: state.error);
                    }
                  },
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          backgroundColor: AppTheme().maroon,
                        ),
                        onPressed: () {
                          if (sdmKey.currentState!.validate()) {
                            if (pointController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Please add points"),
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
                              context.read<OddEvenBloc>().add(OddEvenListEvent("${flag1}"));
                            }
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child:
                              (state is OddEvenLoadingState)
                                  ? SizedBox(height: 25, width: 25, child: CircularProgressIndicator())
                                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Generate", style: AppTheme().whiteStyle)]),
                        ),
                      ),
                    );
                  },
                ),
                BlocBuilder<BidBloc, BidState>(
                  builder: (context, state) {
                    if (state is BidNowState) {
                      return DataTable(
                        columns: [
                          DataColumn(label: Text("Digit")),
                          DataColumn(label: Text("Points")),
                          DataColumn(label: Text("Type")),
                          DataColumn(label: Text("Delete")),
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
          debugPrint("[Odd Even] Bid State:- $bidState");
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
                      // context.read<CheckOpenCloseTimeCubit>().checkOpenCloseTimeData(widget.id);
                      var state = context.read<BidBloc>().state;
                      var states = context.read<UserProfileBlocBloc>().state;
                      if (state is BidNowState) {
                        if (state.bidList.isNotEmpty && states is UserProfileFetchedState) {
                          if (double.parse(state.total) <= double.parse(states.user.data?.balance.toString() ?? "0")) {
                            setState(() {
                              loading = true;
                            });

                            List<bid_model.Datum> data = [];
                            for (int i = 0; i < state.bidList.length; i++) {
                              data.add(
                                bid_model.Datum(
                                  digit: state.bidList[i].digit,
                                  pana: "",
                                  points: state.bidList[i].points,
                                  session: state.bidList[i].session,
                                  game: "sd",
                                  marketId: widget.id,
                                ),
                              );
                            }

                            ///Call create bid
                            context.read<BidBloc>().add(GetBidEvent(id: widget.id, data: data));
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
