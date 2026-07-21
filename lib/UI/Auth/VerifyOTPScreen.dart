import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Bloc/Auth/LoginBloc/LoginCubit.dart';
import 'package:planner_celebrity/Bloc/Auth/LoginBloc/LoginState.dart';
import 'package:planner_celebrity/Bloc/Auth/RegisterBloc/RegisterCubit.dart';
import 'package:planner_celebrity/Bloc/Auth/RegisterBloc/RegisterState.dart';
import 'package:planner_celebrity/Bloc/SessionKeyBloc/SessionKeyCubit.dart';
import 'package:planner_celebrity/UI/Auth/LoginScreen.dart';
import 'package:planner_celebrity/UI/MainScreen.dart';
import 'package:planner_celebrity/Utility/CustomTextField.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:planner_celebrity/Utility/SimpleButton.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/model/userProfileModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String mobile;
  final String email;
  final String password;
  final String fullName;
  final String publicHandle;
  final String shortBio;
  final String location;
  final String cityId;
  final List<String> categoryIds;
  final List<RateCard> rateCard;
  final String instagramHandle;
  final String twitterHandle;
  final String? profilePicturePath;

  const VerifyOTPScreen({
    super.key,
    required this.mobile,
    required this.email,
    required this.password,
    required this.fullName,
    required this.publicHandle,
    required this.shortBio,
    required this.location,
    required this.cityId,
    required this.categoryIds,
    required this.rateCard,
    required this.instagramHandle,
    required this.twitterHandle,
    this.profilePicturePath,
  });

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: MultiBlocListener(
            listeners: [
              BlocListener<LoginCubit, LoginState>(
                listener: (context, state) async {
                  if (state is LoadedState) {
                    final pref = await SharedPreferences.getInstance();
                    await pref.setString(
                      sharedPrefUserIdKey,
                      state.model.data?.celebrity?.id?.toString() ?? "",
                    );
                    await pref.setString(
                      sharedPrefAPITokenKey,
                      state.model.data?.token?.toString() ?? "",
                    );
                    await context.read<SessionKeyCubit>().sessionKey(
                      tok: state.model.data?.token?.toString(),
                    );
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MainScreen(
                                isApproved:
                                    state.model.data?.celebrity?.isApproved,
                              ),
                        ),
                        (c) => false,
                      );
                    }
                  }

                  if (state is ErrorState) {
                    Fluttertoast.showToast(msg: state.error);
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (c) => false,
                      );
                    }
                  }
                },
              ),
              BlocListener<RegisterCubit, RegisterState>(
                listener: (context, state) async {
                  if (state is VerifyRegisterSuccess) {
                    Fluttertoast.showToast(
                      msg: "Registration successful! Logging in...",
                    );
                    if (mounted) {
                      // Perform login automatically after register
                      context.read<LoginCubit>().signIn(
                        widget.mobile,
                        widget.password,
                      );
                    }
                  }

                  if (state is VerifyRegisterError) {
                    Fluttertoast.showToast(msg: state.error);
                  }

                  if (state is SendOtpSuccess) {
                    Fluttertoast.showToast(msg: "OTP Resent successfully");
                  }

                  if (state is SendOtpError) {
                    Fluttertoast.showToast(msg: state.error);
                  }
                },
              ),
            ],
            child: BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Back Button
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// Title
                    const Text(
                      "Verify OTP",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Subtitle
                    RichText(
                      text: TextSpan(
                        text: "OTP has been sent to your mobile number ",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "+91 ${widget.mobile}",
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// OTP Input Field
                    CustomTextField(
                      controller: otpController,
                      hintText: "Enter OTP",
                      keyboardType: TextInputType.number,
                      prefixIcon: IconsaxPlusBold.security_card,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                    ),

                    const SizedBox(height: 40),

                    /// Verify & Register Button
                    SizedBox(
                      width: double.infinity,
                      child:
                          (state is VerifyRegisterLoading)
                              ? const Center(child: CircularProgressIndicator())
                              : SimpleButton(
                                onPressed: () {
                                  if (otpController.text.trim().isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: "Please enter the OTP",
                                    );
                                    return;
                                  }

                                  context
                                      .read<RegisterCubit>()
                                      .verifyOtpRegister(
                                        otp: otpController.text.trim(),
                                        mobile: widget.mobile,
                                        email: widget.email,
                                        password: widget.password,
                                        fullName: widget.fullName,
                                        publicHandle: widget.publicHandle,
                                        shortBio: widget.shortBio,
                                        location: widget.location,
                                        cityId: widget.cityId,
                                        categoryIds: widget.categoryIds,
                                        rateCard: widget.rateCard,
                                        instagramHandle: widget.instagramHandle,
                                        twitterHandle: widget.twitterHandle,
                                        profilePicturePath:
                                            widget.profilePicturePath,
                                      );
                                },
                                title: "Verify & Complete Registration",
                              ),
                    ),

                    const SizedBox(height: 25),

                    /// Resend OTP
                    Center(
                      child:
                          (state is SendOtpLoading)
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : InkWell(
                                onTap: () {
                                  context.read<RegisterCubit>().sendOtp(
                                    widget.mobile,
                                  );
                                },
                                child: RichText(
                                  text: const TextSpan(
                                    text: "Didn't receive code? ",
                                    style: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "Resend OTP",
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
