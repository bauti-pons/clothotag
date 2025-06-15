import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/workshop_repository.dart';
import 'widgets/workshop_card.dart';
import 'workshop_detail_screen.dart';

/// Pantalla principal del marketplace – lista los talleres disponibles.
class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos el repositorio: si en el futuro pasa a ser remoto/stream,
    // la UI se actualizará automáticamente.
    final workshops = context.watch<WorkshopRepository>().getAll();

    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: workshops.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final workshop = workshops[index];
          return WorkshopCard(
            workshop: workshop,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WorkshopDetailScreen(workshop: workshop),
              ),
            ),
          );
        },
      ),
    );
  }
}
