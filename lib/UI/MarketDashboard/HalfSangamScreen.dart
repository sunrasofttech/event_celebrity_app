import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobi_user/Bloc/PanaBloc/PanaEvent.dart';
import 'package:mobi_user/UI/AddFundScreen.dart';
import 'package:mobi_user/UI/KalyanDashBoard/bet/bidTable.dart';
import 'package:mobi_user/Utility/SimpleButton.dart';
import 'package:mobi_user/error/api_failures.dart';
import 'package:mobi_user/model/BidModel.dart' as bid_model;

import '../../Bloc/PanaBloc/PanaBloc.dart';
import '../../Bloc/PanaBloc/PanaState.dart';
import '../../Bloc/bidBloc/bidBloc.dart';
import '../../Bloc/bidBloc/bidEvent.dart';
import '../../Bloc/bidBloc/bidState.dart';
import '../../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../../Utility/AppTheme.dart';
import '../../Utility/ProgressIndicator.dart';

class HalfSangamScreen extends StatefulWidget {
  final String id;
  final String marketName;
  final String gameType;
  final bool isOnlyClose;

  const HalfSangamScreen({Key? key, required this.id, required this.gameType, required this.isOnlyClose, required this.marketName}) : super(key: key);

  @override
  State<HalfSangamScreen> createState() => _HalfSangamScreenState();
}

class _HalfSangamScreenState extends State<HalfSangamScreen> {
  HashSet<String> selectItem = HashSet();
  TextEditingController openController1 = TextEditingController();
  TextEditingController closeController1 = TextEditingController();
  TextEditingController openController2 = TextEditingController();
  TextEditingController closeController2 = TextEditingController();
  TextEditingController pointController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String gameType = "";
  bool isOpenTimeClosed = false;
  bool loading = false;

