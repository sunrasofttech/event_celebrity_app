import 'package:flutter/material.dart';
import 'package:mobi_user/Utility/MainColor.dart';

class CustomTabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomTabSwitcher({Key? key, required this.selectedIndex, required this.onTabSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: onlyShadow()),
      padding: EdgeInsets.all(4),
      child: Row(children: [_buildTab(title: 'Classic', index: 0, context: context), _buildTab(title: 'Advanced', index: 1, context: context)]),
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
          decoration: BoxDecoration(color: isSelected ? Colors.orange : Colors.transparent, borderRadius: BorderRadius.circular(16)),
          child: Center(child: Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.blue.shade900, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}
