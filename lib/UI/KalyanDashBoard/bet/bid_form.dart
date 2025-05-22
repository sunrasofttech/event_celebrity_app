import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingCubit.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingState.dart';
import 'package:mobi_user/Bloc/SuggestionListBloc/SuggestionListBloc.dart';
import 'package:mobi_user/Bloc/SuggestionListBloc/SuggestionListEvent.dart';

import '../../../Bloc/MarketBloc/MarketModel.dart';
import '../../../Bloc/SuggestionListBloc/SuggestionListState.dart';
import '../../../Bloc/bidBloc/bidBloc.dart';
import '../../../Bloc/bidBloc/bidEvent.dart';
import '../../../Bloc/bidBloc/bidState.dart';
import '../../../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../../../Utility/AppTheme.dart';
import '../../../Utility/CustomFont.dart';
import '../../../Utility/MainColor.dart';
import '../../../Widget/ButtonWidget.dart';
import '../../../model/gameType.dart';
import '../../AddFundScreen.dart';

class BidForm extends StatefulWidget {
  String statusCode;
  BidNowState? bidState;
  GameType gameType;
  MarketModel market;
  int index;
  bool isOnlyClose;

  BidForm({
    super.key,
    required this.statusCode,
    this.bidState,
    required this.index,
    required this.gameType,
    required this.market,
    required this.isOnlyClose,
  });

  @override
  State<BidForm> createState() => _BidFormState();
}

class _BidFormState extends State<BidForm> {
  String game = "open";
  bool hsdFlag1 = false;
  bool hsdFlag2 = false;
  bool fsdFlag1 = false;
  bool fsdFlag2 = false;
  TextEditingController pointsController = new TextEditingController();
  TextEditingController digitController = new TextEditingController();
  TextEditingController pana1Controller = new TextEditingController();
  TextEditingController pana2Controller = new TextEditingController();

  bool verifyDoublePana(value) {
    if (widget.statusCode == "dp" &&
        (int.parse(value) < 100 ||
            int.parse(value) > 1000 ||
            value.length > 3 ||
            (value[0] == value[1] && value[0] == value[2] && value[1] == value[2]))) {
      return true;
    }

    if ((value[0] == value[1]) || (value[1] == value[2]) || (value[0] == value[2])) {
      return false;
    } else {
      return true;
    }
  }

