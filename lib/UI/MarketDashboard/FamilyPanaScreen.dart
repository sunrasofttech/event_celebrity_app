import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobi_user/Bloc/PattiListBloc/PattiListBloc.dart';
import 'package:mobi_user/Bloc/PattiListBloc/PattiListEvent.dart';
import 'package:mobi_user/Bloc/bidBloc/bidBloc.dart';
import 'package:mobi_user/Bloc/bidBloc/bidState.dart';
import 'package:mobi_user/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import 'package:mobi_user/UI/AddFundScreen.dart';
import 'package:mobi_user/Utility/CustomFont.dart';
import 'package:mobi_user/Utility/ProgressIndicator.dart';
import 'package:mobi_user/error/api_failures.dart';

import '../../Bloc/bidBloc/bidEvent.dart';
import '../../Utility/AppTheme.dart';
import '../../Utility/MainColor.dart';

class FamilyPanaScreen extends StatefulWidget {
  final String id;
  final String gameType;
  final String marketName;
  final bool isOnlyClose;

  const FamilyPanaScreen({Key? key, required this.isOnlyClose, required this.id, required this.gameType, required this.marketName}) : super(key: key);

  @override
  State<FamilyPanaScreen> createState() => _FamilyPanaScreenState();
}

class _FamilyPanaScreenState extends State<FamilyPanaScreen> {
  HashSet<String> selectItem = HashSet();
  HashSet<String> chooseItem = HashSet();
  List<String> panaList = [];
  GlobalKey<FormFieldState> dropdownKey = GlobalKey<FormFieldState>();
  String gameType = "open";
  var data;
  GlobalKey<FormState> pattiKey = GlobalKey<FormState>();
  late TextEditingController panaController;
  late TextEditingController priceController;

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

    context.read<BidBloc>().add(InitialBidEvent());
    context.read<PattiListBloc>().add(FetchPattiEvent("fp", ""));
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
    panaController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF2F6),
      appBar: AppBar(flexibleSpace: Container(decoration: blueBoxDecoration()), backgroundColor: Colors.transparent, title: Text("Family Pana")),
      body: BlocListener<BidBloc, BidState>(
        listener: (context, state) {
          if (state is BidNowState) {
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
                  Navigator.pop(context);
                  await _showAlertDialog();
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
                BlocBuilder<BidBloc, BidState>(
                  builder: (context, state) {
                    if (state is PattiState) {
                      return Center(child: Text(state.pitties, style: blackStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w900)));
                    }
                    return Container();
                  },
                ),
                /*  BlocListener<BidBloc, BidState>(
                        listener: (context, state) {
                          if (state is PattiState) {
                            for (int i = 0; i < state.suggestionList.length; i++) {
                              dropdownList.add(state.suggestionList[i]);
                            }
                          }
                        },
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: DropdownButtonFormField(
                                menuMaxHeight: 200,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: InputDecoration(
                                  hintText: "Select Pana",
                                  contentPadding: EdgeInsets.all(15),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onChanged: (val) {
                                  if (val != null) {
                                    context.read<BidBloc>().add(GetPittiesEvent(type: "fp", pana: val));
                                  }
                                },
                                items: List.generate(
                                    dropdownList.length,
                                    (index) => DropdownMenuItem(
                                        onTap: () {
                                          setState(() {
                                            panaController.text = dropdownList[index];
                                          });
                                        },
                                        value: dropdownList[index],
                                        child: Text(dropdownList[index]))).toList()))),*/
                /*Padding(
                  padding: EdgeInsets.all(10),
                  child: BlocBuilder<PattiListBloc, PattiListState>(
                    builder: (context, state) {
                      if (state is LoadedPattiState) {
                        return DropdownButtonFormField(
                            key: dropdownKey,
                            icon: Icon(Icons.keyboard_arrow_down),
                            menuMaxHeight: 200,
                            padding: EdgeInsets.all(10),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              hintText: "Select Pana",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            onChanged: (val) {
                              if (val != null) {
                                context.read<BidBloc>().add(GetPittiesEvent(type: "fp", pana: val.toString()));
                              }
                            },
                            items: List.generate(
                                    state.model.result.length,
                                    (index) => DropdownMenuItem(
                                        onTap: () {
                                          setState(() {
                                            panaController.text = state.model.result[index].numbers;
                                          });
                                        },
                                        value: state.model.result[index].numbers,
                                        child: Text(state.model.result[index].numbers,
                                            style: blackStyle.copyWith(fontWeight: FontWeight.w900, fontSize: 16))))
                                .toList());
                      }
                      return Container();
                    },
                  ),
                ),*/
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
                      // FilteringTextInputFormatter.deny(
                      //   RegExp(r'^0+'), //users can't type 0 at 1st position
                      // ),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: "Enter Point",
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: AppTheme().maroon,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Generate", style: AppTheme().whiteStyle)]),
                    ),
                    onPressed: () {
                      if (priceController.text.isEmpty) return;

                      context.read<BidBloc>().add(InitialBidEvent());
                      context.read<PattiListBloc>().add(FetchPattiEvent("fp", priceController.text));
                      if (pattiKey.currentState!.validate()) {
                        var state = context.read<BidBloc>().state;
                        if (state is PattiState) {
                          print("Bid Data ${state.pitties.split(",").length}");
                          panaList.clear();

                          panaList = state.pitties.split(",");
                          total = double.parse(state.total);
                          totalBid = panaList.length;
                          for (int i = 0; i < panaList.length; i++) {
                            context.read<BidBloc>().add(
                              AddBidEvent(digit: panaController.text, price: priceController.text, status: gameType, pana: panaList[i]),
                            );
                          }
                        } else {
                          Fluttertoast.showToast(msg: "Please Select Pana");
                        }
                        dropdownKey.currentState!.reset();
                        FocusScope.of(context).unfocus();
                        priceController.clear();
                        panaController.clear();
                      }
                    },
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
                              for (int i = 0; i < state.bidList.length; i++) {
                                context.read<BidBloc>().add(
                                  PlaceBudEventerForPitties(
                                    marketId: widget.id,
                                    digit: state.bidList[i].digit,
                                    mType: "fp",
                                    pana1: panaList[i],
                                    points: state.bidList[i].points,
                                    gameStatus: gameType,
                                  ),
                                );
                              }
                            });
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(translate("insufficient_balance"), style: AppTheme().blackStyle),
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
                    child:
                        loading
                            ? CustomProgressIndicator()
                            : Text(translate("submit"), style: AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold)),
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
