import '../models/workshop.dart';

class WorkshopRepository {
  const WorkshopRepository();

  List<Workshop> getAll() => const [
    Workshop(
      id: 'w1',
      name: 'EcoFix Garage',
      location: 'Málaga Centro',
      rating: 4.8,
      imageUrl:
      'https://images.unsplash.com/photo-1581093458791-10d286e6819a?w=640',
    ),
    Workshop(
      id: 'w2',
      name: 'TurboCare Taller',
      location: 'Torremolinos',
      rating: 4.5,
      imageUrl:
      'https://images.unsplash.com/photo-1609108384760-d334a4aa8d13?w=640',
    ),
    Workshop(
      id: 'w3',
      name: 'Green Motors',
      location: ' Marbella',
      rating: 4.2,
      imageUrl:
      'https://images.unsplash.com/photo-1515923162033-1c3f50af5d04?w=640',
    ),
  ];
}
