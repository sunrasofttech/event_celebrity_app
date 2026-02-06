
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Bloc/Auth/LoginBloc/LoginCubit.dart';
import 'package:planner_celebrity/Bloc/Auth/LoginBloc/LoginState.dart';
import 'package:planner_celebrity/UI/MainScreen.dart';
import 'package:planner_celebrity/Utility/SimpleButton.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utility/CustomTextField.dart';
import '../../Utility/MainColor.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) async {
              if (state is LoadedState) {
                Fluttertoast.showToast(msg: "Login Successful");

                final pref = await SharedPreferences.getInstance();
                await pref.setString(
                  sharedPrefUserIdKey,
                  state.model.data?.celebrity?.id?.toString() ?? "",
                );
                await pref.setString(
                  sharedPrefAPITokenKey,
                  state.model.data?.token?.toString() ?? "",
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                  (c) => false,
                );
              }

              if (state is ErrorState) {
                Fluttertoast.showToast(msg: state.error);
                return;
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Back Button
                  // Container(
                  //   height: 50,
                  //   width: 50,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: const Icon(Icons.arrow_left, color: greyColor),
                  // ),

                  const SizedBox(height: 40),

                  /// Title
                  const Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 20),
                  Center(
                    child: Image.asset(
                      'asset/icons/signup_img.png',
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Mobile
                  CustomTextField(
                    controller: mobileController,
                    hintText: "Mobile",
                    keyboardType: TextInputType.phone,
                    prefixIcon: IconsaxPlusBold.mobile,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(10)],
                  ),

                  const SizedBox(height: 12),

                  /// Password
                  CustomTextField(
                    maxLine: 1,
                    controller: passwordController,
                    hintText: "Password",
                    prefixIcon: IconsaxPlusBold.lock,
                    obscureText: obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? IconsaxPlusBold.eye_slash
                            : IconsaxPlusBold.eye,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => obscurePassword = !obscurePassword);
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// Continue Button
                  SizedBox(
                    width: double.infinity,
                    child: SimpleButton(
                      onPressed: () {
                        if (state is LoadingState) return;
                        if (mobileController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "All Fields are required",
                          );
                          return;
                        }

                        context.read<LoginCubit>().signIn(
                          mobileController.text,
                          passwordController.text,
                        );
                      },
                      title: "Continue",
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Already a member?
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
