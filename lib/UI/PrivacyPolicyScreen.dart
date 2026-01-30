import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  final String policy;
  const PrivacyPolicyScreen({Key? key, required this.policy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: titleTextColor),
          title: Text(
            "Privacy Policy",
            style: TextStyle(
              color: titleTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Html(
              data: policy,
              style: {
                "body": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(14),
                  color: Colors.grey.shade800,
                  lineHeight: const LineHeight(1.5),
                ),
                "h1": Style(
                  fontSize: FontSize(20),
                  fontWeight: FontWeight.w700,
                  color: titleTextColor,
                ),
                "h2": Style(
                  fontSize: FontSize(18),
                  fontWeight: FontWeight.w600,
                  color: titleTextColor,
                ),
                "p": Style(margin: Margins.only(bottom: 12)),
                "li": Style(margin: Margins.only(bottom: 6)),
              },
            ),
          ),
        ),
      ),
    );
  }
}
