import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/breed.dart';
import '../widgets/breed_stats.dart';

class BreedDetailScreen extends StatelessWidget {
  const BreedDetailScreen({super.key, required this.breed, this.imageUrl});

  final Breed breed;
  final String? imageUrl;

  String? get _fallbackImageUrl => breed.referenceImageId != null
      ? 'https://cdn2.thecatapi.com/images/${breed.referenceImageId}.jpg'
      : null;

  @override
  Widget build(BuildContext context) {
    final resolvedImage = imageUrl ?? _fallbackImageUrl;
    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (resolvedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CachedNetworkImage(
                    imageUrl: resolvedImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 240,
                  ),
                )
              else
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFC7C2), Color(0xFF8AD6CC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Фото недоступно',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                breed.name,
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontSize: 26),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _Chip(
                    icon: Icons.location_pin,
                    label: 'Происхождение',
                    value: breed.origin,
                  ),
                  _Chip(
                    icon: Icons.access_time,
                    label: 'Жизнь',
                    value: '${breed.lifeSpan} лет',
                  ),
                  _Chip(
                    icon: Icons.monitor_weight,
                    label: 'Вес',
                    value: '${breed.weightImperial} lbs',
                  ),
                  _Chip(
                    icon: Icons.pets,
                    label: 'Темперамент',
                    value: breed.temperamentTraits.take(3).join(', '),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                breed.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              BreedStats(breed: breed),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, required this.value});

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
