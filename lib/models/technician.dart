/// Modelo de técnico.
/// OJO: por ahora los datos son de EJEMPLO (mock). Más adelante vendrán del backend.
class Technician {
  final String name;
  final String specialty;
  final double rating;
  final int reviews;
  final double distanceKm;
  final bool available;
  final int priceFrom; // pesos colombianos
  final String modality;

  const Technician({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviews,
    required this.distanceKm,
    required this.available,
    required this.priceFrom,
    required this.modality,
  });

  /// Ejemplo: 25000 -> "25.000"
  String get priceFormatted => priceFrom
      .toString()
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
}

// DATOS DE EJEMPLO (mock). No son técnicos reales.
const mockTechnicians = <Technician>[
  Technician(
    name: 'Andrés R. (demo)',
    specialty: 'Celulares',
    rating: 4.8,
    reviews: 124,
    distanceKm: 1.2,
    available: true,
    priceFrom: 35000,
    modality: 'Local y domicilio',
  ),
  Technician(
    name: 'Laura M. (demo)',
    specialty: 'Computadores',
    rating: 4.9,
    reviews: 87,
    distanceKm: 2.5,
    available: true,
    priceFrom: 50000,
    modality: 'Local',
  ),
  Technician(
    name: 'Camilo P. (demo)',
    specialty: 'Televisores',
    rating: 4.5,
    reviews: 41,
    distanceKm: 3.1,
    available: false,
    priceFrom: 60000,
    modality: 'Domicilio',
  ),
  Technician(
    name: 'Sofía G. (demo)',
    specialty: 'Celulares',
    rating: 4.6,
    reviews: 59,
    distanceKm: 4.0,
    available: true,
    priceFrom: 30000,
    modality: 'Local',
  ),
  Technician(
    name: 'Julián T. (demo)',
    specialty: 'Otros',
    rating: 4.4,
    reviews: 23,
    distanceKm: 5.3,
    available: true,
    priceFrom: 40000,
    modality: 'Local y domicilio',
  ),
];