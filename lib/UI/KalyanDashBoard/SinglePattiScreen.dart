/*
import 'package:flutter/material.dart';

import '../../Utility/CustomFont.dart';
import '../../Utility/MainColor.dart';
import '../../Utility/const.dart';
import '../../Widget/ButtonWidget.dart';

class SinglePattiScreen extends StatefulWidget {
  const SinglePattiScreen({Key? key}) : super(key: key);

  @override
  State<SinglePattiScreen> createState() => _SinglePattiScreenState();
}

class _SinglePattiScreenState extends State<SinglePattiScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("$appName Single Patti Dashboard"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: blueColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    leading: CircleAvatar(
                      backgroundColor: blueColor,
                      maxRadius: 20,
                      child: Icon(Icons.calendar_month,color: whiteColor),
                    ),
                    title: Text("14/07/2023",style: blueStyle.copyWith(fontSize: 12,fontWeight: FontWeight.bold)),
                  ),
                )),
                Expanded(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: blueColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    title: Center(child: Text("$appName OPEN",style: blueStyle.copyWith(fontSize: 12,fontWeight: FontWeight.bold))),
                  ),
                ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text("Single Patti"),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: "Enter Patti",
                                contentPadding: const EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: blueColor),
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                            onTap: (){},
                          ),
                        ]),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Text("Points"),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: "Enter Points",
                                contentPadding: const EdgeInsets.all(10),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: blueColor),
                                  borderRadius: BorderRadius.circular(10),
                                )
                            ),
                            onTap: (){},
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ButtonWidget(title: Text("Add",style: whiteStyle), primaryColor: blueColor,callback: (){}),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                  border: TableBorder.all(color: blueColor,
                      width: .2,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)
                      )),
                  decoration: BoxDecoration(

                      border: Border.all(color: blueColor),

                      borderRadius: BorderRadius.circular(10)
                  ),
                  columns: const [
                    DataColumn(label: Text("Digit")),
                    DataColumn(label: Text("Points")),
                    DataColumn(label: Text("Game Type")),
                  ], rows: List.generate(1, (index) =>const DataRow(cells: [
                DataCell(Text("No Betting Added!")),
                DataCell(Text("No Betting Added!")),
                DataCell(Text("No Betting Added!"))
              ]))),
            ),
          ),
          SizedBox(
            height: 80,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  padding: const EdgeInsets.symmetric(horizontal: 150,vertical: 15)
              ),
              child: Text("Submit",style: whiteStyle),
              onPressed: (){})
        ],
      ),
    );
  }
}
*/
