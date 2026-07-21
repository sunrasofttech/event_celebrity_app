abstract class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {}

class SendOtpLoading extends RegisterState {}

class SendOtpSuccess extends RegisterState {
  final String message;
  final String mobile;
  const SendOtpSuccess({required this.message, required this.mobile});
}

class SendOtpError extends RegisterState {
  final String error;
  const SendOtpError(this.error);
}

class VerifyRegisterLoading extends RegisterState {}

class VerifyRegisterSuccess extends RegisterState {
  final Map<String, dynamic> responseData;
  final String message;
  const VerifyRegisterSuccess({required this.responseData, required this.message});
}

class VerifyRegisterError extends RegisterState {
  final String error;
  const VerifyRegisterError(this.error);
}
