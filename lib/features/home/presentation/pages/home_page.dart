import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../auth/presentation/providers/current_user_provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = AuthRepository();
    final user = ref.watch(currentUserProvider);
    final name = user?.name ?? 'Athlete';

    return Scaffold(
      appBar: AppBar(
        title: Text('Kynetik',
            style: GoogleFonts.montserrat(fontSize: 24, color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(LineIcons.userCircle),
            onPressed: () async {
              await repo.logout();
              ref.read(currentUserProvider.notifier).state = null;
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, $name 👋',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // --- Feature Cards ---
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  FeatureCard(
                    icon: LineIcons.dumbbell,
                    title: 'Bookings',
                    onTap: () => context.push('/bookings'),
                  ),
                  FeatureCard(
                    icon: LineIcons.utensils,
                    title: 'Macros',
                  ),
                  FeatureCard(
                    icon: LineIcons.video,
                    title: '1-to-1 Coaching',
                  ),
                  FeatureCard(
                    icon: LineIcons.lineChart,
                    title: 'Progress',
                    onTap: () => context.push('/progress'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
