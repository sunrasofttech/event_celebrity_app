import 'package:flutter/material.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';

class CustomTabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomTabSwitcher({Key? key, required this.selectedIndex, required this.onTabSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        // color: Colors.white,
        gradient: linearGradient(),
        borderRadius: BorderRadius.circular(12) /*boxShadow: onlyShadow()*/,
      ),
      padding: EdgeInsets.all(4),
      child: Row(
        children: [
          _buildTab(title: 'EASY MODE', index: 0, context: context),
          const SizedBox(width: 10),
          _buildTab(title: 'SPECIAL MODE', index: 1, context: context),
        ],
      ),
    );
  }

  Expanded _buildTab({required String title, required int index, required BuildContext context}) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      colors: [greenColor, greenColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : LinearGradient(
                      colors: [whiteColor, whiteColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(color: isSelected ? Colors.black : Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
