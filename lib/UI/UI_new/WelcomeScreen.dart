import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_user/Utility/MainColor.dart';

import '../../Bloc/CheckUserExistBloc/CheckUserExistCubit.dart';
import '../../Bloc/CheckUserExistBloc/CheckUserExitState.dart';
import 'AddMPScreen.dart';
import 'CreateNewProfileScreen.dart';

class GetStartedScreen extends StatefulWidget {
  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final TextEditingController _mobileController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEAE9E9),
      body: BlocConsumer<CheckUserCubit, CheckUserState>(
        listener: (context, state) {
          if (state is CheckUserLoadedState) {
            if (state.userType == "new") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateNewProfileScreen(mobileNumber: _mobileController.text)));
            } else if (state.userType == "old") {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddMPinScreen(mobileNo: _mobileController.text)));
            }
          } else if (state is CheckUserErrorState) {
            Fluttertoast.showToast(msg: state.error);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
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

                // Bottom Container
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Title
                          Text(
                            translate('auth.title'),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                          const SizedBox(height: 20),

                          // Mobile Number Input
                          TextField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone, color: Colors.grey),
                              hintText: translate('auth.mobile_hint'),
                              hintStyle: TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: greyColor)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: greyColor)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: primaryColor)),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  (state is CheckUserLoadingState)
                                      ? null
                                      : () {
                                        final mobile = _mobileController.text.trim();
                                        if (mobile.isEmpty || mobile.length != 10) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(translate('auth.invalid_mobile'))));
                                        } else {
                                          context.read<CheckUserCubit>().checkUserExist(mobile);
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child:
                                  (state is CheckUserLoadingState)
                                      ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(whiteColor))
                                      : Text(
                                        translate('auth.login_button'),
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: whiteColor),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
