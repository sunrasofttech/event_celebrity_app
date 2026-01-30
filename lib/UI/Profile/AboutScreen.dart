import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingCubit.dart';
import 'package:planner_celebrity/Bloc/SettingBloc/SettingState.dart';
import 'package:planner_celebrity/UI/PrivacyPolicyScreen.dart';

import '../../Utility/MainColor.dart';
import 'SettingScreen.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
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
          "About",
          style: TextStyle(
            color: titleTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      body: BlocBuilder<SettingCubit, SettingState>(
        builder: (context, state) {
          if (state is SettingLoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is SettingErrorState) {
            return Center(child: Text(state.error));
          }
          if (state is SettingLoadedState) {
            final aboutUs = state.model.data?.celebrityAppAbout;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Html(
                    data: aboutUs,
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
                  const SizedBox(height: 12),
                  // ProfileTile(
                  //   icon: IconsaxPlusBold.security,
                  //   title: "Account Settings",
                  //   onTap: () {},
                  // ),
                  ProfileTile(
                    icon: IconsaxPlusBold.profile,
                    title: "Privacy Policy",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PrivacyPolicyScreen(
                                policy:
                                    state.model.data?.celebrityAppPrivacy ?? "",
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
