import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobi_user/Bloc/SendOtpBloc/sendotp_cubit.dart';

import '../../Bloc/SendOtpBloc/sendotp_state.dart';
import '../../Utility/MainColor.dart';
import 'CreateNewProfileScreen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.mobileNumber});
  final String mobileNumber;
  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  String? sentOTP;
  Timer? _timer;
  int _start = 30;
  final _timerValue = ValueNotifier<int>(60);
  final _isButtonDisabled = ValueNotifier<bool>(false);

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _timer?.cancel();
    _isButtonDisabled.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<SendOtpCubit>().sendOtp(widget.mobileNumber);
      startTimer();
    });
    super.initState();
  }

  void startTimer() {
    _isButtonDisabled.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_start == 0) {
        _isButtonDisabled.value = false;

        _timer?.cancel();
      } else {
        _start--;
        _timerValue.value = _start;
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    _start = 60;
    _timerValue.value = 60;
    startTimer();
  }

  Widget _buildResendButton() {
    return BlocBuilder<SendOtpCubit, SendOtpState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _isButtonDisabled,
                  builder: (context, value, child) {
                    return RichText(
                      text: TextSpan(
                        text: 'Having trouble? ',
                        style: const TextStyle(
                          color: Color(0xff888888),
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Resend OTP',
                            style: TextStyle(
                              color: (value) ? Colors.grey : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                if (!value) {
                                  resetTimer();
                                  context.read<SendOtpCubit>().sendOtp(widget.mobileNumber);
                                }
                              },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder<int>(
                  valueListenable: _timerValue,
                  builder: (context, value, child) {
                    return Text(
                      'Time remaining: $value seconds',
                      style: const TextStyle(color: Colors.grey),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F8FD), // Light background color
      body: BlocConsumer<SendOtpCubit, SendOtpState>(
        listener: (context, state) async {
          if (state is SendOtpLoadedState) {
            sentOTP = state.model.otp?.toString();
          } else if (state is SendOtpErrorState) {
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
                  'asset/icons/fingerprint.png', // Replace with your asset path
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 20),

                // Title
                Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor, // Dark blue color
                  ),
                ),
                SizedBox(height: 20),

                // MPin Input Boxes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.blueGrey,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black, // Ensure visible text color
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (value) {
                            // Move focus to the next field if not the last field
                            if (value.isNotEmpty && index < 5) {
                              FocusScope.of(context).nextFocus();
                            }

                            // When all fields are filled, call the function
                            if (_controllers.every((controller) => controller.text.isNotEmpty)) {
                              String mOTP = _controllers.map((controller) => controller.text).join('');
                              FocusScope.of(context).unfocus();

                              if (sentOTP == mOTP) {
                                Fluttertoast.showToast(msg: "OTP Verified Successfully");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateNewProfileScreen(
                                      mobileNumber: widget.mobileNumber,
                                    ),
                                  ),
                                );
                              } else {
                                Fluttertoast.showToast(msg: "InValid OTP!");
                              }
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
                _buildResendButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
