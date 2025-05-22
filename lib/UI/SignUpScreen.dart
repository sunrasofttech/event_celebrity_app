import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobi_user/Bloc/Auth/RegisterBloc/RegisterCubit.dart';
import 'package:mobi_user/UI/MainScreen.dart';
import 'package:mobi_user/UI/SignInScreen.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:mobi_user/Widget/ButtonWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Bloc/Auth/RegisterBloc/RegisterState.dart';
import '../Bloc/GetPhoneNumberBloc/GetPhoneNumberCubit.dart';
import '../Bloc/GetPhoneNumberBloc/GetPhoneNumberState.dart';
import '../Utility/CustomFont.dart';
import '../Utility/const.dart';
import '../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static const MethodChannel _sourceChannel = MethodChannel('source_channel');
  TextEditingController _fullName = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _pass = TextEditingController();

  TextEditingController _email = TextEditingController();
  TextEditingController _refer = TextEditingController();
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  bool flag1 = true;
  bool flag2 = true;

  validateMobile(String value) {
    print("Object => $value");
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
        await launchUrl(Uri.parse(whatsappURL_ios));
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
  void initState() {
    context.read<GetPhoneNumberCubit>().getGetPhoneNumbersApiCall();

    super.initState();
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _pass.dispose();
    _email.dispose();
    _refer.dispose();
    super.dispose();
  }

  // ✅ Get App Source (Play Store or Website)
  static Future<String?> getAppSource() async {
    try {
      final String source = await _sourceChannel.invokeMethod('getSource');
      return source;
    } catch (e) {
      return null;
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
        //     begin: Alignment.topLeft,
        //     end: Alignment.centerRight,
        //     tileMode: TileMode.mirror,
        //     stops: [0.1, 0.5, 0.9],
        //     colors: gradientColor,
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
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("asset/icons/signup_page.png"))),
                ),
              ),
              const SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Wrap(
              //     direction: Axis.vertical,
              //     crossAxisAlignment: WrapCrossAlignment.start,
              //     children: [
              //       Text("Hello", style: whiteStyle.copyWith(fontSize: 24)),
              //       Text("Let's Get Started", style: whiteStyle.copyWith(fontSize: 24)),
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
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  ),
                  margin: EdgeInsets.zero,
                  child: Form(
                    key: signUpKey,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              "Sign Up",
                              style: blackStyle.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _fullName,
                              maxLength: 15,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))],
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "This field is required";
                                }
                                return null;
                              },
                              cursorColor: blackColor,
                              style: blackStyle,
                              decoration: InputDecoration(
                                counterText: "",
                                label: Text("Full Name"),
                                prefixIcon: Icon(Icons.person),
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _phone,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                              validator: (val) => validateMobile(val.toString()),
                              cursorColor: blackColor,
                              style: blackStyle,
                              decoration: InputDecoration(
                                counterText: "",
                                label: Text("Mobile No"),
                                prefixIcon: Icon(Icons.call),
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: TextFormField(
                          //     controller: _email,
                          //     keyboardType: TextInputType.emailAddress,
                          //     validator: (val) {
                          //       if (val!.isEmpty) {
                          //         return "This field is required";
                          //       }
                          //       return null;
                          //     },
                          //     cursorColor: blackColor,
                          //     style: blackStyle,
                          //     decoration: InputDecoration(
                          //       counterText: "",
                          //       label: Text("Email"),
                          //       prefixIcon: Icon(Icons.email),
                          //       contentPadding: const EdgeInsets.all(15),
                          //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _pass,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]")),
                              ],
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "This field is required";
                                } else if (val.length < 6) {
                                  return "password more than 6 character";
                                }
                                return null;
                              },
                              style: blackStyle,
                              cursorColor: blackColor,
                              obscureText: flag1,
                              decoration: InputDecoration(
                                label: Text("Password"),
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      flag1 = !flag1;
                                    });
                                  },
                                  icon: Icon(flag1 ? Icons.visibility_off : Icons.visibility),
                                ),
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                          BlocConsumer<RegisterCubit, RegisterState>(
                            listener: (context, state) async {
                              if (state is LoadedState) {
                                await pref.setString("key", state.model.data?.id?.toString() ?? "-");
                                await pref.setString(
                                  sharedPrefAPITokenKey,
                                  state.model.data?.apiToken?.toString() ?? "-",
                                );
                                Fluttertoast.showToast(msg: "Registration Successful");
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0.0, 1.0),
                                          end: Offset.zero,
                                        ).animate(CurvedAnimation(parent: animation, curve: Curves.bounceIn)),
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
                                title: Text("Sign Up", style: whiteStyle.copyWith(fontWeight: FontWeight.bold)),
                                primaryColor: primaryColor,
                                callback: () async {
                                  if (signUpKey.currentState!.validate()) {
                                    final _source = await getAppSource();
                                    context.read<RegisterCubit>().signUp(
                                      username: _fullName.text,
                                      mobile: _phone.text,
                                      email: _email.text,
                                      pass: _pass.text,
                                      refer: _refer.text,
                                      source: _source.toString(),
                                    );
                                    signUpKey.currentState!.save();
                                  }
                                },
                              );
                            },
                          ),
                          ButtonWidget(
                            title: Text(
                              "For Already Register User",
                              style: whiteStyle.copyWith(fontWeight: FontWeight.bold),
                            ),
                            primaryColor: primaryColor,
                            callback: () {
                              // _showAdminPermissionDialog(context, packageId);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => SignInScreen()),
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
                                      Icon(FontAwesomeIcons.whatsapp, color: Colors.white, size: 40),
                                      const SizedBox(width: 5),
                                      Text("Help", style: whiteStyle),
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
            ],
          ),
        ),
      ),
    );
  }
}
