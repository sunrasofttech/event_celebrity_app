import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingCubit.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingState.dart';
import 'package:planner_celebrity/Bloc/get_profile/get_profile_cubit.dart';
import 'package:planner_celebrity/Utility/CustomTextField.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:share_plus/share_plus.dart';

import 'package:planner_celebrity/Utility/SimpleButton.dart';
import 'package:url_launcher/url_launcher.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController messageCtr = TextEditingController();
  String fullName = "";
  String? email = "";
  String mobile = "";

  @override
  void initState() {
    context.read<GetProfileCubit>().getProfile();
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
          "Edit Profile",
          style: TextStyle(
            color: titleTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      body: BlocListener<GetProfileCubit, GetProfileState>(
        listener: (context, state) {
          if (state is GetProfileLoadedState) {
            setState(() {
              fullName = state.model.data?.fullName ?? "";
              email = state.model.data?.email ?? "";
              mobile = state.model.data?.mobile ?? "";
            });
          }
        },
        child: BlocBuilder<SettingCubit, SettingState>(
          builder: (context, state) {
            if (state is SettingLoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is SettingErrorState) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Text(state.error ?? ""),
              );
            }
            if (state is SettingLoadedState) {
              final moblieNo = state.model.data?.contact ?? "";
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Message", style: TextStyle()),

                    CustomTextField(
                      maxLine: 6,
                      controller: messageCtr,
                      hintText: "Your Message here..",
                      keyboardType: TextInputType.name,
                    ),

                    SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: SimpleButton(
                        onPressed: () async {
                          if (messageCtr.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter a message"),
                              ),
                            );
                            return;
                          }

                          final message = """
Request to Admin

Name: $fullName
Email: $email
Mobile: $mobile

Message:
${messageCtr.text}
""";

                          await sendToWhatsApp(
                            phone: moblieNo, // "9748478333"
                            message: message,
                          );
                        },

                        title: "Request to Admin",
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox();
          },
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
