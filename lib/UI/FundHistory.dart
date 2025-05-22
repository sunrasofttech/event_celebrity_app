import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import '../Bloc/AccountBloc/AccountCubit.dart';
import '../Bloc/AccountBloc/AccountState.dart';
import '../Utility/CustomFont.dart';
import '../Utility/MainColor.dart';
import '../Widget/ButtonWidget.dart';

class FundHistory extends StatefulWidget {
  const FundHistory({super.key});
  @override
  State<FundHistory> createState() => _FundHistoryState();
}

class _FundHistoryState extends State<FundHistory> {
  String startDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  String endDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  int pageSize = 40;
  int _pageKey = 1;

  @override
  void initState() {
    context.read<AccountCubit>().getHistory(_pageKey, startDate, endDate);
    super.initState();
  }

  @override
  void dispose() {
    /* _pagingController.dispose();*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: blueBoxDecoration()),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(translate("transaction_history")),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          translate("start_date"),
                          style: blackStyle.copyWith(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: blackColor)),
                          child: ListTile(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  startDate = formattedDate; //set output date to TextField value.
                                });
                              }
                            },
                            leading: Icon(Icons.calendar_month, color: primaryColor),
                            title: Text(startDate, style: whiteStyle.copyWith(color: primaryColor, fontSize: 12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          translate("end_date"),
                          style: blackStyle.copyWith(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: blackColor)),
                          child: ListTile(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                //DateTime.now() - not to allow to choose before today.
                                lastDate: DateTime(2100),
                              );

                              if (pickedDate != null) {
                                print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  endDate = formattedDate; //set output date to TextField value.
                                });
                              }
                            },
                            leading: Icon(Icons.calendar_month, color: primaryColor),
                            title: Text(endDate, style: blackStyle.copyWith(fontSize: 12, color: primaryColor)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ButtonWidget(
            elevation: 0,
            title: Text(translate("submit"), style: whiteStyle),
            primaryColor: playColor,
            callback: () async {
              setState(() {
                _pageKey = 1;
              });
              context.read<AccountCubit>().getHistory(_pageKey.toInt(), startDate, endDate);
            },
          ),
          Expanded(
            child: BlocBuilder<AccountCubit, AccountState>(
              builder: (context, state) {
                if (state is ErrorState) {
                  return Center(child: Text(state.error));
                }

                if (state is LoadingState) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is LoadedState) {
                  return state.model.data?.isEmpty ?? true
                      ? Center(child: Text("No Data Found"))
                      : RefreshIndicator(
                        onRefresh: () async {
                          context.read<AccountCubit>().getHistory(_pageKey.toInt(), startDate, endDate);
                        },
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          itemCount: state.model.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = state.model.data?[index];
                            log("Transaaction typeeee:------- ${item?.transactionType?.toLowerCase()}");
                            final isCredit = true;
                            // item?.transactionType?.toLowerCase() == "addmoney" ||
                            // item?.transactionType?.toLowerCase() == "adminaddmoney"; // Adjust condition as per actual data
                            final icon =
                                isCredit
                                    ? "asset/icons/up_arrow.png" // Replace with actual credit icon path
                                    : "asset/icons/down_arrow.png"; // Replace with actual debit icon path

                            return Container(
                              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), spreadRadius: 2, blurRadius: 6, offset: Offset(0, 3))],
                              ),
                              child: Row(
                                children: [
                                  Image.asset(icon, width: 24, height: 24),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item?.transactionType ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 4),
                                        Text("${item?.message ?? ""} ₹${item?.points ?? ""}", style: TextStyle(color: Colors.black87, fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    item?.status == "ACCEPT" ? "Success" : "${item?.status ?? "Success"}",
                                    style: TextStyle(
                                      color:
                                          item?.status == "ACCEPT" || item?.status == null
                                              ? Colors.green
                                              : item?.status == "REJECT"
                                              ? Colors.red
                                              : item?.status == "PENDING"
                                              ? Colors.orange
                                              : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                            // final item = state.model.data?[index];
                            return Card(
                              child: ListTile(
                                horizontalTitleGap: 0,
                                title: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item?.transactionType.toString().substring(0, 1).toUpperCase()}"
                                      "${item?.transactionType.toString().substring(1, item.transactionType?.length)}",
                                      style: blackStyle,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text("${item?.message ?? ""} \u{20B9} ${item?.points}", style: blackStyle.copyWith(fontSize: 14)),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    DateFormat("yyyy/MM/dd hh:mm a").format(DateTime.parse("${item?.date ?? ""}")),
                                    style: blackStyle.copyWith(fontSize: 14),
                                  ),
                                ),
                                trailing: Text(
                                  item?.status == "ACCEPT" ? "Success" : "${item?.status ?? "Success"}",
                                  style:
                                      item?.status == "ACCEPT" || item?.status == null
                                          ? greenStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16)
                                          : item?.status == "REJECT"
                                          ? redStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16)
                                          : item?.status == "PENDING"
                                          ? amberStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16)
                                          : blackStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                }
                return Center(child: Text("No Data Found"));
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            shadowWidget(
              child: BlocBuilder<AccountCubit, AccountState>(
                builder: (context, state) {
                  if (state is LoadedState) {
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.grey,

                        backgroundColor: const Color(0xFFF6F9FC),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      icon: Icon(Icons.keyboard_double_arrow_left),
                      onPressed:
                          state.model.totalPages == 0
                              ? null
                              : () {
                                if (_pageKey > 0) {
                                  setState(() {
                                    _pageKey--;
                                  });
                                  context.read<AccountCubit>().getHistory(_pageKey, startDate, endDate);
                                }
                              },
                      label: Text(translate("previous")),
                    );
                  }
                  return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.grey,

                      backgroundColor: const Color(0xFFF6F9FC),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    icon: Icon(Icons.keyboard_double_arrow_left),
                    onPressed: null,
                    label: Text(translate("previous")),
                  );
                },
              ),
            ),
            BlocBuilder<AccountCubit, AccountState>(
              builder: (context, state) {
                if (state is LoadedState) {
                  return Text("${_pageKey}/${state.model.totalPages}");
                }
                return Text("");
              },
            ),
            shadowWidget(
              child: BlocBuilder<AccountCubit, AccountState>(
                builder: (context, state) {
                  if (state is LoadedState) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF6F9FC),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed:
                          pageSize == state.model.totalPages
                              ? null
                              : () {
                                if (_pageKey >= 0) {
                                  setState(() {
                                    _pageKey++;
                                  });
                                  context.read<AccountCubit>().getHistory(_pageKey, startDate, endDate);
                                }
                              },
                      child: Row(
                        children: [Text(translate("next"), style: TextStyle(color: lightTextColor)), Icon(Icons.keyboard_double_arrow_right)],
                      ),
                    );
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF6F9FC),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: null,
                    child: Row(children: [Text(translate("next"), style: TextStyle(color: lightTextColor)), Icon(Icons.keyboard_double_arrow_right)]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
