import 'package:flutter/material.dart';
import 'router/app_router.dart';

void main() {
  runApp(const KynetikApp());
}

class KynetikApp extends StatelessWidget {
  const KynetikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kynetik',
      routerConfig: appRouter,
    );
  }
}