  multiSelect(String title) {
    if (selectItem.contains(title)) {
      selectItem.remove(title);
    } else {
      selectItem.clear();
      openController1.clear();
      openController2.clear();
      closeController1.clear();
      closeController2.clear();
      pointController.clear();

      selectItem.add(title);
    }
    setState(() {});
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

  @override
  void initState() {
    /* context.read<CheckOpenCloseTimeCubit>().checkOpenCloseTimeData(widget.id);*/
    BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());

    setState(() {
      gameType = widget.gameType;
      // isOpenTimeClosed = widget.isOnlyClose;
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
    openController1.dispose();
    closeController1.dispose();
    openController2.dispose();
    closeController2.dispose();
    pointController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Half Sangam")),
      body: BlocListener<PanaBloc, PanaState>(
        listener: (context, state) {
          if (state is PanaErrorState) {
            openController1.clear();
            closeController1.clear();
            pointController.clear();
            openController2.clear();
            closeController2.clear();

            Fluttertoast.showToast(msg: state.error);
            FocusScope.of(context).unfocus();
          }
        },
        child: BlocListener<BidBloc, BidState>(
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
            physics: BouncingScrollPhysics(),
            child: Form(
              key: formKey,
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
                            side: BorderSide(color: AppTheme().appColor),
                            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                            backgroundColor:
                                widget.isOnlyClose || isOpenTimeClosed
                                    ? AppTheme().greyColor
                                    : selectItem.contains("open")
                                    ? AppTheme().appColor
                                    : AppTheme().whiteColor,
                          ),
                          child: Text(
                            translate("open"),
                            style:
                                selectItem.contains("open")
                                    ? AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold)
                                    : AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if (widget.isOnlyClose || isOpenTimeClosed) {
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
                            side: BorderSide(color: AppTheme().appColor),
                            padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                            backgroundColor: selectItem.contains("close") ? AppTheme().appColor : AppTheme().whiteColor,
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
                  selectItem.contains("open")
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(children: [Text("Select Open Pana", style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold))]),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              controller: openController1,
                              inputFormatters: [
                                // FilteringTextInputFormatter.deny(
                                //   RegExp(r'^0+'), //users can't type 0 at 1st position
                                // ),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              keyboardType: TextInputType.phone,
                              maxLength: 3,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter value";
                                } else if ((int.parse(val) < 100 || int.parse(val) > 1000)) {
                                  return 'Value Should Be in between 100-999 digit';
                                } else if (val.length != 3) {
                                  return "minimum 3 digit";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                context.read<PanaBloc>().add(PanaListEvent("hsd", val));
                              },
                              decoration: InputDecoration(counterText: "", contentPadding: EdgeInsets.all(12), border: OutlineInputBorder()),
                            ),
                          ),
                          /* Visibility(
                                visible: flag1,
                                child: BlocBuilder<PanaBloc, PanaState>(builder: (context, state) {
                                  if (state is PanaLoadingState) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (state is PanaLoadedState) {
                                    return SizedBox(
                                      height: 300,
                                      child: Card(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: state.model.result.length,
                                            physics: BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    flag1 = false;
                                                    openController.text = state.model.result[index].digit.toString();
                                                  });
                                                },
                                                title: Text("${state.model.result[index].digit}"),
                                              );
                                            }),
                                      ),
                                    );
                                  }
                                  return Container();
                                })),*/
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(children: [Text("Select Close Digit", style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold))]),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              controller: closeController1,
                              maxLength: 1,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp(r'^0+'), //users can't type 0 at 1st position
                                ),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "This field is required";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              onChanged: (val) {
                                context.read<PanaBloc>().add(PanaListEvent("sd", val));
                              },
                              decoration: InputDecoration(counterText: "", contentPadding: EdgeInsets.all(12), border: OutlineInputBorder()),
                            ),
                          ),
                          /* Visibility(
                                visible: flag2,
                                child: BlocBuilder<PanaBloc, PanaState>(builder: (context, state) {
                                  if (state is PanaLoadingState) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (state is PanaLoadedState) {
                                    return SizedBox(
                                        height: 300,
                                        child: Card(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: state.model.result.length,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  onTap: () {
                                                    setState(() {
                                                      flag2 = false;
                                                      closeController.text = state.model.result[index].digit.toString();
                                                    });
                                                  },
                                                  title: Text("${state.model.result[index].digit}"),
                                                );
                                              }),
                                        ));
                                  }
                                  return Container();
                                })),*/
                        ],
                      )
                      : Container(),
                  selectItem.contains("close")
                      ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(children: [Text("Select Open Digit", style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold))]),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp(r'^0+'), //users can't type 0 at 1st position
                                ),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: closeController2,
                              keyboardType: TextInputType.phone,
                              maxLength: 1,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "This field is required";
                                }
                                return null;
                              },
                              onChanged: (val) {
                                context.read<PanaBloc>().add(PanaListEvent("sd", val));
                              },
                              decoration: InputDecoration(counterText: "", contentPadding: EdgeInsets.all(12), border: OutlineInputBorder()),
                            ),
                          ),
                          /* Visibility(
                                visible: flag2,
                                child: BlocBuilder<PanaBloc, PanaState>(builder: (context, state) {
                                  if (state is PanaLoadingState) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (state is PanaLoadedState) {
                                    return SizedBox(
                                        height: 300,
                                        child: Card(
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: state.model.result.length,
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  onTap: () {
                                                    setState(() {
                                                      flag2 = false;
                                                      closeController.text = state.model.result[index].digit.toString();
                                                    });
                                                  },
                                                  title: Text("${state.model.result[index].digit}"),
                                                );
                                              }),
                                        ));
                                  }
                                  return Container();
                                })),*/
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(children: [Text("Select Close Pana", style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold))]),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp(r'^0+'), //users can't type 0 at 1st position
                                ),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: openController2,
                              maxLength: 3,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter value";
                                } else if ((int.parse(val) < 100 || int.parse(val) > 1000)) {
                                  return 'Value Should Be in between 100-999 digit';
                                } else if (val.length != 3) {
                                  return "minimum 3 digit";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              onChanged: (val) {
                                context.read<PanaBloc>().add(PanaListEvent("hsd", val));
                              },
                              decoration: InputDecoration(counterText: "", contentPadding: EdgeInsets.all(12), border: OutlineInputBorder()),
                            ),
                          ),
                          /*   Visibility(
                                visible: flag1,
                                child: BlocBuilder<PanaBloc, PanaState>(builder: (context, state) {
                                  if (state is PanaLoadingState) {
                                    return Center(child: CircularProgressIndicator());
                                  } else if (state is PanaLoadedState) {
                                    return SizedBox(
                                      height: 300,
                                      child: Card(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: state.model.result.length,
                                            physics: BouncingScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    flag1 = false;
                                                    openController.text = state.model.result[index].digit.toString();
                                                  });
                                                },
                                                title: Text("${state.model.result[index].digit}"),
                                              );
                                            }),
                                      ),
                                    );
                                  }
                                  return Container();
                                })),*/
                        ],
                      )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(children: [Text("Enter Points", style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold))]),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp(r'^0+'), //users can't type 0 at 1st position
                        ),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                      controller: pointController,
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(12), border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: SimpleButton(
                      title: gameType == "open" ? "Open Betting".toUpperCase() : "Close Betting".toUpperCase(),
                      callback: () {
                        /*  context.read<CheckOpenCloseTimeCubit>().checkOpenCloseTimeData(widget.id);*/
                        if (selectItem.isEmpty) {
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
                        } else {
                          if (formKey.currentState!.validate()) {
                            context.read<BidBloc>().add(
                              AddBidEvent(
                                pana: openController1.text.isEmpty ? openController2.text : openController1.text,
                                price: pointController.text,
                                status: gameType,
                                digit: closeController1.text.isEmpty ? closeController2.text : closeController1.text,
                              ),
                            );

                            formKey.currentState!.reset();
                            FocusScope.of(context).unfocus();
                          }
                        }
                      },
                      style: AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                      padding: 15,
                      primaryColor: AppTheme().maroon,
                      radius: BorderRadius.circular(30),
                    ),
                  ),
                  BlocBuilder<BidBloc, BidState>(
                    builder: (context, state) {
                      if (state is BidNowState) {
                        return BidTable(code: "hsd", state: state);
                      }
                      return Container();
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BlocConsumer<BidBloc, BidState>(
        listener: (context, bidState) {
          debugPrint("[Half Sangam] Bid State:- $bidState");
          if (bidState is BidNowPlacedState) {
            setState(() {
              loading = false;
            });
          }
        },
        builder: (context, states) {
          if (states is BidNowState) {
            return Row(
              children: [
                Expanded(
                  child: Wrap(
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    direction: Axis.vertical,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: Text("\u{20B9} ${states.total}", style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text("Total Amount", style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {
                          if (loading) return;
                          /*context.read<CheckOpenCloseTimeCubit>().checkOpenCloseTimeData(widget.id);*/
                          BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
                          if (state is UserProfileFetchedState) {
                            print("Balance=> ${double.parse(state.user.data?.balance.toString() ?? "0") >= double.parse(states.total)}");
                            if (double.parse(state.user.data?.balance.toString() ?? "0") >= double.parse(states.total)) {
                              if (selectItem.isNotEmpty) {
                                setState(() {
                                  loading = false;
                                });
                                List<bid_model.Datum> data = [];
                                for (int i = 0; i < states.bidList.length; i++) {
                                  data.add(
                                    bid_model.Datum(
                                      digit: states.bidList[i].digit,
                                      pana: states.bidList[i].pana,
                                      points: states.bidList[i].points,
                                      session: gameType,
                                      game: "hsd",
                                      marketId: widget.id,
                                    ),
                                  );
                                }

                                BlocProvider.of<BidBloc>(context).add(
                                  GetBidEvent(
                                    id: widget.id,
                                    data: data,
                                    // type: gameType,
                                    // index: i,
                                    // digit: states.bidList[i].digit,
                                    // points: states.bidList[i].points,
                                    // mType: "hsd",
                                    // pana1: states.bidList[i].pana, /*pana*/
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
                          margin: EdgeInsets.zero,
                          height: 60,
                          color: AppTheme().appColor,
                          child: Center(
                            child:
                                loading
                                    ? CustomProgressIndicator()
                                    : Text(translate("continue"), style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return Container(height: 60);
        },
      ),
    );
  }
}
