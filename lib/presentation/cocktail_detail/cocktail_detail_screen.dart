import 'package:flutter/material.dart';

import '../../data/cocktails_repository.dart';
import '../../models/cocktail.dart';
import 'tabs/animation_tab.dart';
import 'tabs/recipe_tab.dart';

class CocktailDetailScreen extends StatelessWidget {
  final String cocktailId;

  const CocktailDetailScreen({super.key, required this.cocktailId});

  @override
  Widget build(BuildContext context) {
    final repo = CocktailsRepository.instance;

    return FutureBuilder<Cocktail?>(
      future: repo.getById(cocktailId),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: SafeArea(child: Center(child: CircularProgressIndicator())),
          );
        }

        // Error
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cocktail')),
            body: Center(
              child: Text(
                'Failed to load cocktail.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Not found
        final cocktail = snapshot.data;
        if (cocktail == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cocktail')),
            body: const Center(child: Text('Cocktail not found')),
          );
        }

        // Loaded ✅
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Text(cocktail.name),
                  ),

                  // HERO CARD
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Hero(
                      tag: 'cocktail-card-${cocktail.id}',
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: cocktail.gradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cocktail.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    cocktail.subtitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.auto_awesome,
                              size: 32,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(text: 'Recipe'),
                      Tab(text: 'Animate'),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // TAB CONTENT
                  Expanded(
                    child: TabBarView(
                      children: [
                        RecipeTab(cocktail: cocktail),
                        AnimationTab(cocktail: cocktail),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
