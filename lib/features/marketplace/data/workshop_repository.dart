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
      'https://bauti-pons.github.io/clothotag-assets/workshops/ecofix.jpg',
    ),
    Workshop(
      id: 'w2',
      name: 'TurboCare Taller',
      location: 'Torremolinos',
      rating: 4.5,
      imageUrl:
      'https://bauti-pons.github.io/clothotag-assets/workshops/cleanride.jpg',
    ),
    Workshop(
      id: 'w3',
      name: 'Green Motors',
      location: ' Marbella',
      rating: 4.2,
      imageUrl:
      'https://bauti-pons.github.io/clothotag-assets/workshops/greenmotors.jpg',
    ),
  ];
}
