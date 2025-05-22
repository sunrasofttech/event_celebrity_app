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
import '../../Utility/CustomTabBarSwitch.dart';
import '../../Utility/MainColor.dart';
import '../../Utility/Model.dart';

class DoublePanaScreen extends StatefulWidget {
  final String id;
  final String gameType;
  final String marketName;
  final bool isOnlyClose;

  const DoublePanaScreen({Key? key, required this.id, required this.gameType, required this.isOnlyClose, required this.marketName}) : super(key: key);

  @override
  State<DoublePanaScreen> createState() => _DoublePanaScreenState();
}

class _DoublePanaScreenState extends State<DoublePanaScreen> {
  HashSet<String> selectItem = HashSet();
  HashSet<String> chooseItem = HashSet();
  String gameType = "open";
  List<TextEditingController> controllers = [];
  List<Model> _controller = [];
  double total = 0;

  bool isOpenTimeClosed = false;
  bool loading = false;

  //
  final TextEditingController digitController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  int _selectedIndex = 0;
  int customId = 999;

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  void _updateSingleBid() {
    String digit = digitController.text.trim();
    String amount = amountController.text.trim();

    // Remove any existing entry with the same ID
    _controller.removeWhere((element) => element.id == customId);

    // Only add if both fields are filled
    if (digit.isNotEmpty && amount.isNotEmpty) {
      _controller.add(Model(id: customId, amount: amount, digit: digit, type: gameType));

      setState(() {}); // Update UI
    }
  }

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
    _controller.clear();
    super.dispose();
  }

  minimumBidAmountAlert(SettingLoadedState settingState) {
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
                "Minimum Bid Amount Must Be Greater Than \u{20B9} ${settingState.model.data![0].minimumJdBidAmount.toString()}",
                style: blackStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: maroonColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
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
  }

  insufficientBalanceAlert() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF2F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(decoration: blueBoxDecoration()),
        title: Text("Double Pana"),
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

                    SizedBox(height: 10),
                    CustomTabSwitcher(selectedIndex: _selectedIndex, onTabSelected: _onTabSelected),
                    SizedBox(height: 10),

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
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child:
                    _selectedIndex == 0
                        ? Column(
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
                                          borderRadius:
                                              chooseItem.contains(index == 9 ? "0" : "${index + 1}") ? BorderRadius.circular(10) : BorderRadius.zero,
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
                                      : GridView.builder(
                                        itemCount: state.model.data?.length ?? 0,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(childAspectRatio: 3, crossAxisCount: 2),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.all(10),
                                            child: TextFormField(
                                              controller: controllers[index],
                                              style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold),
                                              keyboardType: TextInputType.phone,
                                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                              onChanged: (val) {
                                                print("Val ${val}");

                                                if (_controller.isEmpty) {
                                                  debugPrint("--- new Addition");
                                                  _controller.add(
                                                    Model(id: index, amount: val, digit: state.model.data?[index].digit ?? "", type: gameType),
                                                  );
                                                } else {
                                                  ///If value is not added
                                                  if (_controller.where((element) => element.id == index).isEmpty) {
                                                    debugPrint("--- new Addition else condition");
                                                    _controller.add(
                                                      Model(id: index, amount: val, digit: state.model.data?[index].digit ?? "", type: gameType),
                                                    );
                                                  } else {
                                                    ///If value already present then update
                                                    debugPrint("--- value present Updating else condition");
                                                    _controller.removeWhere((element) => element.id == index);
                                                    if (val.isNotEmpty) {
                                                      debugPrint("--- value is present & not empty so Updating else condition");
                                                      _controller.add(
                                                        Model(id: index, amount: val, digit: state.model.data?[index].digit ?? "", type: gameType),
                                                      );
                                                    }
                                                  }
                                                }
                                                Future.delayed(Duration(milliseconds: 500), () {
                                                  setState(() {});
                                                });
                                              },
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 40),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(color: AppTheme().greyColor),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: AppTheme().greyColor),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: AppTheme().greyColor),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                prefixIcon: Container(
                                                  width: 60,
                                                  height: 60,
                                                  margin: EdgeInsets.only(right: 20),
                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppTheme().greyColor),
                                                  child: Center(
                                                    child: Text(
                                                      "${state.model.data?[index].digit}",
                                                      style: AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                }
                                return Container();
                              },
                            ),
                          ],
                        )
                        : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            bidTextField(
                              prefixText: "Add Bid Number",
                              controller: digitController,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                              onChanged: (digitVal) {
                                final cleaned = digitVal.trim();

                                if (cleaned.length > 3) {
                                  digitController.text = cleaned.substring(0, 3);
                                  digitController.selection = TextSelection.collapsed(offset: 3);
                                  Fluttertoast.showToast(msg: "Digits must be 3 characters only");
                                  return;
                                }

                                if (cleaned.length == 3) {
                                  final digits = cleaned.split('').map(int.parse).toList();

                                  // Rule 1: All digits should not be the same
                                  final allSame = digits.every((d) => d == digits[0]);
                                  if (allSame) {
                                    digitController.clear();
                                    Fluttertoast.showToast(msg: "All digits should not be the same.");
                                    return;
                                  }

                                  // Rule 2: Digits must be in increasing order (allowing repeated digits)
                                  for (int i = 0; i < digits.length - 1; i++) {
                                    if (digits[i] > digits[i + 1]) {
                                      digitController.clear();
                                      Fluttertoast.showToast(msg: "Digits must be in increasing order.");
                                      return;
                                    }
                                  }
                                }

                                _updateSingleBid();
                              },
                            ),
                            bidTextField(
                              prefixText: "Add Amount",
                              controller: amountController,
                              onChanged: (digitVal) {
                                _updateSingleBid();
                              },
                            ),
                          ],
                        ),
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
                            if (_selectedIndex == 1 && digitController.text.length != 3) {
                              Fluttertoast.showToast(msg: "Digit should be of 3 characters");
                              return;
                            }
                            if (_selectedIndex == 1 && amountController.text.isEmpty) {
                              Fluttertoast.showToast(msg: "Please Add Amount");
                              return;
                            }
                            /* context.read<CheckOpenCloseTimeCubit>().checkOpenCloseTimeData(widget.id);*/
                            if (state is UserProfileFetchedState) {
                              total = calculateTotal();
                              print(
                                "Balance=> ${double.parse(state.user.data?.balance.toString() ?? "0")} "
                                "Check Condition => ${double.parse(state.user.data?.balance.toString() ?? "0").truncate() >= total.truncate()}",
                              );

                              if (_selectedIndex == 1 &&
                                  int.parse(settingState.model.data![0].minimumJdBidAmount.toString()) >= int.parse(amountController.text)) {
                                minimumBidAmountAlert(settingState);
                                return;
                              }
                              if (_selectedIndex == 1 &&
                                  double.parse(state.user.data?.balance.toString() ?? "0").truncate() <=
                                      double.parse(amountController.text).truncate()) {
                                insufficientBalanceAlert();
                                return;
                              }

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
                                      /* print("${int.parse(settingState.model.data![0].minimumSdBidAmount.toString())<=int.parse(item.amount)}");
                                  print("Length=>${context.read<BidBloc>().state}");
                                  var state=context.read<BidBloc>().state;
                                  if(state is BidNowState){
                                    context.read<BidBloc>().add(DeleteBid(index: i));
                                  }*/
                                      minimumBidAmountAlert(settingState);
                                      break;
                                    }
                                    print(item.type);
                                  }
                                  for (final controller in controllers) {
                                    controller.clear();
                                  }
                                  _controller.clear();
                                  amountController.clear();
                                  digitController.clear();
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
                                insufficientBalanceAlert();
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
                              insufficientBalanceAlert();
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
