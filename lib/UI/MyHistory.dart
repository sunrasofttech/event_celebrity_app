import 'package:flutter/material.dart';
import 'package:mobi_user/UI/FundHistory.dart';
import 'package:mobi_user/Utility/CustomFont.dart';
import 'package:mobi_user/Utility/MainColor.dart';

import 'BiddingHistory.dart';

class MyHistoryScreen extends StatefulWidget {
  const MyHistoryScreen({Key? key}) : super(key: key);

  @override
  State<MyHistoryScreen> createState() => _MyHistoryScreenState();
}

class _MyHistoryScreenState extends State<MyHistoryScreen> {
  List<String> history = ["Bid History", /*"Starline Bid History","StarLine Result History",*/ "Fund History"];
  List<String> images = [historyIcon, starLineIcon, starResultIcon, saveMoneyIcon];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My History"),
      ),
      body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: history.length,
          itemBuilder: (context, index) {
            return Card(
              color: maroonColor,
              /* shape: RoundedRectangleBorder(
                side: const BorderSide(color: blueColor),
                borderRadius: BorderRadius.circular(10)
              ),*/
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: maroonColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(images[index], width: 20, height: 20),
                  ),
                ),
                trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.white),
                onTap: () {
                  switch (index) {
                    case 0:
                      Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 1.0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(parent: animation, curve: Curves.bounceIn)),
                          child: const BiddingHistory(),
                        );
                      }));
                      break;
                    default:
                      Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 1.0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(parent: animation, curve: Curves.bounceIn)),
                          child: const FundHistory(),
                        );
                      }));
                      break;
                  }
                },
                title: Text(history[index], style: whiteStyle.copyWith(fontSize: 16)),
              ),
            );
          }),
    );
  }
}
