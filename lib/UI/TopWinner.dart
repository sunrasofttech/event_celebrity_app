/*
import 'package:flutter/material.dart';
import 'package:tatamatka/Utility/CustomFont.dart';
import 'package:tatamatka/Utility/MainColor.dart';

class TopWinnerScreen extends StatefulWidget {
  const TopWinnerScreen({Key? key}) : super(key: key);

  @override
  State<TopWinnerScreen> createState() => _TopWinnerScreenState();
}

class _TopWinnerScreenState extends State<TopWinnerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Winners"),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context,index){
          return Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: blueColor),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      maxRadius: 60,
                     backgroundColor: blueColor,
                     child: Icon(Icons.person),
                    ),
                  ),

                ListTile(
                  title: Center(child: Text("Winner : Prakash Patil",style: blueStyle.copyWith(fontSize: 16,fontWeight: FontWeight.bold))),

                ),
                ListTile(
                  title: Center(child: Text("Game  : Kalyan open",style: blueStyle.copyWith(fontSize: 16,fontWeight: FontWeight.bold))),
                ),
                ListTile(
                  title: Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Digit :",style: blueStyle.copyWith(fontSize: 16,fontWeight: FontWeight.bold)),
                      Text("4"),
                    ],
                  )),
                ),
                ListTile(
                  title: Center(child: Text("Amount:  5000 ",style: blueStyle.copyWith(fontSize: 16,fontWeight: FontWeight.bold))),
                ),
                ListTile(
                  title: Center(child: Text("Time: 2023-07-14 11:10:54AM",style: blueStyle.copyWith(fontSize: 16,fontWeight: FontWeight.bold))),
                ),
              ],
            ),
          );
        }, itemCount: 5,
      ),
    );
  }
}
*/
