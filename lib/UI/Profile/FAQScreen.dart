import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int? expandedIndex;

  final faqs = [
    {
      "question": "How do I manage all the notifications on the App?",
      "answer":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
          "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
          "when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    },
    {
      "question": "How do I manage all the notifications on the App?",
      "answer":
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
          "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, "
          "when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    },
    {
      "question": "How can I add/ modify the payment method?",
      "answer":
          "Go to your account settings, choose 'Payment Methods' and select 'Add New' or 'Edit Existing' to modify payment details.",
    },
    {
      "question": "How can I reach the customer support?",
      "answer":
          "You can contact our support team via the 'Chat with Us' option in the Support section or email us at help@yourapp.com.",
    },
    {
      "question": "How do I manage all the notifications on the App?",
      "answer": "In the Notification Settings section, you can enable or disable specific types of notifications.",
    },
  ];

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
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      icon: const Icon(IconsaxPlusBold.arrow_left_3, color: greyColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text("FAQs", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: titleTextColor)),
                ],
              ),
            ),

            // ---------- FAQ List ----------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  children: List.generate(faqs.length, (index) {
                    final isExpanded = expandedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          expandedIndex = isExpanded ? null : index; // toggle expand
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    faqs[index]['question']!,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: titleTextColor),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  isExpanded ? IconsaxPlusBold.arrow_up_1 : Icons.arrow_drop_down_rounded,
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
                                duration: const Duration(milliseconds: 800),
                                child: Text(
                                  faqs[index]['answer']!,
                                  style: TextStyle(fontSize: 14, color: greyColor, height: 1.4),
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
            ),
          ],
        ),
      ),
    );
  }
}
