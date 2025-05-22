import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:mobi_user/error/api_failures.dart';
import 'package:mobi_user/model/BidModel.dart' as bid_model;

import '../../Bloc/PanaByAnkBloc/PanaByAnkBloc.dart';
import '../../Bloc/PanaByAnkBloc/PanaByAnkEvent.dart';
import '../../Bloc/PanaByAnkBloc/PanaByAnkState.dart';
import '../../Bloc/bidBloc/bidBloc.dart';
import '../../Bloc/bidBloc/bidEvent.dart';
import '../../Bloc/bidBloc/bidState.dart';
import '../../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../../Utility/AppTheme.dart';
import '../../Utility/CustomFont.dart';
import '../../Utility/ProgressIndicator.dart';
import '../../main.dart';
import '../AddFundScreen.dart';

class AllPanaScreen extends StatefulWidget {
  final String id;
  final String marketName;
  final String gameType;
  final bool isOnlyClose;

  const AllPanaScreen({Key? key, required this.id, required this.gameType, required this.isOnlyClose, required this.marketName}) : super(key: key);

  @override
  State<AllPanaScreen> createState() => _AllPanaScreenState();
}

class _AllPanaScreenState extends State<AllPanaScreen> {
  String gameType = "open";
  String data1 = "";
  String data2 = "";
  String data3 = "";
  bool isOpenTimeClosed = false;
  bool loading = false;

  _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Bid placed'),
          content: Text('Your bid has been placed successfully.'),
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
  late TextEditingController digitController;
  late TextEditingController pointController;
  bool flag1 = false;
  bool flag2 = false;
  bool flag3 = false;

  String MTYPE = "";

  @override
  void initState() {
    BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
    String uid = pref.getString("key").toString();

    digitController = TextEditingController();
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
        title: Text("SPDPTP Pana"),
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
        listener: (context, state) {},
        child: SingleChildScrollView(
          child: Form(
            key: sdmKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(widget.marketName, style: AppTheme().pinkStyle.copyWith(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [Text("Date", style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16))]),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      "${DateFormat("EEEE,dd MMMM yyyy").format(DateTime.now())}",
                      style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                    shape: RoundedRectangleBorder(side: BorderSide(color: AppTheme().appColor), borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(children: [Text(translate("choose_session"), style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold))]),
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
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          activeColor: AppTheme().appColor,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: flag1,
                          title: Text("SP"),
                          onChanged: (value) {
                            setState(() {
                              flag1 = !flag1;
                              flag1 ? data1 = "SP" : data1 = "";
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          activeColor: AppTheme().appColor,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: flag2,
                          title: Text("DP"),
                          onChanged: (value) {
                            setState(() {
                              flag2 = !flag2;
                              flag2 ? data2 = "DP" : data2 = "";
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          activeColor: AppTheme().appColor,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: flag3,
                          title: Text("TP"),
                          onChanged: (value) {
                            setState(() {
                              flag3 = !flag3;
                              flag3 ? data3 = "TP" : data3 = "";
                            });
                          },
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
                      }
                      return null;
                    },
                    maxLength: 1,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      // FilteringTextInputFormatter.deny(
                      //   RegExp(r'^0+'), //users can't type 0 at 1st position
                      // ),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: "Number",
                      counterText: "",
                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                      border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 40),
                      border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                BlocConsumer<PanaByAnkBloc, PanaByAnkState>(
                  listener: (context, state) {
                    if (state is PanaByAnkLoadedState) {
                      for (int i = 0; i < state.model.data!.length; i++) {
                        context.read<BidBloc>().add(
                          AddBidEvent(
                            digit: digitController.text,
                            price: pointController.text,
                            status: gameType,
                            pana: "${state.model.data?[i].digit}",
                            mType: "${state.model.data?[i].mtype}",
                          ),
                        );
                      }

                      List<String> result = [];

                      if (flag1) {
                        result.add('sp');
                      }
                      if (flag2) {
                        result.add('dp');
                      }
                      if (flag3) {
                        result.add('tp');
                      }
                      setState(() {
                        MTYPE = result.join(",");
                      });

                      debugPrint("MTYPE MTYPE ---> $MTYPE");
                      digitController.clear();
                      pointController.clear();
                      context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
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
                            if (data1.isEmpty && data2.isEmpty && data3.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Please select atleast one SP,DP,TP"),
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
                              context.read<PanaByAnkBloc>().add(
                                PanaByAnkListEvent("${data1.toLowerCase()}${data2.toLowerCase()}${data3.toLowerCase()}", digitController.text),
                              );
                            }
                          }
                          FocusScope.of(context).unfocus();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child:
                              (state is PanaByAnkLoadingState)
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
        listener: (context, state) {
          debugPrint("[All Pana] Bid State:- $state");
          if (state is BidNowPlacedState) {
            BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());

            state.apiFailureOrSuccessOption.fold(
              () => null,
              (either) => either.fold(
                (failure) {
                  final failureMessage = failure.failureMessage;
                  print("  failureMessage $failureMessage");
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
                  Navigator.pop(context);
                  await _showAlertDialog();
                },
              ),
            );
          }

          if (state is BidNowState) {
            setState(() {
              loading = false;
            });
            // state.apiFailureOrSuccessOption.fold(
            //   () => null,
            //   (either) => either.fold((failure) {
            //
            //     final failureMessage = failure.failureMessage;
            //     Fluttertoast.showToast(msg: failureMessage);
            //     showDialog(
            //       context: context,
            //       builder: (context) {
            //         return AlertDialog(
            //           title: Text(failureMessage),
            //           actions: [
            //             TextButton(
            //                 onPressed: () {
            //                   Navigator.pop(context);
            //                 },
            //                 child: Text(translate("ok"))),
            //           ],
            //         );
            //       },
            //     );
            //   }, (right) async {
            //     debugPrint("ALERT AAAAYA");
            //     await _showAlertDialog();
            //   }),
            // );
          } else if (state is PattiState && state.selectedPana != "") {
            // debugPrint("[All Pana] Bid State v222:- $state");
            // state.apiFailureOrSuccessOption.fold(
            //   () => null,
            //   (either) => either.fold((failure) {
            //     final failureMessage = failure.failureMessage;
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       SnackBar(
            //         content: Text(failureMessage),
            //         duration: const Duration(milliseconds: 1000),
            //       ),
            //     );
            //   }, (right) async {
            //     debugPrint("ALERT AAAAYA 22");
            //     await _showAlertDialog();
            //   }),
            // );
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
                                  digit: state.bidList[i].pana,
                                  pana: state.bidList[i].pana,
                                  points: state.bidList[i].points,
                                  session: state.bidList[i].session,
                                  game: state.bidList[i].mType,
                                  marketId: widget.id,
                                ),
                              );
                            }

                            // ///Call create bid
                            context.read<BidBloc>().add(
                              GetSPDPTPBidEvent(
                                id: widget.id,
                                mType: MTYPE,
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
