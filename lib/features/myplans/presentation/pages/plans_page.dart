import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/plan_list_item.dart';
import 'package:line_icons/line_icons.dart';

class PlansPage extends StatelessWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      {
        'icon': Icons.fitness_center,
        'title': 'Strength Training',
        'subtitle': '4 days/week • Upper/Lower split',
        'progress': 0.7,
      },
      {
        'icon': Icons.directions_run,
        'title': 'Rehab Program',
        'subtitle': 'Knee stability & mobility',
        'progress': 0.4,
      },
      {
        'icon': Icons.self_improvement,
        'title': 'Mind & Body',
        'subtitle': 'Yoga & recovery plan',
        'progress': 0.9,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Plans'),
        leading: IconButton(
          icon: const Icon(LineIcons.angleLeft), // 👈 custom back icon
          onPressed: () => context.pop(), // go_router's back navigation
        ),
      ),
      body: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return PlanListItem(
            icon: plan['icon'] as IconData,
            title: plan['title'] as String,
            subtitle: plan['subtitle'] as String,
            progress: plan['progress'] as double,
          );
        },
      ),
    );
  }
}
