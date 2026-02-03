import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Bloc/share_feedback/share_feedback_cubit.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:planner_celebrity/Utility/SimpleButton.dart';

class ShareFeedbackScreen extends StatefulWidget {
  const ShareFeedbackScreen({super.key});

  @override
  State<ShareFeedbackScreen> createState() => _ShareFeedbackScreenState();
}

class _ShareFeedbackScreenState extends State<ShareFeedbackScreen> {
  TextEditingController feedBackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: const Icon(IconsaxPlusBold.arrow_left_3, color: greyColor),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Share Feedback",
          style: TextStyle(
            color: titleTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocConsumer<ShareFeedbackCubit, ShareFeedbackState>(
          listener: (context, state) {
            if (state is ShareFeedbackErrorState) {
              Fluttertoast.showToast(msg: state.error);
            }
            if (state is ShareFeedbackLoadedState) {
              Fluttertoast.showToast(msg: "Send Successfully");
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                TextFormField(
                  controller: feedBackController,
                  maxLines: 5,
                  minLines: 5,
                  textInputAction: TextInputAction.newline,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Share your feedback",
                    hintStyle: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child:
                          state is ShareFeedbackLoadingState
                              ? Center(child: CircularProgressIndicator())
                              : SimpleButton(
                                onPressed: () {
                                  context
                                      .read<ShareFeedbackCubit>()
                                      .shareFeedback(
                                        feedBackController.text.trim(),
                                      );
                                },
                                title: "Submit",
                              ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
