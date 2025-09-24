// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:line_icons/line_icons.dart';
// import '../widgets/day_selector.dart';
// import '../widgets/exercise_list_item.dart';

// class ProgressPage extends StatefulWidget {
//   const ProgressPage({super.key});

//   @override
//   State<ProgressPage> createState() => _ProgressPageState();
// }

// class _ProgressPageState extends State<ProgressPage> {
//   int _currentWeekOffset = 0;
//   int _selectedDayIndex = DateTime.now().weekday - 1;

//   final Map<String, List<Map<String, dynamic>>> weeklyPlan = {
//     "Monday": [
//       {"name": "Bench Press", "completed": true},
//       {"name": "Squats", "completed": false},
//     ],
//     "Tuesday": [
//       {"name": "Rest Day", "rest": true},
//     ],
//     "Wednesday": [
//       {"name": "Deadlift", "completed": false},
//     ],
//     "Thursday": [
//       {"name": "Running (5km)", "completed": true},
//     ],
//     "Friday": [
//       {"name": "Bicep Curls", "completed": false},
//     ],
//     "Saturday": [
//       {"name": "Yoga", "completed": false},
//     ],
//     "Sunday": [
//       {"name": "Rest Day", "rest": true},
//     ],
//   };

//   @override
//   Widget build(BuildContext context) {
//     final days = weeklyPlan.keys.toList();
//     final selectedDay = days[_selectedDayIndex];
//     final exercises = weeklyPlan[selectedDay]!;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Weekly Progress"),
//         leading: IconButton(
//           icon: const Icon(LineIcons.angleLeft),
//           onPressed: () => context.pop(),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(LineIcons.arrowLeft),
//             onPressed: () => setState(() => _currentWeekOffset--),
//           ),
//           IconButton(
//             icon: const Icon(LineIcons.arrowRight),
//             onPressed: () => setState(() => _currentWeekOffset++),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Text(
//               "Week ${_currentWeekOffset == 0 ? 'Current' : _currentWeekOffset > 0 ? '+$_currentWeekOffset' : '$_currentWeekOffset'}",
//               style: Theme.of(context).textTheme.titleLarge,
//             ),
//           ),
//           DaySelector(
//             days: days,
//             selectedIndex: _selectedDayIndex,
//             onSelected: (index) => setState(() => _selectedDayIndex = index),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: ListView.builder(
//               itemCount: exercises.length,
//               itemBuilder: (context, i) {
//                 final ex = exercises[i];
//                 return ExerciseListItem(
//                   name: ex['name'],
//                   completed: ex['completed'] == true,
//                   isRest: ex['rest'] == true,
//                   onTap: () {
//                     setState(() {
//                       exercises[i]['completed'] = !(ex['completed'] == true);
//                     });
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';

import '../widgets/exercise_card.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock weekly plan data
    final weeklyPlan = {
      "Monday": [
        {
          "title": "Bench Press",
          "description": "4 sets of 8 reps, focus on form",
          "duration": "30 min",
          "imageUrl": "https://picsum.photos/400/200?1",
        },
        {
          "title": "Squats",
          "description": "5 sets of 5 reps",
          "duration": "40 min",
          "imageUrl": "https://picsum.photos/400/200?2",
        },
      ],
      "Tuesday": [
        {
          "title": "Yoga Flow",
          "description": "Balance, mobility, and flexibility work",
          "duration": "45 min",
          "imageUrl": "https://picsum.photos/400/200?3",
        },
      ],
      "Wednesday": [
        {
          "title": "Deadlifts",
          "description": "Progressive overload session",
          "duration": "35 min",
          "imageUrl": "https://picsum.photos/400/200?4",
        },
      ],
      "Thursday": [],
      "Friday": [
        {
          "title": "Running",
          "description": "5km endurance run",
          "duration": "25 min",
          "imageUrl": "https://picsum.photos/400/200?5",
        },
      ],
      "Saturday": [
        {
          "title": "Core Blast",
          "description": "Abs circuit, 3 rounds",
          "duration": "20 min",
          "imageUrl": "https://picsum.photos/400/200?6",
        },
      ],
      "Sunday": [
        {
          "title": "Rest Day",
          "description": "Recovery & stretching",
          "duration": "All day",
          "imageUrl": "https://picsum.photos/400/200?7",
        },
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weekly Progress"),
        leading: IconButton(
          icon: const Icon(LineIcons.angleLeft),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        children: weeklyPlan.entries.map((entry) {
          final day = entry.key;
          final exercises = entry.value;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    day,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 8),

                // Exercises for the day
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
