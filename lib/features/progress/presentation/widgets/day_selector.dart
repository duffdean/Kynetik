import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final List<String> days;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const DaySelector({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  days[index].substring(0, 3),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
