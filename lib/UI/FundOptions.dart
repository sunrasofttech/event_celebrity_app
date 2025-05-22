import 'package:flutter/material.dart';
import 'package:mobi_user/UI/AddManualFundScreen.dart';
import 'package:mobi_user/UI/FundHistory.dart';

import '../Utility/MainColor.dart';
import 'AddFundScreen.dart';
import 'WithDrawScreen.dart';

class FundOptionScreen extends StatefulWidget {
  const FundOptionScreen({super.key});
  @override
  State<FundOptionScreen> createState() => _FundOptionScreenState();
}

class _FundOptionScreenState extends State<FundOptionScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridItems = [
      {
        'icon': "asset/icons/add_funds_options/add_fund_pic.png",
        'label': 'Add Funds',
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddFundScreen()));
        },
      },
      {
        'icon': "asset/icons/add_funds_options/withdraw_funds.png",
        'label': 'Manual Deposit',
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawalScreen()));
        },
      },
      {
        'icon': "asset/icons/add_funds_options/manual_dep_pic.png",
        'label': 'Manual Deposit',
        "onTap": () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddManualFundScreen()));
        },
      },
      {
        'icon': "asset/icons/add_funds_options/account_statement_pic.png",
        'label': 'Account Statements',
        "onTap": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FundHistory()));
        },
      },
    ];
    return Scaffold(
      backgroundColor: Color(0xfff0f5fc),
      appBar: AppBar(
        flexibleSpace: Container(decoration: blueBoxDecoration()),
        backgroundColor: Colors.transparent,
        title: Text('Funds', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: Column(
        children: [
          // Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                childAspectRatio: 1,
                children:
                    gridItems.map((item) {
                      return InkWell(onTap: item["onTap"], child: Image.asset(item['icon']));
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
