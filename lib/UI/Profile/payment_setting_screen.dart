import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Utility/CustomTextField.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:planner_celebrity/Utility/SimpleButton.dart';

class PaymentSettingScreen extends StatefulWidget {
  const PaymentSettingScreen({super.key});

  @override
  State<PaymentSettingScreen> createState() => _PaymentSettingScreenState();
}

class _PaymentSettingScreenState extends State<PaymentSettingScreen> {
  TextEditingController upiCtr = TextEditingController();
  TextEditingController accountHolderNameCtr = TextEditingController();
  TextEditingController accountNumCtr = TextEditingController();
  TextEditingController confirmaccountNumCtr = TextEditingController();
  TextEditingController ifscCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: const Icon(IconsaxPlusBold.arrow_left_3, color: greyColor),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Payment Settings",
          style: TextStyle(
            color: titleTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "UPI ID",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.0,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 4),
            CustomTextField(
              controller: accountHolderNameCtr,
              hintText: "84268743@ybl",
            ),
            SizedBox(height: 10),
            Center(child: Text("OR")),

            SizedBox(height: 50),
            Text(
              "Account Holder Name",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.0,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 4),
            CustomTextField(controller: upiCtr, hintText: "Naidek Kumar"),

            SizedBox(height: 10),
            Text(
              "Account Number",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.0,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 4),
            CustomTextField(
              controller: accountNumCtr,
              hintText: "Enter Account Number",
            ),

            SizedBox(height: 10),
            Text(
              "Confirm Account Number",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.0,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 4),
            CustomTextField(
              controller: confirmaccountNumCtr,
              hintText: "Enter Account Number",
            ),

            SizedBox(height: 10),
            Text(
              "IFSC Code",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.0,
                letterSpacing: 0,
              ),
            ),
            SizedBox(height: 4),
            CustomTextField(
              controller: ifscCtr,
              hintText: "Enter Account Number",
            ),

            SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              child: SimpleButton(onPressed: () {}, title: "Save"),
            ),
          ],
        ),
      ),
    );
  }
}
