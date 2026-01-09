import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/auth_controller.dart';
import '../../state/favorites_controller.dart';
import '../creator/creator_screen.dart';
import '../discover/discover_screen.dart';
import '../favorites/favorites_screen.dart';
import '../search/search_screen.dart';

class CocktailShell extends StatefulWidget {
  const CocktailShell({super.key});

  @override
  State<CocktailShell> createState() => _CocktailShellState();
}

class _CocktailShellState extends State<CocktailShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final favoritesCtrl = context.watch<FavoritesController>();
    final auth = context.read<AuthController>();

    Widget body;
    switch (_index) {
      case 0:
        body = DiscoverScreen(
          favorites: favoritesCtrl.favorites,
          onToggleFavorite: (id) => favoritesCtrl.toggle(id),
        );
        break;
      case 1:
        body = SearchScreen(
          favorites: favoritesCtrl.favorites,
          onToggleFavorite: (id) => favoritesCtrl.toggle(id),
        );
        break;
      case 2:
        body = FavoritesScreen(
          favorites: favoritesCtrl.favorites,
          onToggleFavorite: (id) => favoritesCtrl.toggle(id),
        );
        break;
      case 3:
      default:
        body = const CreatorScreen();
        break;
    }

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Cocktail Studio'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () => auth.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF050816),
              scheme.primary.withOpacity(0.35),
              const Color(0xFF030712),
            ],
          ),
        ),
        child: SafeArea(child: body),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: scheme.primary.withOpacity(0.12),
          backgroundColor: Colors.black.withOpacity(0.7),
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.local_bar_outlined),
              selectedIcon: Icon(Icons.local_bar),
              label: 'Discover',
            ),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(
              icon: Icon(Icons.star_border),
              selectedIcon: Icon(Icons.star),
              label: 'Favorites',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome),
              label: 'Create',
            ),
          ],
        ),
      ),
    );
  }
}
