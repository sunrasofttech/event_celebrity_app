import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobi_user/Bloc/Auth/LoginBloc/LoginState.dart';
import 'package:mobi_user/Bloc/GetPhoneNumberBloc/GetPhoneNumberState.dart';
import 'package:mobi_user/UI/MainScreen.dart';
import 'package:mobi_user/Utility/const.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Bloc/Auth/LoginBloc/LoginCubit.dart';
import '../Bloc/GetPhoneNumberBloc/GetPhoneNumberCubit.dart';
import '../Utility/CustomFont.dart';
import '../Utility/MainColor.dart';
import '../Widget/ButtonWidget.dart';
import '../main.dart';
import 'SignUpScreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController _phone;
  late TextEditingController _pass;
  bool flag = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<GetPhoneNumberCubit>().getGetPhoneNumbersApiCall();
    _phone = TextEditingController();
    _pass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phone.dispose();
    _pass.dispose();
    super.dispose();
  }

  validateMobile(String value) {
    String pattern = r"^(?:(?:\+|0{0,2})91(\s*|[\-])?|[0]?)?([6789]\d{2}([ -]?)\d{3}([ -]?)\d{4})$";
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (value.length != 10) {
      return "Mobile no must be 10 digit";
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  openWhatsapp(number) async {
    var whatsapp = number;
    var whatsappURl_android = "whatsapp://send?phone=" + whatsapp + "&text=";
    var whatsappURL_ios = "https://wa.me/$whatsapp?text=";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURL_ios))) {
        await launchUrl(
          Uri.parse(whatsappURL_ios),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURl_android))) {
        await launchUrl((Uri.parse(whatsappURl_android)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //       begin: Alignment.topLeft,
        //       end: Alignment.centerRight,
        //       tileMode: TileMode.mirror,
        //       stops: [0.1, 0.4, 0.9],
        //       colors: gradientColor,
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("asset/icons/login_page.png"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Wrap(
              //     direction: Axis.vertical,
              //     crossAxisAlignment: WrapCrossAlignment.start,
              //     children: [
              //       Text("Hi", style: whiteStyle.copyWith(fontSize: 24)),
              //       Text("Welcome", style: whiteStyle.copyWith(fontSize: 24)),
              //     ],
              //   ),
              // ),
              Expanded(
                child: Card(
                  elevation: 10,
                  color: Colors.white,
                  shadowColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  margin: EdgeInsets.zero,
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Login",
                                style: blackStyle.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _phone,
                                maxLength: 10,
                                style: blackStyle,
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                validator: (val) => validateMobile(val.toString()),
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  label: Text("Mobile No", style: blackStyle.copyWith()),
                                  counterText: "",
                                  prefixIcon: Icon(Icons.call),
                                  contentPadding: const EdgeInsets.all(15),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                style: blackStyle,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]")),
                                  FilteringTextInputFormatter.deny(RegExp(r'\s'))
                                ],
                                controller: _pass,
                                obscureText: flag,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "This field is required";
                                  } else if (val.length < 6) {
                                    return "password more than 6 character";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        flag = !flag;
                                      });
                                    },
                                    icon: Icon(
                                      flag ? Icons.visibility_off : Icons.visibility,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(15),
                                  label: Text("Password", style: blackStyle),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: BlocBuilder<GetPhoneNumberCubit, GetPhoneNumberState>(
                                builder: (context, state) {
                                  return Center(
                                    child: TextButton(
                                      child: Text(
                                        "Forgot Password?",
                                        style: blackStyle.copyWith(
                                          decorationColor: blackColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (state is GetPhoneNumberLoadedState) {
                                          await launchUrl(
                                            Uri.parse(
                                              "https://wa.me/${state.model}?text=Hello admin forgot password",
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            BlocConsumer<LoginCubit, LoginState>(
                              listener: (context, state) async {
                                if (state is LoadedState) {
                                  await pref.setString("key", state.model.data?.id?.toString() ?? "-");
                                  await pref.setString(
                                    sharedPrefAPITokenKey,
                                    state.model.data?.apiToken?.toString() ?? "-",
                                  );
                                  debugPrint(
                                    "this is data key: ${state.model.data?.id?.toString()} and "
                                    "api key: ${state.model.data?.apiToken?.toString()}",
                                  );
                                  debugPrint(
                                    "this is key: ${pref.getString("key")}"
                                    "and api key: ${pref.getString(sharedPrefAPITokenKey)}",
                                  );
                                  Fluttertoast.showToast(msg: "Login Successful");
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, child) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0.0, 1.0),
                                            end: Offset.zero,
                                          ).animate(
                                            CurvedAnimation(parent: animation, curve: Curves.bounceIn),
                                          ),
                                          child: const MainScreen(),
                                        );
                                      },
                                    ),
                                  );
                                } else if (state is ErrorState) {
                                  Fluttertoast.showToast(msg: state.error);
                                }
                              },
                              builder: (context, state) {
                                if (state is LoadingState) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }
                                return ButtonWidget(
                                  title: Text("LOGIN", style: whiteStyle.copyWith(fontWeight: FontWeight.bold)),
                                  primaryColor: primaryColor,
                                  callback: () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<LoginCubit>().signIn(_phone.text, _pass.text);
                                      formKey.currentState!.save();
                                    }
                                  },
                                );
                              },
                            ),
                            ButtonWidget(
                              title: Text(
                                "Create New Account",
                                style: whiteStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              primaryColor: primaryColor,
                              callback: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUpScreen(),
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<GetPhoneNumberCubit, GetPhoneNumberState>(
                              builder: (context, state) {
                                if (state is GetPhoneNumberLoadedState) {
                                  return FloatingActionButton.extended(
                                    backgroundColor: Colors.green,
                                    heroTag: "whatsapp",
                                    onPressed: () {
                                      openWhatsapp(state.model);
                                    },
                                    label: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.whatsapp,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        const SizedBox(width: 5),
                                        Text("Help", style: whiteStyle)
                                      ],
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
