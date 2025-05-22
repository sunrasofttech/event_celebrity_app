import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AppTheme.dart';

/*-------------------Color Theme-------------------*/

const Color primaryColor = Color(0xFF005589);
const Color maroonColor = Color(0xFF005589);
const Color lightBlueColor = Color(0xFF121313);
const Color lightTextColor = Color(0xFF9DABC3);
const Color playColor = Color(0xFFFF9000);
const Color whiteColor = Color(0xFFFFFFFF);
const Color blackColor = Colors.black;
const Color greenColor = Colors.green;
const Color redColor = Colors.red;
const Color greyColor = Color(0xff99AABC);
const Color cardColor = Color(0xFFF3F6FA);
const Color darkBlueColor = Color(0xff141315);

Widget disabledCircleIcon(IconData icon) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
    child: Icon(icon, color: Colors.white, size: 24),
  );
}

Widget circleIcon(IconData icon) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFF4500)], begin: Alignment.bottomLeft, end: Alignment.topRight),
    ),
    child: Icon(icon, color: Colors.white, size: 24),
  );
}

BoxDecoration blueBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
    gradient: LinearGradient(colors: gradientColor, begin: Alignment.topCenter, end: Alignment.bottomCenter),
  );
}

List<BoxShadow> onlyShadow() {
  return [
    BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(4, 4)),
    BoxShadow(color: Colors.white, blurRadius: 10, offset: const Offset(-4, -4)),
  ];
  return [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(6, 2))];
}

Widget shadowWidget({required Widget child}) {
  return Container(decoration: BoxDecoration(boxShadow: onlyShadow()), child: child);
}

BoxDecoration splashGradientDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        // Color(0xFF285196),
        lightBlueColor,
        maroonColor,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

List<Color> gradientColor = [Color(0xFF121416), Color(0xFF021E3B)];

Widget bidTextField({
  required String prefixText,
  required TextEditingController controller,
  required Function(String)? onChanged,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(prefixText, style: AppTheme().primaryStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
      ),
      const SizedBox(width: 10),
      SizedBox(
        width: 250,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            inputFormatters: inputFormatters ?? [FilteringTextInputFormatter.digitsOnly],
            onChanged:
                onChanged ??
                (val) {
                  print("Val ${val}");
                  if (val == "0") {
                    val = "";
                  }
                },
            cursorColor: AppTheme().appColor,
            style: AppTheme().blackStyle.copyWith(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 40),
              border: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppTheme().greyColor), borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ),
    ],
  );
}

/*---Set Image Path---*/
const String whatsAppIcon = "asset/icon/whatsapp.png";
const String cardIcon = "asset/icon/Card.png";
const String saveMoneyIcon = "asset/icon/saveMoney.png";
const String historyIcon = "asset/icon/history.png";
const String starLineIcon = "asset/icon/bidHistory.png";
const String singleDigitIcon = "asset/icon/SingleDigit.png";
const String singlePattiIcon = "asset/icon/SinglePatti.png";
const String doublePattiIcon = "asset/icon/doublePatti.png";
const String triplePattiIcon = "asset/icon/TripplePatti.png";
const String halfSangamIcon = "asset/icon/HalfSangam.png";
const String fullSangamIcon = "asset/icon/FullSangam.png";
const String JodiIcon = "asset/icon/jodi.png";
const String starResultIcon = "asset/icon/starline.png";
