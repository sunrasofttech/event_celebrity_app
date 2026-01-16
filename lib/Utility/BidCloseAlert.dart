import 'package:flutter/material.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';

class BidCloseAlert {
  static void showClosedForTodayDialog(BuildContext context, {required String? message, required String? marketName}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Image
                Image.asset('asset/icons/betting_close.png'),

                // Responsive Text in between models
                Positioned(
                  bottom: screenHeight * 0.14, // Adjust percentage as needed (0.27 = ~27% of screen height)
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      message ?? "Today is Closed",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ),
                ),

                // Responsive Text in between models
                Positioned(
                  bottom: screenHeight * 0.085, // Adjust percentage as needed (0.27 = ~27% of screen height)
                  left: screenHeight * 0.075,
                  right: screenHeight * 0.075,
                  child: Center(
                    child: Text(
                      "Try ${marketName ?? "Another"} Market",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    /*showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background Image
                Image.asset('asset/icons/betting_close.png'), // Replace with your "Group 5.png" image
                // Text in between models
                Positioned(
                  top: 170, // Adjust based on design
                  left: 95,
                  right: 95,
                  child: Center(
                    child: Text(
                      message ?? "Today is Closed",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                // // Text on Orange Button
                // Positioned(
                //   bottom: 45, // Adjust to place it on the orange button
                //   left: 12,
                //   right: 12,
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.of(context).pop();
                //     },
                //     child: SizedBox(
                //       width: double.infinity,
                //       child: Center(
                //         child: Text(
                //           "Try Another Market",
                //           style: TextStyle(
                //             fontSize: 18,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white,
                //             shadows: [Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 2)],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
        */ /*return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Top Cross Icon
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: primaryColor,
                  child: Icon(Icons.close, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 12),

                /// Title
                Text(marketTitle ?? "SURYA MORNING", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                /// Subtext
                Text(
                  message ?? "Closed for Today",
                  style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),

                /// Time Table
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildTimeRow("Open Bid Last Time :", openBidLastTime ?? "09:00 AM"),
                      _buildTimeRow("Open Result Time :", openResultTime ?? "09:05 AM"),
                      _buildTimeRow("Close Bid Last Time :", closeBidLastTime ?? "10:00 AM"),
                      _buildTimeRow("Close Result Time :", closeResultTime ?? "10:05 AM"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// OK Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );*/ /*
      },
    );*/
  }

  /// Function to build a row for bid times
  static Widget _buildTimeRow(String title, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: primaryColor, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          Text(time, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
