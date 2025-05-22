import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_user/Utility/MainColor.dart';

import '../../Bloc/Auth/RegisterBloc/RegisterCubit.dart';
import '../../Bloc/Auth/RegisterBloc/RegisterState.dart';
import '../../Utility/const.dart';
import '../../main.dart';
import '../MainScreen.dart';

class CreateNewProfileScreen extends StatefulWidget {
  final String mobileNumber;

  const CreateNewProfileScreen({super.key, required this.mobileNumber});
  @override
  State<CreateNewProfileScreen> createState() => _CreateNewProfileScreenState();
}

class _CreateNewProfileScreenState extends State<CreateNewProfileScreen> {
  TextEditingController _fullName = TextEditingController();
  TextEditingController _pass = TextEditingController();
  bool flag1 = true;
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  static const MethodChannel _sourceChannel = MethodChannel('source_channel');

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
  void dispose() {
    _fullName.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAE9E9),
      body: SafeArea(
        child: Form(
          key: signUpKey,
          child: Stack(
            children: [
              // Top Illustration
              // Background Image at the Top
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'asset/icons/signup_img.png',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5.0, offset: Offset(0, -2), spreadRadius: 2.0)],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Title
                        Text(
                          translate('create_username_title'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryColor, // Dark blue color
                          ),
                        ),

                        SizedBox(height: 20),

                        // Username Input
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: TextField(
                            controller: _fullName,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person, color: Colors.grey),
                              hintText: translate('username_hint'),
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: greyColor)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: greyColor)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: primaryColor)),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Password
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: TextFormField(
                            controller: _pass,
                            keyboardType: TextInputType.phone,
                            maxLength: 4,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
                            validator: (val) {
                              if (val!.isEmpty) {
                                return translate('mpin_required_error');
                              } else if (val.length < 4) {
                                return translate('mpin_length_error');
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: translate('mpin_hint'),
                              hintStyle: TextStyle(color: Colors.grey),
                              prefixIcon: Icon(Icons.lock, color: Colors.grey),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    flag1 = !flag1;
                                  });
                                },
                                icon: Icon(flag1 ? Icons.visibility_off : Icons.visibility),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: greyColor)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: greyColor)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: primaryColor)),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Create Button
                        BlocConsumer<RegisterCubit, RegisterState>(
                          listener: (context, state) async {
                            if (state is LoadedState) {
                              await pref.setString("key", state.model.data?.id?.toString() ?? "-");
                              await pref.setString(sharedPrefAPITokenKey, state.model.data?.apiToken?.toString() ?? "-");

                              Fluttertoast.showToast(msg: translate('registration_success'));
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
                            } else if (state is ErrorState) {
                              Fluttertoast.showToast(msg: state.error);
                            }
                          },
                          builder: (context, state) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed:
                                      (state is LoadingState)
                                          ? null
                                          : () async {
                                            if (signUpKey.currentState!.validate()) {
                                              final _source = await getAppSource();
                                              context.read<RegisterCubit>().signUp(
                                                username: _fullName.text,
                                                mobile: widget.mobileNumber,
                                                email: "",
                                                pass: _pass.text,
                                                refer: "",
                                                source: _source.toString(),
                                              );
                                              signUpKey.currentState!.save();
                                            }
                                          },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor, // Dark blue color
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                  ),
                                  child:
                                      (state is LoadingState)
                                          ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(playColor))
                                          : Text(
                                            translate('create_button'),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: whiteColor, // Yellow text color
                                            ),
                                          ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 40),
                      ],
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
