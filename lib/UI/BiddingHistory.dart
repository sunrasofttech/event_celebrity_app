import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:mobi_user/Bloc/BidHistoryBloc/BidHistoryCubit.dart';
import 'package:mobi_user/Widget/ButtonWidget.dart';

import '../Bloc/BidHistoryBloc/BidHistoryState.dart';
import '../Utility/CustomFont.dart';
import '../Utility/MainColor.dart';

class BiddingHistory extends StatefulWidget {
  const BiddingHistory({super.key});
  @override
  State<BiddingHistory> createState() => _BiddingHistoryState();
}

class _BiddingHistoryState extends State<BiddingHistory> {
  TextEditingController marketName = TextEditingController();

  String startDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String endDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  int pageSize = 20;
  int _pageKey = 1;

  @override
  void initState() {
    context.read<BidHistoryCubit>().getBidHistory(startDate, endDate, _pageKey);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: blueBoxDecoration()),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(translate("bid_history")),
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
              context.read<BidHistoryCubit>().getBidHistory(startDate, endDate, _pageKey);
            },
          ),
          Expanded(
            child: BlocBuilder<BidHistoryCubit, BidHistoryState>(
              builder: (context, state) {
                if (state is BidHistoryErrorState) {
                  return Center(child: Text(state.error));
                }

                if (state is BidHistoryLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is BidHistoryLoadedState) {
                  return state.model.data?.isEmpty ?? false
                      ? Center(child: Text("No Data Found"))
                      : RefreshIndicator(
                        onRefresh: () async {
                          context.read<BidHistoryCubit>().getBidHistory(startDate, endDate, _pageKey);
                        },
                        child: ListView.builder(
                          itemCount: state.model.data?.length ?? 0,
                          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          itemBuilder: (context, index) {
                            final item = state.model.data?[index];
                            return Container(
                              margin: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
                              decoration: BoxDecoration(
                                color: item?.win == "1" ? Colors.green : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 4))],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Top row: Market name and status
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${item?.market?.toUpperCase() ?? ''}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        Text(
                                          item?.session?.toUpperCase() ?? '',
                                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // Middle row: Game type and points
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${item?.game.toString().toUpperCase() != "HALF SANGAM" && item?.game.toString().toUpperCase() != "FULL SANGAM" && item?.game != "SINGLE PANNA".toLowerCase() && item?.game != "DOUBLE PANNA".toLowerCase() && item?.game != "TRIPPLE PANNA".toLowerCase() ? "${item?.game?.toUpperCase()}:- ${item?.digit}" : ""}",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            Visibility(
                                              visible: item?.game.toString().toUpperCase() == "FULL SANGAM",
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [Text("${item?.digit ?? "0"} X ${item?.pana ?? "0"}", style: blackStyle)],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: item?.game == "HALF SANGAM".toLowerCase(),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item?.session == "open" ? "${item?.pana}X${item?.digit}" : "${item?.digit}X${item?.pana}",
                                                      style: blackStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible:
                                                  item?.game == "SINGLE PANNA".toLowerCase() ||
                                                  item?.game == "DOUBLE PANNA".toLowerCase() ||
                                                  item?.game == "TRIPPLE PANNA".toLowerCase(),
                                              child: Text(item?.digit?.toString() ?? "0", style: blackStyle),
                                            ),
                                          ],
                                        ),
                                        Text("₹${item?.points ?? '0.00'}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // Bottom row: Date and Time
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Visibility(
                                              visible: item?.win == "1",
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Win Amount", style: blackStyle),
                                                    Text("\u{20B9} ${item?.winAmount}", style: blackStyle),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "Status: ${item?.win == "0"
                                                  ? "Pending"
                                                  : item?.win == "-1"
                                                  ? "Lose"
                                                  : "Win"}",
                                              style: blackStyle.copyWith(fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              DateFormat("dd/MM/yyyy").format(DateTime.parse(item?.date ?? "")),
                                              style: TextStyle(fontSize: 14, color: Colors.black87),
                                            ),
                                            Text(
                                              DateFormat("hh:mm a").format(DateTime.parse(item?.date ?? "")),
                                              style: TextStyle(fontSize: 14, color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              /*Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${item?.market}", style: blackStyle.copyWith(fontWeight: FontWeight.bold)),
                                        Text("${item?.session}", style: blackStyle),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              Text(
                                                "${ */
                              /*item?.game?.toUpperCase()}: ${item?.game == "SINGLE DIGIT".toLowerCase()
                                                        || item?.game == "red_jodi".toLowerCase() || item?.game == "JODI DIGIT".toLowerCase()
                                                        || item?.game == "Family Pana".toLowerCase() || item?.game == "DP Motor".toLowerCase()
                                                        || item?.game == "SP Motor".toLowerCase()
                                                        ||*/
                              /* item?.game.toString().toUpperCase() != "HALF SANGAM" && item?.game.toString().toUpperCase() != "FULL SANGAM" && item?.game != "SINGLE PANNA".toLowerCase() && item?.game != "DOUBLE PANNA".toLowerCase() && item?.game != "TRIPPLE PANNA".toLowerCase() ? "${item?.game?.toUpperCase()}:- ${item?.digit}" : ""}",
                                                style: blackStyle,
                                              ),
                                              Visibility(
                                                visible: item?.game.toString().toUpperCase() == "FULL SANGAM",
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [Text("${item?.digit ?? "0"} X ${item?.pana ?? "0"}", style: blackStyle)],
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: item?.game == "HALF SANGAM".toLowerCase(),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        item?.session == "open" ? "${item?.pana}X${item?.digit}" : "${item?.digit}X${item?.pana}",
                                                        style: blackStyle,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible:
                                                    item?.game == "SINGLE PANNA".toLowerCase() ||
                                                    item?.game == "DOUBLE PANNA".toLowerCase() ||
                                                    item?.game == "TRIPPLE PANNA".toLowerCase(),
                                                child: Text(item?.digit?.toString() ?? "0", style: blackStyle),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text("\u{20B9} ${item?.points}", style: blackStyle),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: item?.win == "1",
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [Text("Win Amount", style: blackStyle), Text("\u{20B9} ${item?.winAmount}", style: blackStyle)],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Status: ${item?.win == "0"
                                              ? "Pending"
                                              : item?.win == "-1"
                                              ? "Lose"
                                              : "Win"}",
                                          style: blackStyle.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.parse(item?.date!.toString() ?? ""))}",
                                          style: blackStyle.copyWith(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),*/
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
              child: BlocBuilder<BidHistoryCubit, BidHistoryState>(
                builder: (context, state) {
                  if (state is BidHistoryLoadedState) {
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
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
                                if (_pageKey > 1) {
                                  setState(() {
                                    _pageKey--;
                                  });
                                  context.read<BidHistoryCubit>().getBidHistory(startDate, endDate, _pageKey);
                                }
                              },
                      label: Text(translate("previous"), style: TextStyle(color: lightTextColor)),
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
                    label: Text(translate("previous"), style: TextStyle(color: lightTextColor)),
                  );
                },
              ),
            ),
            BlocBuilder<BidHistoryCubit, BidHistoryState>(
              builder: (context, state) {
                if (state is BidHistoryLoadedState) {
                  return Text("${_pageKey}/${state.model.totalPages}", style: TextStyle(color: lightTextColor));
                }
                return Text("");
              },
            ),
            shadowWidget(
              child: BlocBuilder<BidHistoryCubit, BidHistoryState>(
                builder: (context, state) {
                  if (state is BidHistoryLoadedState) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF6F9FC),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed:
                          _pageKey == state.model.totalPages || state.model.totalPages == 0
                              ? null
                              : () {
                                if (_pageKey >= 1) {
                                  setState(() {
                                    _pageKey++;
                                  });
                                  context.read<BidHistoryCubit>().getBidHistory(startDate, endDate, _pageKey);
                                }
                              },
                      child: Row(
                        children: [Text(translate("next"), style: TextStyle(color: lightTextColor)), Icon(Icons.keyboard_double_arrow_right)],
                      ),
                    );
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.grey,
                      backgroundColor: const Color(0xFFF6F9FC),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: null,
                    child: Row(children: [Text(translate("next")), Icon(Icons.keyboard_double_arrow_right)]),
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
