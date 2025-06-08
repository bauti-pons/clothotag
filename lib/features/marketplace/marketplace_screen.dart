import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/workshop_repository.dart';
import 'widgets/workshop_card.dart';
import 'workshop_detail_screen.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final workshops = context.read<WorkshopRepository>().getAll();
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: workshops.length,
        itemBuilder: (context, index) {
          final workshop = workshops[index];
          return WorkshopCard(
            workshop: workshop,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WorkshopDetailScreen(workshop: workshop),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
