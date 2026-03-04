class Breed {
  const Breed({
    required this.id,
    required this.name,
    required this.description,
    required this.temperament,
    required this.origin,
    required this.lifeSpan,
    required this.weightImperial,
    required this.adaptability,
    required this.intelligence,
    required this.affectionLevel,
    required this.energyLevel,
    this.referenceImageId,
  });

  final String id;
  final String name;
  final String description;
  final String temperament;
  final String origin;
  final String lifeSpan;
  final String weightImperial;
  final int adaptability;
  final int intelligence;
  final int affectionLevel;
  final int energyLevel;
  final String? referenceImageId;

  List<String> get temperamentTraits => temperament
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  factory Breed.fromJson(Map<String, dynamic> json) {
    final weight = json['weight'] as Map<String, dynamic>?;
    return Breed(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Неизвестная порода',
      description: json['description'] as String? ?? 'Описание недоступно.',
      temperament: json['temperament'] as String? ?? 'Характер неизвестен',
      origin: json['origin'] as String? ?? 'Неизвестно',
      lifeSpan: json['life_span'] as String? ?? '—',
      weightImperial: weight != null
          ? (weight['imperial'] as String? ?? '—')
          : '—',
      adaptability: (json['adaptability'] as num?)?.toInt() ?? 0,
      intelligence: (json['intelligence'] as num?)?.toInt() ?? 0,
      affectionLevel: (json['affection_level'] as num?)?.toInt() ?? 0,
      energyLevel: (json['energy_level'] as num?)?.toInt() ?? 0,
      referenceImageId: json['reference_image_id'] as String?,
    );
  }
}
