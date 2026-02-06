import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Bloc/get_profile/get_profile_cubit.dart';
import 'package:planner_celebrity/Bloc/update_notification/update_notification_cubit.dart';
import 'package:planner_celebrity/Utility/SimpleButton.dart';

import '../../Utility/MainColor.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../Utility/MainColor.dart';

class Tile extends StatefulWidget {
  final IconData? icon;
  final String title;
  final void Function()? onTap;
  final bool value;
  final ValueChanged<bool> onChanged;

  const Tile({
    this.icon,
    required this.title,
    this.onTap,
    required this.value,
    required this.onChanged,
  });

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: widget.onTap,
        leading:
            widget.icon == null ? null : Icon(widget.icon, color: greyColor),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: titleTextColor,
          ),
        ),
        trailing: Switch(value: widget.value, onChanged: widget.onChanged),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    context.read<GetProfileCubit>().getProfile();
    super.initState();
  }

  bool get _areAllEnabled =>
      orderEmail &&
      orderPush &&
      orderSMS &&
      orderWhatsapp &&
      promoEmail &&
      promoPush &&
      promoSMS &&
      promoWhatsapp;

  bool get _areAllDisabled =>
      !orderEmail &&
      !orderPush &&
      !orderSMS &&
      !orderWhatsapp &&
      !promoEmail &&
      !promoPush &&
      !promoSMS &&
      !promoWhatsapp;

  bool enableAll = false;
  bool orderEmail = false;
  bool orderPush = false;
  bool orderSMS = false;
  bool orderWhatsapp = false;
  bool promoEmail = false;
  bool promoPush = false;
  bool promoSMS = false;
  bool promoWhatsapp = false;

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
          "Notifications",
          style: TextStyle(
            color: titleTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: BlocListener<GetProfileCubit, GetProfileState>(
          listener: (context, state) {
            if (state is GetProfileLoadedState) {
              final data = state.model.data;
              enableAll = state.model.data?.enableAll ?? false;
              orderEmail = state.model.data?.orderEmail ?? false;
              orderPush = state.model.data?.orderPush ?? false;
              orderSMS = state.model.data?.orderSms ?? false;
              orderWhatsapp = state.model.data?.orderWhatsapp ?? false;
              promoEmail = state.model.data?.prmotionEmail ?? false;
              promoPush = state.model.data?.prmotionPush ?? false;
              promoSMS = state.model.data?.prmotionSms ?? false;
              promoWhatsapp = state.model.data?.prmotionWhatsapp ?? false;

              setState(() {});
              log("enableAll: ${data?.enableAll}");
              log("orderEmail: ${data?.orderEmail}");
              log("orderPush: ${data?.orderPush}");
              log("orderSMS: ${data?.orderSms}");
              log("orderWhatsapp: ${data?.orderWhatsapp}");
              log("promoEmail: ${data?.prmotionEmail}");
              log("promoPush: ${data?.prmotionPush}");
              log("promoSMS: ${data?.prmotionSms}");
              log("promoWhatsapp: ${data?.prmotionWhatsapp}");
            }
          },
          child: BlocConsumer<UpdateNotificationCubit, UpdateNotificationState>(
            listener: (context, state) {
              if (state is UpdateNotificationLoadedState) {
                Fluttertoast.showToast(msg: "Profile Update Successfully");

                Navigator.pop(context);
              }

              if (state is UpdateNotificationErrorState) {
                Fluttertoast.showToast(msg: state.error);
              }
            },
            builder: (context, estate) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Enable all",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Activate all notifications",
                              style: TextStyle(fontSize: 14, color: greyColor),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: enableAll,
                        onChanged: (v) {
                          setState(() {
                            enableAll = v;
                            // Order notifications
                            orderEmail = v;
                            orderPush = v;
                            orderSMS = v;
                            orderWhatsapp = v;

                            // Promotion notifications
                            promoEmail = v;
                            promoPush = v;
                            promoSMS = v;
                            promoWhatsapp = v;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Order and bookings",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Receive updates related to your booking",
                        style: TextStyle(fontSize: 12, color: greyColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Tile(
                    title: "Email",
                    value: orderEmail,
                    onChanged: (v) => setState(() => orderEmail = v),
                  ),
                  Tile(
                    title: "Push",
                    value: orderPush,
                    onChanged: (v) => setState(() => orderPush = v),
                  ),
                  Tile(
                    title: "SMS",
                    value: orderSMS,
                    onChanged: (v) => setState(() => orderSMS = v),
                  ),
                  Tile(
                    title: "Whatsapp",
                    value: orderWhatsapp,
                    onChanged: (v) => setState(() => orderWhatsapp = v),
                  ),

                  const SizedBox(height: 14),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Promos & Offers",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Receive updates related to your offers",
                        style: TextStyle(fontSize: 12, color: greyColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Tile(
                    title: "Email",
                    value: promoEmail,
                    onChanged: (v) => setState(() => promoEmail = v),
                  ),
                  Tile(
                    title: "Push",
                    value: promoPush,
                    onChanged: (v) => setState(() => promoPush = v),
                  ),
                  Tile(
                    title: "SMS",
                    value: promoSMS,
                    onChanged: (v) => setState(() => promoSMS = v),
                  ),
                  Tile(
                    title: "Whatsapp",
                    value: promoWhatsapp,
                    onChanged: (v) => setState(() => promoWhatsapp = v),
                  ),

                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: SimpleButton(
                      title: "   Save Changes ",
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      onPressed: () {
                        context
                            .read<UpdateNotificationCubit>()
                            .updateNotification(
                              enableAll: enableAll,
                              orderEmail: orderEmail,
                              orderPush: orderPush,
                              orderSms: orderSMS,
                              orderWhatsapp: orderWhatsapp,
                              promotionEmail: promoEmail,
                              promotionPush: promoPush,
                              promotionSms: promoSMS,
                              promotionWhatsapp: promoWhatsapp,
                            );
                      },
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
