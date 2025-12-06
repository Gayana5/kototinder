import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/cat_image.dart';
import '../services/cat_api_service.dart';
import '../theme/app_theme.dart';
import 'cat_detail_screen.dart';
import 'liked_cats_page.dart';

class CatSwipePage extends StatefulWidget {
  const CatSwipePage({super.key});

  @override
  State<CatSwipePage> createState() => _CatSwipePageState();
}

class _CatSwipePageState extends State<CatSwipePage> {
  final CatApiService _apiService = CatApiService();
  CatImage? _currentCat;
  bool _isLoading = false;
  int _likes = 0;
  final List<CatImage> _likedCats = [];

  @override
  void initState() {
    super.initState();
    _loadNextCat();
  }

  Future<void> _loadNextCat({bool liked = false}) async {
    if (liked) {
      if (_currentCat != null && !_likedCats.any((c) => c.id == _currentCat!.id)) {
        setState(() => _likedCats.add(_currentCat!));
      }
      setState(() => _likes = _likedCats.length);
    }
    setState(() => _isLoading = true);
    try {
      final cat = await _apiService.fetchRandomCat();
      if (!mounted) return;
      setState(() => _currentCat = cat);
    } catch (e) {
      await _showErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showErrorDialog(String message) async {
    if (!mounted) return;
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
              _loadNextCat();
            },
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  void _openDetails() {
    final cat = _currentCat;
    if (cat == null) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => CatDetailScreen(cat: cat)));
  }

  Widget _buildCard() {
    final cat = _currentCat;
    if (cat == null) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      ignoring: _isLoading,
      child: Dismissible(
        key: ValueKey(cat.id),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          final wasLiked = direction == DismissDirection.startToEnd;
          // Immediately remove the current card from the tree to avoid the
          // "A dismissed Dismissible widget is still part of the tree" error.
          setState(() {
            if (wasLiked && !_likedCats.any((c) => c.id == cat.id)) {
              _likedCats.add(cat);
            }
            _currentCat = null;
            _isLoading = true;
            _likes = _likedCats.length;
          });

          // Load next cat (we already handled adding to liked list above)
          _loadNextCat(liked: false);
        },
        child: GestureDetector(
          onTap: _openDetails,
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
                              cat.breed?.temperament ??
                                  'Нажмите, чтобы узнать больше',
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
                            likedCats: _likedCats,
                            onRemove: (cat) {
                              setState(() {
                                _likedCats.removeWhere((c) => c.id == cat.id);
                                _likes = _likedCats.length;
                              });
                            },
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
                          Text('$_likes'),
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
                    child: _isLoading && _currentCat == null
                        ? const CircularProgressIndicator()
                        : _buildCard(),
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
                          onPressed: _isLoading ? null : () => _loadNextCat(),
                          icon: const Icon(Icons.close, color: Colors.white),
                          label: const Text('Дизлайк'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey.shade600,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _isLoading
                              ? null
                              : () => _loadNextCat(liked: true),
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
  }
}
