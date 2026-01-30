import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:planner_celebrity/Bloc/changePassword/changeEvent.dart';
import 'package:planner_celebrity/Bloc/get_profile/get_profile_cubit.dart';
import 'package:planner_celebrity/error/api_failures.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Bloc/changePassword/changeBloc.dart';
import '../Bloc/changePassword/changeState.dart';
import '../Utility/CustomFont.dart';
import '../Utility/MainColor.dart';
import '../Widget/ButtonWidget.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({Key? key}) : super(key: key);

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  late TextEditingController _newpass;
  late TextEditingController _oldpass;
  late TextEditingController _confirm;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String fullName = "";
  String? email = "";
  String mobile = "";

  @override
  void initState() {
    _newpass = TextEditingController();
    _oldpass = TextEditingController();
    _confirm = TextEditingController();
    context.read<GetProfileCubit>().getProfile();
    super.initState();
  }

  @override
  void dispose() {
    _newpass.dispose();
    _oldpass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change Password")),
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
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _oldpass,
                    cursorColor: whiteColor,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]")),
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    style: blackStyle,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Old Password",
                      label: Text("Old Password"),
                      prefixIcon: Icon(Icons.lock),
                      hintStyle: blackStyle,
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: blackStyle,
                    cursorColor: whiteColor,
                    controller: _newpass,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]")),
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "This field is required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      label: Text("New Password"),
                      hintText: "Enter New Password",
                      hintStyle: blackStyle,
                      prefixIcon: Icon(Icons.lock),
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _confirm,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]")),
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    cursorColor: whiteColor,
                    style: blackStyle,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "This field is required";
                      } else if (_newpass.text != _confirm.text) {
                        return "password doesn't match";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintStyle: blackStyle,
                      label: Text("Confirm Password"),
                      prefixIcon: Icon(Icons.lock),
                      hintText: "Enter Confirm Password",
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: primaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                  listener: (context, state) {
                    if (state is ChangePasswordNowState) {
                      state.apiFailureOrSuccessOption.fold(
                        () => null,
                        (either) => either.fold(
                          (failure) {
                            final failureMessage = failure.failureMessage;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(failureMessage),
                                duration: const Duration(milliseconds: 1000),
                              ),
                            );
                          },
                          (right) {
                            Fluttertoast.showToast(
                              msg: "Password changed successfully",
                            );
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ButtonWidget(
                          title: Text("Submit", style: whiteStyle),
                          primaryColor: primaryColor,
                          callback: () {
                            if (_confirm.text != _newpass.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Password does not match with confirm password",
                                  ),
                                  duration: Duration(milliseconds: 1000),
                                ),
                              );
                              return;
                            }
                            if (formKey.currentState!.validate()) {
                              BlocProvider.of<ChangePasswordBloc>(
                                context,
                              ).add(InitialChangePassword());
                              BlocProvider.of<ChangePasswordBloc>(context).add(
                                ChangePasswordUserEvent(
                                  newPassword: _confirm.text,
                                  oldPassword: _oldpass.text,
                                ),
                              );
                              formKey.currentState!.save();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
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
