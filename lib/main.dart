import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/providers/current_user_provider.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final repo = AuthRepository();
  final savedUser = await repo.getStoredUser();

  runApp(
    ProviderScope(
      overrides: [
        currentUserProvider.overrideWith((ref) => savedUser),
      ],
      child: const KynetikApp(),
    ),
  );
}

class KynetikApp extends ConsumerWidget {
  const KynetikApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Kynetik',
      routerConfig: router,
    );
  }
}
