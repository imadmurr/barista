import 'package:flutter/material.dart';

import '../../data/cocktails_repository.dart';
import '../../models/cocktail.dart';
import '../shared/widgets/cocktail_list_tile.dart';

class SearchScreen extends StatefulWidget {
  final Set<String> favorites;
  final void Function(String id) onToggleFavorite;

  const SearchScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  final _repo = CocktailsRepository.instance;

  List<Cocktail> _filter(List<Cocktail> cocktails) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return cocktails;

    return cocktails.where((c) {
      return c.name.toLowerCase().contains(q) ||
          c.subtitle.toLowerCase().contains(q) ||
          c.tags.any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (v) => setState(() => query = v),
            decoration: InputDecoration(
              hintText: 'Search cocktails...',
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
          Expanded(
            child: StreamBuilder<List<Cocktail>>(
              stream: _repo.watchAllForSearch(limit: 250),
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

                final all = snapshot.data ?? const <Cocktail>[];
                final results = _filter(all);

                if (results.isEmpty) {
                  return const Center(child: Text('No cocktails found'));
                }

                return ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final c = results[i];
                    return CocktailListTile(
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
    );
  }
}