  String uid = "";

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (widget.isOnlyClose) {
      game = "close";
    }
  }

  @override
  void initState() {
    context.read<SuggestionListBloc>().add(SuggestionListInitEvent());
    context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  bool digitEnabled = true;

  @override
  Widget build(BuildContext context) {
    log(widget.statusCode);
    return BlocListener<SuggestionListBloc, SuggestionListState>(
      listener: (context, state) {
        if (state is ErrorState) {
          digitController.clear();
          pana1Controller.clear();
          pana2Controller.clear();
          FocusScope.of(context).unfocus();
          Fluttertoast.showToast(msg: state.error);
        }
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(widget.market.data?[widget.index].marketName ?? "", style: AppTheme().pinkStyle.copyWith(fontWeight: FontWeight.bold)),
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
                padding: const EdgeInsets.all(8.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [Text(translate("choose_session"), style: blackStyle)]),
              ),
              Visibility(
                visible:
                    widget.gameType.name.toString().toUpperCase() == "FULL SANGAM" || widget.gameType.name.toString().toUpperCase() == "JODI DIGIT"
                        ? false
                        : true,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: Text(translate("open"), style: blackStyle),
                          value: "open",
                          groupValue: game,
                          onChanged: (value) {
                            if (widget.isOnlyClose) {
                            } else {
                              setState(() {
                                game = value.toString();
                              });
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: Text("close ", style: blackStyle),
                          value: "close",
                          groupValue: game,
                          onChanged: (value) {
                            setState(() {
                              game = value.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              widget.statusCode == "hsd" || widget.statusCode == "fsd"
                  ? Container()
                  : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: blackStyle,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      cursorColor: whiteColor,
                      controller: digitController,
                      maxLength:
                          widget.statusCode == "sd"
                              ? 1
                              : widget.statusCode == "jd"
                              ? 2
                              : widget.statusCode == "sp" || widget.statusCode == "dp" || widget.statusCode == "tp"
                              ? 3
                              : null,
                      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (widget.statusCode == "sd" && int.parse(value) > 10) {
                          return 'Value Should Be in one digit';
                        }
                        if (widget.statusCode == "hsd" && int.parse(value) > 10) {
                          return 'Value Should Be in one digit';
                        }
                        if (widget.statusCode == "jd" && value.length == 1) {
                          return 'Value Should Be in one digit';
                        }

                        if (widget.statusCode == "sp" && (int.parse(value) < 100 || int.parse(value) > 1000)) {
                          return 'Value Should Be in between 100-999 digit';
                        }
                        if (widget.statusCode == "tp" &&
                            (int.parse(value) < 100 || int.parse(value) > 1000 || value.length > 3 || value[0] != value[1] || value[0] != value[2])) {
                          if (value == "000") {
                            return null;
                          }
                          return 'Value Should for eg 777, 888';
                        }
                        if (widget.statusCode == "fsd" && (int.parse(value) < 100 || int.parse(value) > 1000) && value.length < 3) {
                          return 'Value Should be in range of 100-999';
                        }
                        if (widget.statusCode == "dp") {
                          if (verifyDoublePana(value)) {
                            return 'Value Should for eg 777, 888';
                          }
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (widget.statusCode == "jd") {
                          if (value.length == 2) {
                            context.read<SuggestionListBloc>().add(SuggestionListLoadEvent(digit: value, type: widget.statusCode));
                          }
                        } else {
                          context.read<SuggestionListBloc>().add(SuggestionListLoadEvent(digit: value, type: widget.statusCode));
                        }
                        if (widget.statusCode == "sd" || widget.statusCode == "hsd") {
                          if (value.length > 1) {
                            digitController.text = value.substring(0, value.length - 1);
                          }
                        } else if (widget.statusCode == "jd") {
                          if (value.length > 2) {
                            digitController.text = value.substring(0, value.length - 1);
                          }
                        } else {
                          if (value.length > 3) {
                            digitController.text = value.substring(0, value.length - 1);
                          }
                        }
                      },
                      decoration: InputDecoration(
                        counterText: "",
                        label: Text(widget.gameType.name == "FULL SANGAM" ? "Enter Open Panna" : "Enter Close Digit"),
                        hintStyle: blackStyle,
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme().greyColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme().greyColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
              Visibility(
                visible: widget.statusCode == "hsd" && game == "open",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          style: blackStyle,
                          cursorColor: whiteColor,
                          controller: pana1Controller,
                          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                          maxLength: 3,
                          onTap: () {
                            hsdFlag1 = false;
                            hsdFlag2 = true;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }

                            if ((int.parse(value) < 100 || int.parse(value) > 1000) && value.length < 3) {
                              return 'Value Should Be in between 100-999 digit';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            context.read<SuggestionListBloc>().add(SuggestionListLoadEvent(digit: val, type: "hsd"));
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme().greyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme().greyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            hintStyle: blackStyle,
                            labelText: game == "open" ? "Enter Open pana" : "Enter Close Digit",
                          ),
                        ),
                      ),
                    ),
                    Text("X", style: blackStyle),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: blackStyle,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          cursorColor: whiteColor,
                          controller: digitController,
                          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (widget.statusCode == "sd" && int.parse(value) > 10) {
                              return 'Value Should Be in one digit';
                            }
                            if (widget.statusCode == "hsd" && int.parse(value) > 10) {
                              return 'Value Should Be in one digit';
                            }
                            if (widget.statusCode == "jd" && value.length == 1) {
                              return 'Value Should Be in one digit';
                            }

                            if (widget.statusCode == "sp" && (int.parse(value) < 100 || int.parse(value) > 1000)) {
                              return 'Value Should Be in between 100-999 digit';
                            }
                            if (widget.statusCode == "tp" &&
                                (int.parse(value) < 100 ||
                                    int.parse(value) > 1000 ||
                                    value.length > 3 ||
                                    value[0] != value[1] ||
                                    value[0] != value[2])) {
                              if (value == "000") {
                                return null;
                              }
                              return 'Value Should for eg 777, 888';
                            }
                            if (widget.statusCode == "fsd" && (int.parse(value) < 100 || int.parse(value) > 1000) && value.length < 3) {
                              return 'Value Should be in range of 100-999';
                            }
                            if (widget.statusCode == "dp") {
                              if (verifyDoublePana(value)) {
                                print(value[0] != value[1]);
                                return 'Value Should for eg 777, 888';
                              }
                            }
                            return null;
                          },
                          onChanged: (value) {
                            context.read<SuggestionListBloc>().add(SuggestionListLoadEvent(digit: value, type: "sd"));
                            if (widget.statusCode == "sd" || widget.statusCode == "hsd") {
                              if (value.length > 1) {
                                digitController.text = value.substring(0, value.length - 1);
                              }
                            } else if (widget.statusCode == "jd") {
                              if (value.length > 2) {
                                digitController.text = value.substring(0, value.length - 1);
                              }
                            } else {
                              if (value.length > 3) {
                                digitController.text = value.substring(0, value.length - 1);
                              }
                            }
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            label: Text(widget.gameType.name == "FULL SANGAM" ? "Enter Open Panna" : "Enter Close Digit"),
                            hintStyle: blackStyle,
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme().greyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme().greyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onTap: () {
                            hsdFlag1 = true;
                            hsdFlag2 = false;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.statusCode == "hsd" && game == "close",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: blackStyle,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          cursorColor: whiteColor,
                          controller: digitController,
                          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (widget.statusCode == "sd" && int.parse(value) > 10) {
                              return 'Value Should Be in one digit';
                            }
                            if (widget.statusCode == "hsd" && int.parse(value) > 10) {
                              return 'Value Should Be in one digit';
                            }
                            if (widget.statusCode == "jd" && int.parse(value) > 100) {
                              return 'Value Should Be in one digit';
                            }

                            if (widget.statusCode == "sp" && (int.parse(value) < 100 || int.parse(value) > 1000)) {
                              return 'Value Should Be in between 100-999 digit';
                            }
                            if (widget.statusCode == "tp" &&
                                (int.parse(value) < 100 ||
                                    int.parse(value) > 1000 ||
                                    value.length > 3 ||
                                    value[0] != value[1] ||
                                    value[0] != value[2])) {
                              if (value == "000") {
                                return null;
                              }
                              return 'Value Should for eg 777, 888';
                            }
                            if (widget.statusCode == "fsd" && (int.parse(value) < 100 || int.parse(value) > 1000) && value.length < 3) {
                              return 'Value Should be in range of 100-999';
                            }
                            if (widget.statusCode == "dp") {
                              if (verifyDoublePana(value)) {
                                print(value[0] != value[1]);
                                return 'Value Should for eg 777, 888';
                              }
                            }
                            return null;
                          },
                          onChanged: (value) {
                            context.read<SuggestionListBloc>().add(SuggestionListLoadEvent(digit: value, type: "sd"));
                            if (widget.statusCode == "sd" || widget.statusCode == "hsd") {
                              if (value.length > 1) {
                                digitController.text = value.substring(0, value.length - 1);
                              }
                            } else if (widget.statusCode == "jd") {
                              if (value.length > 2) {
                                digitController.text = value.substring(0, value.length - 1);
                              }
                            } else {
                              if (value.length > 3) {
                                digitController.text = value.substring(0, value.length - 1);
                              }
                            }
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            label: Text(widget.gameType.name == "FULL SANGAM" ? "Enter Open Panna" : "Enter Open Digit"),
                            hintStyle: blackStyle,
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(borderSide: const BorderSide(color: maroonColor), borderRadius: BorderRadius.circular(10)),
                          ),
                          onTap: () {
                            hsdFlag1 = true;
                            hsdFlag2 = false;
                          },
                        ),
                      ),
                    ),
                    Text("X", style: blackStyle),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: blackStyle,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          cursorColor: whiteColor,
                          controller: pana1Controller,
                          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                          maxLength: 3,
                          onTap: () {
                            hsdFlag1 = false;
                            hsdFlag2 = true;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }

                            if ((int.parse(value) < 100 || int.parse(value) > 1000) && value.length < 3) {
                              return 'Value Should Be in between 100-999 digit';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            context.read<SuggestionListBloc>().add(SuggestionListLoadEvent(digit: val, type: "hsd"));
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme().greyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme().greyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.all(10),
                            hintStyle: blackStyle,
                            labelText: game == "open" ? "Enter Open pana" : "Enter Close pana",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.statusCode == "fsd",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: blackStyle,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          cursorColor: whiteColor,
                          controller: digitController,
                          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if (widget.statusCode == "sd" && int.parse(value) > 10) {
                              return 'Value Should Be in one digit';
                            }
                            if (widget.statusCode == "hsd" && int.parse(value) > 10) {
                              return 'Value Should Be in one digit';
                            }
                            if (widget.statusCode == "jd" && value.length == 1) {
                              return 'Value Should Be in one digit';
                            }

                            if (widget.statusCode == "sp" && (int.parse(value) < 100 || int.parse(value) > 1000)) {
                              return 'Value Should Be in between 100-999 digit';
                            }
                            if (widget.statusCode == "tp" &&
                                (int.parse(value) < 100 ||
                                    int.parse(value) > 1000 ||
                                    value.length > 3 ||
                                    value[0] != value[1] ||
                                    value[0] != value[2])) {
                              if (value == "000") {
                                return null;
                              }
                              return 'Value Should for eg 777, 888';
                            }
                            if (widget.statusCode == "fsd" && (int.parse(value) < 100 || int.parse(value) > 1000) && value.length < 3) {
                              return 'Value Should be in range of 100-999';
                            }
                            if (widget.statusCode == "dp") {
                              if (verifyDoublePana(value)) {
                                print(value[0] != value[1]);
                                return 'Value Should for eg 777, 888';
                              }
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (widget.statusCode == "sd" || widget.statusCode == "hsd") {
                              if (value.length > 1) {
                                digitController.text = value.substring(0, value.length - 1);
                              }
                            } else if (widget.statusCode == "jd") {
                              if (value.length > 2) {
                                digitController.text = value.substring(0, value.length - 1);
                              }
                            } else {
                              if (value.length > 3) {
                                digitController.text = value.substring(0, value.length - 1);
                              }
                            }
                            context.read<SuggestionListBloc>().add(SuggestionListLoadEvent(digit: value, type: "fsd"));
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            labelText: "Enter Open Pana",
                            hintStyle: blackStyle,
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme().greyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme().greyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onTap: () {
                            fsdFlag1 = true;
                            fsdFlag2 = false;
                          },
                        ),
                      ),
                    ),
                    Text("X", style: blackStyle),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          style: blackStyle,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          cursorColor: whiteColor,
                          controller: pana1Controller,
                          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                          maxLength: 3,
                          onTap: () {
                            fsdFlag2 = true;
                            fsdFlag1 = false;
                          },
                          onChanged: (val) {
                            context.read<SuggestionListBloc>().add(SuggestionListLoadEvent(digit: val, type: "fsd"));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            if ((int.parse(value) < 100 || int.parse(value) > 1000) && value.length < 3) {
                              return 'Value Should Be in between 100-999 digit';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding: const EdgeInsets.all(10),
                            hintStyle: blackStyle,
                            labelText: "Enter Close pana",
                            border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme().greyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme().greyColor),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: blackStyle,
                  cursorColor: whiteColor,
                  controller: pointsController,
                  inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^0+')), FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    /*else if(int.parse(value)>=0){
                      return 'Please enter valid point';
                    }*/
                    return null;
                  },
                  decoration: InputDecoration(
                    label: Text("Enter Bid Points"),
                    hintStyle: blackStyle,
                    prefixText: "\u{20B9}",
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(10)),
                  ),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<SettingCubit, SettingState>(
                builder: (context, userState) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonWidget(
                      title: Text("Add", style: whiteStyle),
                      primaryColor: maroonColor,
                      callback: () async {
                        BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
                        if (_formKey.currentState!.validate()) {
                          var state = BlocProvider.of<UserProfileBlocBloc>(context).state;
                          if (state is UserProfileFetchedState) {
                            print(double.parse(pointsController.text).toDouble());
                            var totalValue = 0.0;
                            if (widget.bidState != null) {
                              totalValue = double.parse(widget.bidState!.total) + double.parse(pointsController.text);
                            } else {
                              totalValue = double.parse(pointsController.text).toDouble();
                            }
                            if (double.parse(state.user.data?.balance.toString() ?? "0") >= totalValue) {
                              if (userState is SettingLoadedState) {
                                if (widget.statusCode == "hsd") {
                                  if (int.parse(userState.model.data![0].minimumHsdBidAmount.toString()) <= int.parse(pointsController.text)) {
                                    BlocProvider.of<BidBloc>(context).add(
                                      AddBidEvent(
                                        digit: digitController.text, //'99',
                                        price: pointsController.text, //'10',
                                        status: game,
                                        pana: pana1Controller.text,
                                      ),
                                    );
                                  } else {
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
                                                "Minimum Bid Amount Must Be Greater Than \u{20B9} ${userState.model.data![0].minimumHsdBidAmount.toString()}",
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
                                  }
                                }
                                if (widget.statusCode == "fsd") {
                                  if (int.parse(userState.model.data![0].minimumFsdBidAmount.toString()) <= totalValue) {
                                    BlocProvider.of<BidBloc>(context).add(
                                      AddBidEvent(
                                        digit: digitController.text, //'99',
                                        price: pointsController.text, //'10',
                                        status: game,
                                        pana: pana1Controller.text,
                                      ),
                                    );
                                  } else {
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
                                                "Minimum Bid Amount Must Be Greater Than \u{20B9} ${userState.model.data![0].minimumFsdBidAmount.toString()}",
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
                                  }
                                }
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    insetPadding: EdgeInsets.zero,
                                    title: Text("Insufficient Balance", style: blackStyle),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"),
                                      ),
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
                          } else {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(const SnackBar(content: Text("Please try again later"), duration: Duration(milliseconds: 1000)));
                          }
                          FocusScope.of(context).unfocus();
                          pointsController.clear();
                          digitController.clear();
                          pana2Controller.clear();
                          pana1Controller.clear();
                        }
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
