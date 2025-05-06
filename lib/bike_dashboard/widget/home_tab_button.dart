import 'package:flutter/material.dart';


class HomeTabButton extends StatelessWidget {
  const HomeTabButton({
    super.key,
    required this.icon,
    required this.label,
    required this.selected
  });


  final Widget icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = selected;
    final Color activeColor = Theme.of(context).colorScheme.primary;
    final Color inactiveColor = Colors.grey.shade600;

    return TextButton(
      onPressed: () {
      },
      style: TextButton.styleFrom(
        foregroundColor: isSelected ? activeColor : inactiveColor,
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(
              size: 26,
              color: isSelected ? activeColor : inactiveColor,
            ),
            child: icon,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : inactiveColor,
              fontSize: isSelected ? 12 : 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
