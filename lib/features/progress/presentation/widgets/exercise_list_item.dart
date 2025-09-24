import 'package:flutter/material.dart';

class ExerciseListItem extends StatelessWidget {
  final String name;
  final bool completed;
  final bool isRest;
  final VoidCallback? onTap;

  const ExerciseListItem({
    super.key,
    required this.name,
    this.completed = false,
    this.isRest = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(
          isRest ? Icons.hotel : Icons.fitness_center,
          color: isRest
              ? Colors.blueGrey
              : completed
                  ? Colors.grey
                  : Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          name,
          style: TextStyle(
            color: completed || isRest ? Colors.grey : Colors.black87,
            decoration: completed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: completed
            ? const Icon(Icons.check_circle, color: Colors.grey)
            : const Icon(Icons.radio_button_unchecked),
        onTap: onTap,
      ),
    );
  }
}
