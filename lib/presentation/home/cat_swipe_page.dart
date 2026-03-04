import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di/app_dependencies.dart';
import '../../domain/entities/cat_image.dart';
import '../theme/app_theme.dart';
import 'cat_detail_screen.dart';
import 'cat_swipe_controller.dart';
import 'liked_cats_page.dart';

class CatSwipePage extends StatefulWidget {
  const CatSwipePage({super.key});

  @override
  State<CatSwipePage> createState() => _CatSwipePageState();
}

class _CatSwipePageState extends State<CatSwipePage> {
  late final CatSwipeController _controller;

  @override
  void initState() {
    super.initState();
    final dependencies = context.read<AppDependencies>();
    _controller = CatSwipeController(dependencies.getRandomCat);
    _controller.loadNextCat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openDetails(CatImage cat) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CatDetailScreen(cat: cat)),
    );
  }

  Future<void> _showErrorDialog(String message) async {
    if (!mounted) {
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _controller.loadNextCat();
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(CatSwipeController controller) {
    final cat = controller.currentCat;
    if (cat == null) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      ignoring: controller.isLoading,
      child: Dismissible(
        key: ValueKey(cat.id),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          final wasLiked = direction == DismissDirection.startToEnd;
          controller.loadNextCat(liked: wasLiked);
        },
        child: GestureDetector(
          onTap: () => _openDetails(cat),
          child: Hero(
            tag: 'cat-${cat.id}',
            child: SizedBox(
              height: 520,
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedNetworkImage(
                        imageUrl: cat.url,
                        fit: BoxFit.cover,
                        placeholder: (context, _) => Container(
                          color: AppTheme.blush.withValues(alpha: 0.3),
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                        errorWidget: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black54],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              cat.breed?.name ?? 'Неизвестная порода',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cat.breed?.temperament ?? 'Нажмите, чтобы узнать больше',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _controller,
      child: Consumer<CatSwipeController>(
        builder: (context, controller, _) {
          final error = controller.error;
          if (error != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller.clearError();
              _showErrorDialog(error);
            });
          }

          final theme = Theme.of(context);
          return SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: -80,
                  left: -40,
                  child: Container(
                    height: 220,
                    width: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.blush.withValues(alpha: 0.35),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -60,
                  right: -20,
                  child: Container(
                    height: 260,
                    width: 260,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.mint.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cat Tinder',
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  fontSize: 28,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Свайпайте пушистиков и находите любимчиков.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => LikedCatsPage(
                                  likedCats: controller.likedCats,
                                  onRemove: controller.removeLiked,
                                ),
                              ));
                            },
                            child: Chip(
                              backgroundColor: AppTheme.amber.withValues(alpha: 0.25),
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text('${controller.likes}'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: controller.isLoading && controller.currentCat == null
                              ? const CircularProgressIndicator()
                              : _buildCard(controller),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Column(
                        children: [
                          Text(
                            'Смахните влево или вправо, либо используйте кнопки ниже.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: controller.isLoading
                                    ? null
                                    : () => controller.loadNextCat(),
                                icon: const Icon(Icons.close, color: Colors.white),
                                label: const Text('Дизлайк'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey.shade600,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: controller.isLoading
                                    ? null
                                    : () => controller.loadNextCat(liked: true),
                                icon: const Icon(Icons.favorite, color: Colors.white),
                                label: const Text('Лайк'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
