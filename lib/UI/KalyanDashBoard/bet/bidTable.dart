import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/bidBloc/bidBloc.dart';
import 'package:mobi_user/Bloc/bidBloc/bidEvent.dart';
import 'package:mobi_user/Bloc/bidBloc/bidState.dart';
import 'package:mobi_user/Utility/CustomFont.dart';

class BidTable extends StatelessWidget {
  String code;
  BidNowState state;
  BidTable({super.key, required this.code, required this.state});

  @override
  Widget build(BuildContext context) {
    /* jsonDecode(state.bidList.toString());*/
    return Column(
      children: [
        /*Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(code ?? "")),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Text("Points")),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Text("Game")),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Text("Action")),
              ]),
        ),*/
        SizedBox(
          height: 2,
        ),
        /* ListView.builder(
          itemCount: state.bidList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 2),
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("${index + 1}")),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Text(state.bidList[index]["points"] ?? "")),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(child: Text(state.bidList[index]["digit"] ?? "")),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          BlocProvider.of<BidBloc>(context).add(
                            DeleteBid(index: index),
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ]),
            );
          },
        ),*/
        code == "hsd" || code == "fsd"
            ? DataTable(
                columnSpacing: 20,
                border: TableBorder.all(
                    color: Colors.blue,
                    width: .2,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                columns: [
                  DataColumn(label: Text("Digit")),
                  DataColumn(label: Text("Pana")),
                  DataColumn(label: Text("Points")),
                  DataColumn(label: Text("Type")),
                  DataColumn(label: Text("Action")),
                ],
                rows: List.generate(
                    state.bidList.length,
                    (index) => DataRow(cells: [
                          DataCell(Text(state.bidList[index].digit.toString())),
                          DataCell(Text(state.bidList[index].pana.toString())),
                          DataCell(Text(state.bidList[index].points.toString())),
                          DataCell(Text(state.bidList[index].session.toString())),
                          DataCell(IconButton(
                            onPressed: () {
                              BlocProvider.of<BidBloc>(context).add(
                                DeleteBid(index: index),
                              );
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ))
                        ])).toList())
            : DataTable(
                columnSpacing: 20,
                border: TableBorder.all(
                    color: Colors.blue,
                    width: .2,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                columns: [
                  DataColumn(label: Text("Digit")),
                  DataColumn(label: Text("Points")),
                  DataColumn(label: Text("Type")),
                  DataColumn(label: Text("Action")),
                ],
                rows: List.generate(
                    state.bidList.length,
                    (index) => DataRow(cells: [
                          DataCell(Text(state.bidList[index].digit.toString())),
                          DataCell(Text(state.bidList[index].points.toString())),
                          DataCell(Text(state.bidList[index].session.toString())),
                          DataCell(IconButton(
                            onPressed: () {
                              BlocProvider.of<BidBloc>(context).add(
                                DeleteBid(index: index),
                              );
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ))
                        ])).toList()),
        Card(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Total", style: blackStyle),
                  Text(state.total.toString()),
                ],
              ),
            ))
        /*Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.white,
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text("Total")),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Text(state.total)),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Text("")),
                const SizedBox(
                  width: 10,
                ),
                Expanded(child: Text("")),
              ]),
        ),*/
      ],
    );
  }
}
