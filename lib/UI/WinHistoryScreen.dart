import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobi_user/Bloc/winHistory/win_history_event.dart';

import '../Bloc/winHistory/win_history_bloc.dart';
import '../Bloc/winHistory/win_history_state.dart';
import '../Utility/CustomFont.dart';
import '../Utility/MainColor.dart';
import '../Widget/ButtonWidget.dart';

class WinHistoryScreen extends StatefulWidget {
  const WinHistoryScreen({Key? key}) : super(key: key);

  @override
  State<WinHistoryScreen> createState() => _WinHistoryScreenState();
}

class _WinHistoryScreenState extends State<WinHistoryScreen> {
  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();

  String startDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  String endDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  int pageSize = 40;
  int _pageKey = 1;

  @override
  void initState() {
    context.read<WinHistoryBloc>().add(FetchWinHistoryDataEvent(page: _pageKey.toString(), sDate: startDate, eDate: endDate));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Win History")),
      body: Column(
        children: [
          Container(decoration: blueBoxDecoration(), child: Column(children: [const SizedBox(height: 25, width: double.infinity)])),
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
                        child: Text("Start Date", style: blackStyle.copyWith(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 14)),
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
                        child: Text("End Date", style: blackStyle.copyWith(fontWeight: FontWeight.bold, color: primaryColor, fontSize: 14)),
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
            title: Text("Submit", style: whiteStyle),
            primaryColor: playColor,
            callback: () async {
              setState(() {
                _pageKey = 1;
              });
              context.read<WinHistoryBloc>().add(FetchWinHistoryDataEvent(page: _pageKey.toString(), sDate: startDate, eDate: endDate));
            },
          ),
          Expanded(
            child: BlocBuilder<WinHistoryBloc, WinHistoryState>(
              builder: (context, state) {
                if (state is WinHistoryLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is WinHistoryFetchedState) {
                  return state.model.data?.isEmpty ?? true
                      ? Center(child: Text("No Data Found"))
                      : RefreshIndicator(
                        onRefresh: () async {
                          context.read<WinHistoryBloc>().add(FetchWinHistoryDataEvent(page: _pageKey.toString(), sDate: startDate, eDate: endDate));
                        },
                        child: ListView.builder(
                          itemCount: state.model.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final item = state.model.data?[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 4))],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${item?.marketName ?? ""}", style: blackStyle.copyWith(fontWeight: FontWeight.bold)),
                                        Text("${item?.session ?? ""}", style: blackStyle),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${item?.gameDetails ?? ""}", style: blackStyle),
                                        Text("\u{20B9}${item?.points}", style: blackStyle),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [Text("Win Amount", style: blackStyle), Text("\u{20B9} ${item?.winAmount ?? ""}", style: blackStyle)],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Status: Success", style: blackStyle.copyWith(fontWeight: FontWeight.bold)),
                                        Text("${item?.winTime.toString() ?? ""}", style: blackStyle.copyWith(fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ],
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
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BlocBuilder<WinHistoryBloc, WinHistoryState>(
            builder: (context, state) {
              if (state is WinHistoryFetchedState) {
                return ElevatedButton.icon(
                  icon: Icon(Icons.keyboard_double_arrow_left),
                  onPressed:
                      state.model.totalPages == 0
                          ? null
                          : () {
                            if (_pageKey > 1) {
                              setState(() {
                                _pageKey--;
                              });
                              context.read<WinHistoryBloc>().add(
                                FetchWinHistoryDataEvent(page: _pageKey.toString(), eDate: endDate, sDate: startDate),
                              );
                            }
                          },
                  label: Text("Previous"),
                );
              }
              return ElevatedButton.icon(icon: Icon(Icons.keyboard_double_arrow_left), onPressed: null, label: Text("Previous"));
            },
          ),
          BlocBuilder<WinHistoryBloc, WinHistoryState>(
            builder: (context, state) {
              if (state is WinHistoryFetchedState) {
                return Text("${_pageKey}/${state.model.totalPages}");
              }
              return Text("");
            },
          ),
          BlocBuilder<WinHistoryBloc, WinHistoryState>(
            builder: (context, state) {
              if (state is WinHistoryFetchedState) {
                return ElevatedButton(
                  onPressed:
                      pageSize == state.model.totalPages || state.model.totalPages == 0
                          ? null
                          : () {
                            if (_pageKey >= 1) {
                              setState(() {
                                _pageKey++;
                              });
                              context.read<WinHistoryBloc>().add(
                                FetchWinHistoryDataEvent(page: _pageKey.toString(), eDate: endDate, sDate: startDate),
                              );
                            }
                          },
                  child: Row(children: [Text("Next"), Icon(Icons.keyboard_double_arrow_right)]),
                );
              }
              return ElevatedButton(onPressed: null, child: Row(children: [Text("Next"), Icon(Icons.keyboard_double_arrow_right)]));
            },
          ),
        ],
      ),
    );
  }
}
