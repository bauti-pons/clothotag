import 'package:flutter/material.dart';
import 'models/workshop.dart';
import 'chat/chat_room_screen.dart';

class WorkshopDetailScreen extends StatelessWidget {
  const WorkshopDetailScreen({super.key, required this.workshop});

  final Workshop workshop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(workshop.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen con placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                workshop.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child:
                  const Icon(Icons.image_not_supported_rounded, size: 48),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(workshop.location,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(workshop.rating.toStringAsFixed(1)),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.chat),
                label: const Text('Chat con taller'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoomScreen(roomId: workshop.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
