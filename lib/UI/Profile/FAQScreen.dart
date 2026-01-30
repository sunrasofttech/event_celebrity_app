import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Bloc/AppContentsBloc/UserAppContentCubit.dart';
import 'package:planner_celebrity/Bloc/AppContentsBloc/UserAppContentState.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int? expandedIndex;

  @override
  void initState() {
    context.read<GetUserAppContentCubit>().getUserAppContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ---------- AppBar ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        IconsaxPlusBold.arrow_left_3,
                        color: greyColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "FAQs",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: titleTextColor,
                    ),
                  ),
                ],
              ),
            ),

            // ---------- FAQ List ----------
            BlocBuilder<GetUserAppContentCubit, GetUserAppContentState>(
              builder: (context, state) {
                if (state is GetUserAppContentLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is GetUserAppContentErrorState) {
                  return SafeArea(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            IconsaxPlusLinear.close_circle,
                            color: primaryColor,
                            size: 120,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.error,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is GetUserAppContentLoadedState) {
                  final faqs = state.model.data?.faq;
                  return SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Column(
                        children: List.generate(faqs?.length ?? 0, (index) {
                          final isExpanded = expandedIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                expandedIndex = isExpanded ? null : index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: titleTextColor.withOpacity(0.03),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Question Row
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          faqs?[index].question?.toString() ??
                                              "Question",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: titleTextColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Icon(
                                        isExpanded
                                            ? IconsaxPlusBold.arrow_up_1
                                            : Icons.arrow_drop_down_rounded,
                                        size: !isExpanded ? 25 : 20,
                                        color: titleTextColor,
                                      ),
                                    ],
                                  ),
                                  // Answer
                                  if (isExpanded) ...[
                                    const SizedBox(height: 6),
                                    AnimatedOpacity(
                                      opacity: isExpanded ? 1 : 0.6,
                                      duration: const Duration(
                                        milliseconds: 800,
                                      ),
                                      child: Text(
                                        faqs?[index].answer?.toString() ??
                                            "Answer",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: greyColor,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
