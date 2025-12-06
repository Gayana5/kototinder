import 'package:flutter/material.dart';

import '../models/breed.dart';
import '../theme/app_theme.dart';

class BreedStats extends StatelessWidget {
  const BreedStats({super.key, required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Характеристики',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _StatBar(
          label: 'Дружелюбие',
          value: breed.affectionLevel,
          color: Colors.pinkAccent,
        ),
        _StatBar(
          label: 'Энергичность',
          value: breed.energyLevel,
          color: AppTheme.mint,
        ),
        _StatBar(
          label: 'Интеллект',
          value: breed.intelligence,
          color: Colors.blueAccent,
        ),
        _StatBar(
          label: 'Адаптивность',
          value: breed.adaptability,
          color: AppTheme.amber,
        ),
      ],
    );
  }
}

class _StatBar extends StatelessWidget {
  const _StatBar({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: value / 5,
              backgroundColor: color.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
