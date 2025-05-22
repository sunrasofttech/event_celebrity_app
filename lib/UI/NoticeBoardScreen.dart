import 'package:flutter/material.dart';
import 'package:mobi_user/Utility/CustomFont.dart';

import '../Utility/MainColor.dart';

class NoticeBoardScreen extends StatefulWidget {
  const NoticeBoardScreen({Key? key}) : super(key: key);

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  List<String> title = [
    "सबसे पहले हमारी वेबसाइट से प्लेइंग ऐप डाउनलोड करें",
    "फिर आपको अपना नाम मोबाइल नंबर और पासवर्ड भरकर खुद को रजिस्टर करना होगा ।",
    "इसके बाद अपने खाते में कुछ पैसे जमा करें उसके लिए आपको ऐड फंड का बटन दबाना होगा।",
    "न्यूनतम जमा राशि रुपए 500 है।",
    "आप जमा करने के लिए किसी भी माध्यम का उपयोग कर सकते हैं गूगल पे, फोन पे, भीम ऐप, पेटीएम",
    "जितनी धनराशि आप जमा करेंगे उतनी पॉइंट्स आपके अकाउंट में जमा होंगे। (1rs = 1 पॉइंट)",
    "खेल खेलने के लिए बाजार, खेल का प्रकार और अपने पसंदीदा नंबर का चयन करें। यदि आप खेल खेलते हैं और जीते हैं, तो आपको पॉइंट्स बढ़ेंगे।",
    "आप हमारी वेबसाइट पर जाकर अपने खाते से पैसे निकाल सकते हैं। और पैसा आपके बैंक खाते में जमा हो जाएगा। विड्रॉल की सुविधा 24 घंटे उपलब्ध हे विड्रॉलका पैसा आपके बैंक खाते या वॉलेट पेटीएम, फोन पे,या गूगल पे में जमा होगा",
  ];
  //    "दिन में दो बार विड्रॉल दिया जाता है दिन में 12:00 बजे एंड नाइट में 10:00 बजे तो घबराएं नहीं हमारी तरफ से खुद आपके पास कॉल आएगा अगर आप विड्रॉल करते हैं तो।"
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notice Board/Rules"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ListTile(
              tileColor: whiteColor,
              title: Center(child: Text("खेलने की विधि", style: blackStyle.copyWith(fontSize: 25))),
            ),
            ListView.builder(
                itemCount: title.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
                    color: maroonColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: index % 2 == 0,
                          child: CircleAvatar(
                            backgroundColor: whiteColor,
                            maxRadius: 40,
                            child: Text("0${index + 1}", style: blueStyle),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(title[index],
                              style: whiteStyle.copyWith(fontSize: 12), textAlign: TextAlign.justify),
                        )),
                        Visibility(
                          visible: index % 2 != 0,
                          child: CircleAvatar(
                            backgroundColor: whiteColor,
                            maxRadius: 40,
                            child: Text("0${index + 1}", style: blueStyle),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
