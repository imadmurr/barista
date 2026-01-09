import 'package:flutter/material.dart';

import '../../data/cocktails_repository.dart';
import '../../models/cocktail.dart';
import '../shared/widgets/cocktail_card.dart';

class DiscoverScreen extends StatefulWidget {
  final Set<String> favorites;
  final void Function(String id) onToggleFavorite;

  const DiscoverScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _selectedCategory = 'All';
  String _query = '';

  final _repo = CocktailsRepository.instance;

  final categories = const [
    'All',
    'Tropical',
    'Citrus',
    'Mocktail',
    'Sparkling',
    'Herbal',
    'Berry',
    'Creamy',
    'Sweet',
    'Exotic',
    'Mint',
    'Fresh',
    'Fruity',
  ];

  List<Cocktail> _applyFilters(List<Cocktail> cocktails) {
    return cocktails.where((c) {
      final matchesCategory = _selectedCategory == 'All'
          ? true
          : c.tags.any(
              (t) => t.toLowerCase() == _selectedCategory.toLowerCase(),
            );

      final q = _query.trim().toLowerCase();
      final matchesQuery = q.isEmpty
          ? true
          : (c.name.toLowerCase().contains(q) ||
                c.subtitle.toLowerCase().contains(q));

      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            const _AppHeader(),
            const SizedBox(height: 12),

            // SEARCH INPUT
            TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search drinks, flavors, vibes…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white.withOpacity(.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(color: Colors.white.withOpacity(.12)),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // HORIZONTAL CATEGORY CHIPS
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final label = categories[i];
                  final selected = _selectedCategory == label;

                  return ChoiceChip(
                    selected: selected,
                    label: Text(label),
                    onSelected: (_) {
                      setState(() => _selectedCategory = label);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // GRID — takes remaining space
            Expanded(
              child: StreamBuilder<List<Cocktail>>(
                stream: _repo.watchDiscover(limit: 60),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Failed to load cocktails.\n${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final cocktails = snapshot.data ?? const <Cocktail>[];
                  final filtered = _applyFilters(cocktails);

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text('No cocktails match your search.'),
                    );
                  }

                  return GridView.builder(
                    itemCount: filtered.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: .72,
                        ),
                    itemBuilder: (_, i) {
                      final c = filtered[i];
                      return CocktailCard(
                        cocktail: c,
                        isFavorite: widget.favorites.contains(c.id),
                        onToggleFavorite: () => widget.onToggleFavorite(c.id),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discover',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Find your perfect drink',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
