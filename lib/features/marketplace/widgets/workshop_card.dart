import 'package:flutter/material.dart';
import '../models/workshop.dart';

class WorkshopCard extends StatelessWidget {
  const WorkshopCard({
    super.key,
    required this.workshop,
    required this.onTap,
  });

  final Workshop workshop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // ─────────── Imagen ───────────
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  workshop.imageUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  // 👉 placeholder cuando la URL falla (404, etc.)
                  errorBuilder: (_, __, ___) => Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // ─────────── Datos ───────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workshop.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      workshop.location,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              // ─────────── Rating ───────────
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(workshop.rating.toStringAsFixed(1)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
