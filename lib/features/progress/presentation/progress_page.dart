import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'widgets/exercise_card.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final _scrollController = ScrollController();
  final _dayKeys = <String, GlobalKey>{};

  final List<String> days = const [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  late final Map<String, List<Map<String, String>>> weeklyPlan;
  late final int todayIndex;

  @override
  void initState() {
    super.initState();

    // Assign GlobalKeys
    for (final day in days) {
      _dayKeys[day] = GlobalKey();
    }

    // Example data
    weeklyPlan = {
      "Monday": [
        {
          "title": "Dumbbell Bench Press",
          "description": "3 sets of 10 reps",
          "duration": "30 min",
          "imageUrl": "https://picsum.photos/id/1011/400/200",
        },
      ],
      "Wednesday": [
        {
          "title": "Romanian Deadlift",
          "description": "4 sets of 8 reps",
          "duration": "30 min",
          "imageUrl": "https://picsum.photos/id/1015/400/200",
        },
      ],
      "Sunday": [
        {
          "title": "Active Recovery",
          "description": "Stretching, foam roll",
          "duration": "20 min",
          "imageUrl": "https://picsum.photos/id/1074/400/200",
        },
      ],
    };

    todayIndex = DateTime.now().weekday - 1;

    // Scroll after first full frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  void _scrollToToday() {
    final today = days[todayIndex];
    final key = _dayKeys[today];

    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    } else {
      // Fallback: jump using ScrollController if ensureVisible fails
      final itemHeight = 250.0; // rough estimate per day block
      _scrollController.animateTo(
        todayIndex * itemHeight,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weekly Progress"),
        leading: IconButton(
          icon: const Icon(LineIcons.angleLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        controller: _scrollController,
        children: days.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          final exercises = weeklyPlan[day] ?? [];

          final isToday = index == todayIndex;

          return Container(
            key: _dayKeys[day],
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: isToday ? Colors.blue.shade100 : null,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    day,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                          color: isToday ? Colors.blue.shade900 : null,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                if (exercises.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Rest day – take it easy!"),
                  )
                else
                  ...exercises.map((ex) => ExerciseCard(
                        title: ex["title"]!,
                        description: ex["description"]!,
                        duration: ex["duration"]!,
                        imageUrl: ex["imageUrl"]!,
                      )),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
