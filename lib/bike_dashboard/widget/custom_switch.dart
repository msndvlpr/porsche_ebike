import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {

  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          value ? "Dark" : "Light",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: value ? Colors.white38 : Colors.black54),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: 74,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: value ? Colors.black : Colors.white,
              border: Border.all(color: Colors.grey, width: 1.3),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.wb_sunny,
                      color: value ? Colors.white30 : Colors.black,
                      size: 22,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.nightlight_round,
                      color: value ? Colors.white : Colors.black26,
                      size: 22,
                    ),
                  ),
                ),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      value ? Icons.nightlight_round : Icons.wb_sunny,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}