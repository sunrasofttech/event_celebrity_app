import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobi_user/Bloc/ReferCubit/ReferCubit.dart';
import 'package:mobi_user/Bloc/ReferCubit/ReferState.dart';
import 'package:mobi_user/Utility/CustomFont.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share_whatsapp/share_whatsapp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utility/const.dart';

class ReferEarnScreen extends StatefulWidget {
  const ReferEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {
  share(String refer, String amount) async {
    await Share.share(
        "Invite your friends to join $appName and get Rs.$amount bonus for each friend that join using your referral code -$refer \n Our website ${Constants.baseUrl}/");
  }

  launchWhatsApp(String referCode, String amount) async {
    // await ShareWhatsapp().share(
    //     text:
    //         "Invite your friends to join $appName and get Rs.$amount bonus for each friend that join using your referral code- $referCode \n Our website- ${baseUrl}/",
    //     type: WhatsApp.business == WhatsApp.business ? WhatsApp.business : WhatsApp.standard);
  }

  /* String refer="";
 fetchData() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String userId=preferences.getString("key").toString();
    print("UserId $userId");
    final resp=await post(Uri.parse(referCodeApi),body: {"userid":userId});
    final result=jsonDecode(resp.body);
    if(resp.statusCode==200){
      preferences.setString("referCode",result["data"]["refferal_code"]);
      refer=preferences.getString("referCode").toString();
      debugPrint("User Info ${resp.body}");
    }
    else{
      debugPrint("Error in Api ${resp.request!.url}");
    }
    setState(() {});
  }*/
  fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    log("User Id ${prefs.getString("key")}");
    context.read<ReferCubit>().referCode(prefs.getString("key").toString());
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Refer & Earn")),
      body: BlocBuilder<ReferCubit, ReferState>(
        builder: (context, state) {
          if (state is LoadedState) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("asset/icons/refer.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Your Friends are our Friends too!", style: blackStyle),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                            child: Text(
                                "Invite your friends to join ${AppConstants.appName} and get Rs.${state.refer.referralAmount} bonus for each friend that join using your referral code.",
                                style: blackStyle)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Your unique referral code is", style: blackStyle),
                      ],
                    ),
                  ),
                  state.refer.referralCode.referral.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                          child: DottedBorder(
                              color: blackColor,
                              radius: const Radius.circular(5.0),
                              dashPattern: [5, 4],
                              borderType: BorderType.RRect,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 30),
                                  Text(state.refer.referralCode.referral, style: blackStyle),
                                  IconButton(
                                      onPressed: () async {
                                        await Clipboard.setData(ClipboardData(text: state.refer.referralCode.referral))
                                            .then((value) {
                                          //Fluttertoast.showToast(msg: "");
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text("Copy Referral Code Successfully!")));
                                        });
                                      },
                                      icon: const Icon(Icons.copy, color: Colors.black))
                                ],
                              )),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(const BorderSide(color: Colors.grey, width: 0.5)),
                                backgroundColor: MaterialStateProperty.all(maroonColor),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10))),
                            onPressed: () {
                              launchWhatsApp(state.refer.referralCode.referral, state.refer.referralAmount);
                            },
                            icon: const Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 30),
                            label: Text("Whatsapp", style: whiteStyle)),
                        ElevatedButton.icon(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(const BorderSide(color: Colors.grey, width: 0.5)),
                                backgroundColor: MaterialStateProperty.all(maroonColor),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10))),
                            onPressed: () {
                              share(state.refer.referralCode.referral, state.refer.referralAmount);
                            },
                            icon: const Icon(Icons.share_outlined, color: Colors.white, size: 30),
                            label: Text("Share", style: whiteStyle)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator(color: blackColor));
          }
          return Container();
        },
      ),
    );
  }
}
