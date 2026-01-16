import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';

class TransactionItem {
  final String title;
  final String date;
  final String amount;

  TransactionItem({
    required this.title,
    required this.date,
    required this.amount,
  });
}


class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  final List<TransactionItem> transactions = [
  TransactionItem(title: "Event Name", date: "24-OCT-2025", amount: "50000"),
  TransactionItem(title: "Event Name", date: "24-OCT-2025", amount: "30000"),
  TransactionItem(title: "Event Name", date: "24-OCT-2025", amount: "40000"),
  TransactionItem(title: "Event Name", date: "24-OCT-2025", amount: "60000"),
  TransactionItem(title: "Event Name", date: "24-OCT-2025", amount: "50000"),
  TransactionItem(title: "Event Name", date: "24-OCT-2025", amount: "50000"),
];
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.white),
            child: const Icon(IconsaxPlusBold.arrow_left_3, color: greyColor),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Earnings",
          style: TextStyle(color: titleTextColor, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _totalEarningsCard(),
              const SizedBox(height: 20),
              const Text(
                "Transactions",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final item = transactions[index];
                  return _transactionCard(item);
                },
              ),
          
          ],
        ),
      ),
    );
    
  }
  Widget _totalEarningsCard() {
    return Container(
      width: double.infinity,
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF35B34A), Color(0xFF0E8F2E)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.account_balance_wallet,
              size: 120,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Total Earnings",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "₹ 36546",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ---------------- TRANSACTION CARD ----------------
  Widget _transactionCard(TransactionItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF19A41A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.trending_up,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Date: ${item.date}",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "₹${item.amount}",
            style: const TextStyle(
              color: Color(0xFF19A41A),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}