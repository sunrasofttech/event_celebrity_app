import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Utility/MainColor.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({Key? key}) : super(key: key);

  @override
  State<ViewHistory> createState() => _StarLineHistoryState();
}

class _StarLineHistoryState extends State<ViewHistory> {
  DateTime currentDate = DateTime.now();
  @override
  void initState() {
    log("View History");
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("StarLine Result History"),
      ),
      body: Column(
        children: [
          Card(
            color: whiteColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: maroonColor,
                )),
            child: const ListTile(
              title: Text("Starline Result By Date"),
            ),
          ),
          Card(
            color: whiteColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: maroonColor,
                )),
            child: ListTile(
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2080))
                    .then((pickedDate) {
                  // Check if no date is selected
                  if (pickedDate == null) {
                    return;
                  }
                  setState(() {
                    // using state so that the UI will be rerendered when date is picked
                    currentDate = pickedDate;
                  });
                });
              },
              title: Text("Select Date : ${DateFormat("dd/MM/yyyy").format(currentDate)} "),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ),
          Expanded(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: maroonColor), borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: maroonColor,
                        child: Icon(Icons.access_time_filled_outlined, color: whiteColor),
                      ),
                      title: Text("09:15 AM"),
                      trailing: Text("890-7"),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
