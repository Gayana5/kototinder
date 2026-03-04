import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/app_state.dart';
import '../theme/app_theme.dart';
import 'breed_list_page.dart';
import 'cat_swipe_page.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cat Tinder'),
          actions: [
            IconButton(
              tooltip: 'Выйти',
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final appState = context.read<AppState>();
                await appState.signOut();
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: AppTheme.ink,
            indicatorColor: AppTheme.ink,
            tabs: [
              Tab(icon: Icon(Icons.pets), text: 'Котики'),
              Tab(icon: Icon(Icons.list), text: 'Список пород'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CatSwipePage(),
            BreedListPage(),
          ],
        ),
      ),
    );
  }
}
