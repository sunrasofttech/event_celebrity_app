import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingCubit.dart';
import 'package:mobi_user/Utility/MainColor.dart';

import '../Bloc/SettingBloc/SettingState.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Privacy Policy"),
        ),
        body: BlocBuilder<SettingCubit, SettingState>(
          builder: (context, state) {
            if (state is SettingLoadedState) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(
                    data: "" /*?? state.model.data?[0].privacy*/,
                    style: {
                      '*': Style(
                        color: whiteColor,
                        textAlign: TextAlign.justify,
                        fontSize: FontSize(16),
                      ),
                    },
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
