import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AppTheme.dart';

/*-------------------Color Theme-------------------*/

const Color primaryColor = Color(0xFFEF2F4B);
const Color scaffoldBgColor = Color(0xFFF4F4F4);
const Color greyColor = Color(0xFF838383);
const Color titleTextColor = Color(0xFF252525);
const Color pinkTintColor = Color(0xFFFD87A6);
const Color lightBlackColor = Color(0xFF252525);
const Color bgLightGreyColor = Color(0xFFF4F4F4);

const Color lightGreenColor = Color(0xFF0BA360);

const Color lightBlueColor = Color(0xFF434142);
const Color lightTextColor = Color(0xFF9DABC3);
const Color textFieldFillColor = Color(0xFF424242);
// const Color playColor = Color(0xFFFF9000);
const Color playColor = Color(0xFFF70400);
const Color orangeColor = Color(0xFFFF9500);
const Color purpleColor = Color(0xFFC300FF);
const Color whiteColor = Color(0xFFFFFFFF);
const Color textFillColor = Color(0xFF99AABC);
const Color blackColor = Colors.black87;
const Color greenColor = Color(0xFF00FF00);
const Color redColor = Colors.red;
const Color cardColor = Color(0xFFF3F6FA);
const Color darkBlueColor = Color(0xff141315);

Widget disabledCircleIcon(IconData icon) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
    child: Icon(icon, color: Colors.white, size: 30),
  );
}

LinearGradient linearGradient() {
  return LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF373737)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

BoxDecoration bidDecoration() {
  return BoxDecoration(
    border: Border.all(color: Color(0xFF2D2D2D), width: 1),
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(color: Color(0xFFE0E0E040).withOpacity(0.1), blurRadius: 3, spreadRadius: 2, offset: Offset(0, 0)),
      BoxShadow(color: Color(0xFFFFFFFF).withOpacity(0.2), blurRadius: 4, spreadRadius: 3, offset: Offset(0, 0)),
    ],
    gradient: LinearGradient(
      colors: [Color(0xFF0D0D0D), Color(0xFF2D2D2D)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
}

List<BoxShadow> bidShadow() {
  return [BoxShadow(color: Color(0xFFE0E0E040).withOpacity(0.3), blurRadius: 3, spreadRadius: 2, offset: Offset(0, 0))];
}

TextStyle bidTextFieldHintStyle() {
  return TextStyle(fontSize: 12, color: Color(0xFFABABAB));
}

Widget circleIcon(IconData icon) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF03C420)),
    child: Icon(icon, color: Colors.white, size: 30),
  );
}

Widget gradientTextWidget({required Widget child}) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return linearGradient().createShader(bounds);
    },
    blendMode: BlendMode.srcIn,
    child: child,
  );
}

Widget gradientBox({required Widget child}) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: linearGradient()),
    child: child,
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
    BoxShadow(color: Color(0xFF151515), blurRadius: 4, spreadRadius: 1, offset: const Offset(0, 4)),
    BoxShadow(color: Color(0xFF151515), blurRadius: 4, spreadRadius: 1, offset: const Offset(4, 4)),
  ];
  return [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(6, 2))];
}

Widget shadowWidget({required Widget child}) {
  return Container(decoration: BoxDecoration(/*boxShadow: onlyShadow()*/), child: child);
}

BoxDecoration splashGradientDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        // Color(0xFF285196),
        lightBlueColor,
        lightBlueColor,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

List<Color> gradientColor = [Color(0xFF000000), Color(0xFF373737)];

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
        child: Text(prefixText, style: AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 12)),
      ),
      const SizedBox(width: 10),
      Icon(Icons.arrow_right_alt, color: greenColor),
      const SizedBox(width: 10),
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
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
              textAlign: TextAlign.center,
              style: AppTheme().whiteStyle.copyWith(fontWeight: FontWeight.bold, height: 0),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4),
                fillColor: Color(0xFF424242),
                filled: true,
                hintText: "Enter",
                hintStyle: bidTextFieldHintStyle(),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
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
