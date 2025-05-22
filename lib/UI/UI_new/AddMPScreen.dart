import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Bloc/Auth/LoginBloc/LoginCubit.dart';
import '../../Bloc/Auth/LoginBloc/LoginState.dart';
import '../../Bloc/GetPhoneNumberBloc/GetPhoneNumberCubit.dart';
import '../../Bloc/GetPhoneNumberBloc/GetPhoneNumberState.dart';
import '../../Utility/const.dart';
import '../../main.dart';
import '../MainScreen.dart';

class AddMPinScreen extends StatefulWidget {
  const AddMPinScreen({super.key, required this.mobileNo});
  final String mobileNo;
  @override
  State<AddMPinScreen> createState() => _AddMPinScreenState();
}

class _AddMPinScreenState extends State<AddMPinScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());

  @override
  void initState() {
    context.read<GetPhoneNumberCubit>().getGetPhoneNumbersApiCall();
    super.initState();
  }

  openWhatsapp(number) async {
    var whatsapp = number;
    var whatsappURl_android = "whatsapp://send?phone=" + whatsapp + "&text=Hello Admin! I Forgot my password";
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
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F8FD), // Light background color
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("asset/icons/splash_bg.png"))),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) async {
            if (state is LoadedState) {
              await pref.setString("key", state.model.data?.id?.toString() ?? "-");
              await pref.setString(sharedPrefAPITokenKey, state.model.data?.apiToken?.toString() ?? "-");
              debugPrint(
                "this is data key: ${state.model.data?.id?.toString()} and "
                "api key: ${state.model.data?.apiToken?.toString()}",
              );
              debugPrint(
                "this is key: ${pref.getString("key")}"
                "and api key: ${pref.getString(sharedPrefAPITokenKey)}",
              );
              Fluttertoast.showToast(msg: "Login Successful");
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
            } else if (state is ErrorState) {
              Fluttertoast.showToast(msg: state.error);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Fingerprint Illustration
                  Image.asset(
                    'asset/icons/finger-print.png', // Replace with your asset path
                    width: 350,
                    height: 350,
                  ),
                  SizedBox(height: 20),

                  // Title
                  Text(
                    translate('mpin.title'),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor, // Dark blue color
                    ),
                  ),
                  SizedBox(height: 20),

                  // MPin Input Boxes
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) => Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _controllers[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black, // Ensure visible text color
                              fontWeight: FontWeight.bold,
                            ),
                            onChanged: (value) {
                              // Move focus to the next field if not the last field
                              if (value.isNotEmpty && index < 3) {
                                FocusScope.of(context).nextFocus();
                              }

                              // When all fields are filled, call the function
                              if (_controllers.every((controller) => controller.text.isNotEmpty)) {
                                String mPin = _controllers.map((controller) => controller.text).join('');
                                Fluttertoast.showToast(msg: "Processing");
                                FocusScope.of(context).unfocus();
                                context.read<LoginCubit>().signIn(widget.mobileNo, mPin);
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              counterText: '',
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Forgot MPin Link
                  BlocBuilder<GetPhoneNumberCubit, GetPhoneNumberState>(
                    builder: (context, state) {
                      if (state is GetPhoneNumberLoadedState) {
                        return GestureDetector(
                          onTap: () {
                            // Handle forgot MPIN logic

                            openWhatsapp(state.model);
                          },
                          child: Text(
                            translate('mpin.forgot'),
                            style: TextStyle(fontSize: 16, color: Colors.black, decoration: TextDecoration.underline),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
