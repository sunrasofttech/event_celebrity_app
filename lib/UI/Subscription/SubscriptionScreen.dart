import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_user/Bloc/subscription_bloc/subscription_cubit.dart';
import 'package:mobi_user/Bloc/subscription_bloc/subscription_state.dart';
import 'package:mobi_user/Utility/CustomFont.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:mobi_user/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import '../../Utility/const.dart';
import '../AddFundScreen.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int? selectedID = null;
  int? selectedPrice = null;

  @override
  void initState() {
    context.read<GetSubscriptionsCubit>().fetchSubscriptions();
    super.initState();
  }

  Future<bool> subscribeUserToPlan(int subscriptionId) async {
    try {
      log("APi CALLED START");
      var pref = await SharedPreferences.getInstance();
      String uid = await pref.getString("key").toString();
      var authKey = pref.getString(sharedPrefAPITokenKey) ?? "";
      var headers = {'Authorization': authKey};
      final resp = await repository.postRequest("$assignSubscriptionApiUrl/$subscriptionId", {}, header: headers);
      final result = jsonDecode(resp.body);
      log("----------->>> $result");
      if (resp.statusCode == 201 && result['status'] == true) {
        return true;
      } else {
        throw Exception(result['msg'] ?? "Subscription failed");
      }
    } catch (e, s) {
      log("subscribeUserToPlan API response : $e, $s");
      throw Exception("Subscription failed: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
        builder: (context, userState) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "Subscribe",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryColor),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: primaryColor),
                      ),
                      child: Builder(
                        builder: (context) {
                          log("------------- user state :- $userState");
                          if (userState is UserProfileFetchedState) {
                            return Text(
                              "Wallet Balance: ${userState.user.data?.balance ?? "0"}",
                              style: blackStyle.copyWith(fontSize: 14, color: primaryColor),
                            );
                          }
                          return Text("Wallet Balance: 0", style: blackStyle.copyWith(fontSize: 14));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: BlocBuilder<GetSubscriptionsCubit, GetSubscriptionsState>(
                    builder: (context, state) {
                      if (state is GetSubscriptionsLoading)
                        return Center(child: CircularProgressIndicator(color: blackColor));

                      if (state is GetSubscriptionsError) return Center(child: Text(state.error, style: blackStyle));

                      if (state is GetSubscriptionsLoaded) {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.subscriptions.data?.length ?? 0,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var model = state.subscriptions.data?[index];
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedID = model?.id;
                                        selectedPrice = model?.amount;
                                      });
                                    },
                                    child: _buildSubscriptionCard(
                                      id: model?.id,
                                      title: model?.name ?? "",
                                      price: model?.amount?.toString() ?? "0",
                                      bonus: model?.bonus?.toString() ?? "0",
                                      validity: model?.validity?.toString() ?? "",
                                      isPopular: index == 0,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                log("userSTATE =======>>> $userState");
                                if (userState is UserProfileFetchedState && selectedPrice != null) {
                                  double balance = double.parse(userState.user.data?.balance.toString() ?? "0");
                                  if (balance > double.parse(selectedPrice.toString())) {
                                    //TODO: Call API WITH USER ID

                                    ///API LOGIC
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder:
                                          (context) =>
                                              const Center(child: CircularProgressIndicator(color: primaryColor)),
                                    );

                                    try {
                                      final result = await subscribeUserToPlan(selectedID!);

                                      Navigator.pop(context); // Close loading dialog

                                      if (result) {
                                        BlocProvider.of<UserProfileBlocBloc>(context).add(GetUserProfileEvent());
                                        Fluttertoast.showToast(
                                          msg: "✅ Subscribed successfully!",
                                          toastLength: Toast.LENGTH_LONG,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                        );
                                        Navigator.pop(context);
                                      }
                                    } catch (e) {
                                      Navigator.pop(context); // Close loading dialog

                                      Fluttertoast.showToast(
                                        msg: "❌ ${e.toString()}",
                                        toastLength: Toast.LENGTH_LONG,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                      );
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          contentPadding: EdgeInsets.only(bottom: 5, top: 20, left: 20, right: 20),
                                          content: Text(
                                            "You don't have enough balance in your wallet",
                                            style: blackStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: maroonColor,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const AddFundScreen()),
                                                );
                                              },
                                              child: Text("Add Funds", style: whiteStyle),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                              ),
                              child: const Text(
                                "Continue with Subscription",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubscriptionCard({
    required int? id,
    required String title,
    required String price,
    required String bonus,
    required String validity,
    required bool isPopular,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border:
                selectedID == id
                    ? Border.all(color: primaryColor, width: 3)
                    : Border.all(color: primaryColor, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text("Rs. ", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text(price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text(validity + " days", style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      bonus + "%",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                    const Text("Extra Bonus", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isPopular)
          Positioned(
            top: -10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(20)),
              child: const Text(
                "Popular",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
