import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di/app_dependencies.dart';
import '../../domain/entities/breed.dart';
import '../theme/app_theme.dart';
import 'breed_detail_screen.dart';
import 'breed_list_controller.dart';

class BreedListPage extends StatefulWidget {
  const BreedListPage({super.key});

  @override
  State<BreedListPage> createState() => _BreedListPageState();
}

class _BreedListPageState extends State<BreedListPage> {
  late final BreedListController _controller;

  @override
  void initState() {
    super.initState();
    final dependencies = context.read<AppDependencies>();
    _controller = BreedListController(dependencies.getBreeds);
    _controller.loadBreeds();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await _controller.loadBreeds();
  }

  void _openBreed(Breed breed) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BreedDetailScreen(
          breed: breed,
          imageUrl: breed.referenceImageId != null
              ? 'https://cdn2.thecatapi.com/images/${breed.referenceImageId}.jpg'
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<BreedListController>(
        builder: (context, controller, _) {
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: controller.isLoading && controller.breeds.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : controller.error != null
                      ? ListView(
                          children: [
                            const SizedBox(height: 140),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      size: 48,
                                      color: Colors.redAccent,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      controller.error ??
                                          'Не удалось загрузить список пород.\nПотяните вниз, чтобы повторить.',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: controller.breeds.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: TextField(
                                  key: const ValueKey('breeds.search'),
                                  decoration: const InputDecoration(
                                    hintText: 'Поиск по породам',
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: controller.updateQuery,
                                ),
                              );
                            }
                            final breed = controller.breeds[index - 1];
                            return _BreedCard(breed: breed, onTap: () => _openBreed(breed));
                          },
                        ),
            ),
          );
        },
      ),
    );
  }
}

class _BreedCard extends StatelessWidget {
  const _BreedCard({required this.breed, required this.onTap});

  final Breed breed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = breed.name;
    final initials = name.isNotEmpty ? name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase() : '--';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFEFEA), Color(0xFFE8FCF8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.blush.withValues(alpha: 0.7),
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    breed.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    breed.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _Tag(icon: Icons.public, label: breed.origin),
                      _Tag(
                        icon: Icons.access_time,
                        label: '${breed.lifeSpan} лет',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
