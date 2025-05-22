import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../Bloc/withdrwaDetails/withdraw_details_bloc.dart';
import '../Bloc/withdrwaDetails/withdraw_details_event.dart';
import '../model/bankDetailsModel.dart';

class AddBankDetailsScreen extends StatefulWidget {
  final BankDetailsModel details;

  const AddBankDetailsScreen({super.key, required this.details});

  @override
  State<AddBankDetailsScreen> createState() => _AddBankDetailsScreenState();
}

class _AddBankDetailsScreenState extends State<AddBankDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool accountNoVisible = true;
  bool reAccountNoVisible = true;

  late TextEditingController bankAccountController;
  late TextEditingController reBankController;
  late TextEditingController bankNameController;
  late TextEditingController ifscController;
  late TextEditingController upiPayController;
  late TextEditingController paytmController;
  late TextEditingController placeholder;

  @override
  void initState() {
    super.initState();
    bankAccountController = TextEditingController(text: widget.details.accountNo);
    reBankController = TextEditingController(text: widget.details.accountNo);
    bankNameController = TextEditingController(text: widget.details.name);
    ifscController = TextEditingController(text: widget.details.ifsc);
    upiPayController = TextEditingController(text: widget.details.upi);
    paytmController = TextEditingController(text: widget.details.paytm);
    placeholder = TextEditingController(text: widget.details.placeholder);
  }

  @override
  void dispose() {
    bankAccountController.dispose();
    reBankController.dispose();
    bankNameController.dispose();
    ifscController.dispose();
    upiPayController.dispose();
    paytmController.dispose();
    placeholder.dispose();
    super.dispose();
  }

  Widget _inputField(String labelKey, TextEditingController controller, {bool isPassword = false, VoidCallback? toggle, bool validatorOff = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        // validator: (value) => validatorOff ? null :  (value == null || value.isEmpty ? translate("field_required") : null),
        decoration: InputDecoration(
          labelText: translate(labelKey),
          suffixIcon: toggle != null ? IconButton(icon: Icon(isPassword ? Icons.visibility_off : Icons.visibility), onPressed: toggle) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate("add_bank_details")), backgroundColor: Colors.black87, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Center(child: Image.asset("asset/icons/bank_icon.png", height: 60)),
              // const SizedBox(height: 20),
              _inputField("account_holder_name", placeholder),

              _inputField(
                "account_number",
                bankAccountController,
                isPassword: accountNoVisible,
                toggle: () {
                  setState(() {
                    accountNoVisible = !accountNoVisible;
                  });
                },
              ),
              _inputField(
                "re_enter_account_number",
                reBankController,
                isPassword: reAccountNoVisible,
                toggle: () {
                  setState(() {
                    reAccountNoVisible = !reAccountNoVisible;
                  });
                },
              ),
              _inputField("ifsc_code", ifscController),
              _inputField("bank_name", bankNameController),

              Text("OR"),
              const SizedBox(height: 10),
              _inputField("upi", upiPayController),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      BlocProvider.of<WithdrawDetailsBloc>(context).add(
                        AddBankDetailsEvent(
                          bankAcc: bankAccountController.text,
                          ifsc: ifscController.text,
                          paytm: paytmController.text,
                          phonepe: upiPayController.text,
                          bankName: bankNameController.text,
                          upiPay: upiPayController.text,
                          placeholder: placeholder.text,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(translate("add_bank_account"), style: const TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
