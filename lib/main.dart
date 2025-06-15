import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/home/home_screen.dart';
import 'features/marketplace/data/workshop_repository.dart';   // ← repo mock

void main() {
  runApp(const ClothoTagApp());
}

class ClothoTagApp extends StatelessWidget {
  const ClothoTagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 👇 El repo estará disponible en todo el árbol de widgets
        Provider<WorkshopRepository>(
          create: (_) => WorkshopRepository(),
        ),
      ],
      child: MaterialApp(
        title: 'ClothoTag',
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
          ColorScheme.fromSeed(seedColor: Colors.indigo).copyWith(
            surface: const Color(0xFFF9F3FC),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
