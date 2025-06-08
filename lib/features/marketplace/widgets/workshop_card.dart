import 'package:flutter/material.dart';
import '../models/workshop.dart';

class WorkshopCard extends StatelessWidget {
  const WorkshopCard({super.key, required this.workshop, this.onTap});

  final Workshop workshop;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Image.network(workshop.imageUrl,
                height: 120, width: double.infinity, fit: BoxFit.cover),
            ListTile(
              title: Text(workshop.name),
              subtitle: Text(workshop.location),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  Text(workshop.rating.toStringAsFixed(1)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
