import 'package:flutter/material.dart';

import 'screens/breed_list_page.dart';
import 'screens/cat_swipe_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CatTinderApp());
}

class CatTinderApp extends StatelessWidget {
  const CatTinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Tinder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const _HomeTabs(),
    );
  }
}

class _HomeTabs extends StatelessWidget {
  const _HomeTabs();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cat Tinder'),
          bottom: const TabBar(
            labelColor: AppTheme.ink,
            indicatorColor: AppTheme.ink,
            tabs: [
              Tab(icon: Icon(Icons.pets), text: 'Котики'),
              Tab(icon: Icon(Icons.list), text: 'Список пород'),
            ],
          ),
        ),
        body: const TabBarView(children: [CatSwipePage(), BreedListPage()]),
      ),
    );
  }
}
