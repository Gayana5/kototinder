import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/cat_image.dart';
import '../theme/app_theme.dart';
import '../widgets/breed_stats.dart';

class CatDetailScreen extends StatelessWidget {
  const CatDetailScreen({super.key, required this.cat});

  final CatImage cat;

  @override
  Widget build(BuildContext context) {
    final breed = cat.breed;
    return Scaffold(
      appBar: AppBar(title: Text(breed?.name ?? 'Подробности')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'cat-${cat.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CachedNetworkImage(
                    imageUrl: cat.url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 260,
                    placeholder: (context, _) => Container(
                      height: 260,
                      color: AppTheme.blush.withValues(alpha: 0.3),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                breed?.name ?? 'Неизвестная порода',
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 8),
              if (breed != null)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _InfoChip(
                      icon: Icons.public,
                      label: 'Происхождение',
                      value: breed.origin,
                    ),
                    _InfoChip(
                      icon: Icons.favorite,
                      label: 'Темперамент',
                      value: breed.temperamentTraits.take(3).join(', '),
                    ),
                    _InfoChip(
                      icon: Icons.timer,
                      label: 'Продолжительность жизни',
                      value: '${breed.lifeSpan} лет',
                    ),
                    _InfoChip(
                      icon: Icons.monitor_weight,
                      label: 'Вес',
                      value: '${breed.weightImperial} lbs',
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              Text(
                breed?.description ?? 'Описание пока отсутствует.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              if (breed != null) BreedStats(breed: breed),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.pinkAccent),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
