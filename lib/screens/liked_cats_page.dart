import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/cat_image.dart';
import 'cat_detail_screen.dart';

class LikedCatsPage extends StatelessWidget {
  const LikedCatsPage({super.key, required this.likedCats, required this.onRemove});

  final List<CatImage> likedCats;
  final void Function(CatImage) onRemove;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Понравившиеся котики'),
      ),
      body: likedCats.isEmpty
          ? const Center(
              child: Text('Пока нет понравившихся котиков.'),
            )
          : ListView.builder(
              itemCount: likedCats.length,
              itemBuilder: (context, index) {
                final cat = likedCats[index];
                return Dismissible(
                  key: ValueKey(cat.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    onRemove(cat);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Удалено из понравившихся')),
                    );
                  },
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: SizedBox(
                      width: 72,
                      height: 72,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: cat.url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(cat.breed?.name ?? 'Неизвестная порода'),
                    subtitle: Text(cat.breed?.temperament ?? ''),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => CatDetailScreen(cat: cat),
                      ));
                    },
                  ),
                );
              },
            ),
    );
  }
}
