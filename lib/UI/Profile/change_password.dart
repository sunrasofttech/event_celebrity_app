import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingCubit.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingState.dart';
import 'package:planner_celebrity/Bloc/get_profile/get_profile_cubit.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:planner_celebrity/Utility/SimpleButton.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String fullName = "";
  String? email = "";
  String mobile = "";
  String? moblieNo;

  @override
  void initState() {
    context.read<GetProfileCubit>().getProfile();
    context.read<SettingCubit>().getSettingsApiCall();
    super.initState();
  }

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
          "Change Password",
          style: TextStyle(
            color: titleTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocListener<SettingCubit, SettingState>(
        listener: (context, state) {
          log("----->> $state");
          if (state is SettingLoadedState) {
            moblieNo = state.model.data?.contact ?? "";
            setState(() {});
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: SimpleButton(
                  onPressed: () async {
                    final message = """
                        Change Password Request
      
                        Name: $fullName
                        Email: $email
                        Mobile: $mobile
      
                        Please reset my account password.
                         """;
                    log("------- $mobile $moblieNo");
                    await sendToWhatsApp(
                      phone: moblieNo ?? "",
                      message: message,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendToWhatsApp({
    required String phone,
    required String message,
  }) async {
    final encodedMessage = Uri.encodeComponent(message);

    final uri = Uri.parse("https://wa.me/91$phone?text=$encodedMessage");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open WhatsApp';
    }
  }
}
